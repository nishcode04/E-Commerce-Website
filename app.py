from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_sqlalchemy import SQLAlchemy
import mysql.connector
from werkzeug.security import check_password_hash
app = Flask(__name__)
app.secret_key = 'dbms_project'
#Database connection configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'Vishnu2924',
    'database': 'dbms_project',
    'auth_plugin' :'mysql_native_password'
}

# Connect to the database
db = mysql.connector.connect(**db_config)
cursor = db.cursor(dictionary=True)
if not db:
    print('Connection to database failed')

@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')

        # Fetch user by email
        cursor.execute("SELECT CustomerID, PasswordHash FROM Customers WHERE Email = %s", (email,))
        user = cursor.fetchone()
        print(email,password)

        if user:
            # Retrieve user details
            customer_id = user['CustomerID']
            password_hash = user['PasswordHash']

            # Verify password
            if password_hash == password:
                # Store user session
                session['customer_id'] = customer_id
                flash('Login successful!', 'success')
                return redirect(url_for('dashboard',customer_id = customer_id))  # Redirect to a protected route
            else:
                flash('Invalid email or password.', 'danger')
        else:
            flash('User not found.', 'danger')

    return render_template('login.html')


    
@app.route('/dashboard/<int:customer_id>')
def dashboard(customer_id):
    cursor = db.cursor(dictionary=True)

    # Fetch customer details
    cursor.execute("SELECT * FROM Customers WHERE CustomerID = %s", (customer_id,))
    customer = cursor.fetchone()

    # Fetch recent orders
    cursor.execute("""
    SELECT 
    p.ProductName, 
    o.OrderDate, 
    o.Quantity, 
        SUM(o.Price * o.Quantity) AS TotalPrice,
        SUM(o.Price * o.Quantity - o.Discount) AS DiscountedPrice
    FROM 
        Orders o
    JOIN 
        Customers c ON c.CustomerID = o.CustomerID
    JOIN 
        Products p ON p.ProductID = o.ProductID
    WHERE 
        o.CustomerID = %s
    GROUP BY 
        p.ProductName, o.OrderDate, o.Quantity
    ORDER BY 
        o.OrderDate DESC
    LIMIT 5
    """, (customer_id,))
    orders = cursor.fetchall()

    # Fetch cart items
    cursor.execute("""
        SELECT p.ProductName, c.Quantity, c.Price
        FROM Cart c
        JOIN Products p ON c.ProductID = p.ProductID
        WHERE c.CustomerID = %s
    """, (customer_id,))
    cart_items = cursor.fetchall()

    order_count_query = "SELECT GetCustomerOrderCount(%s) AS TotalOrderCount"
    cursor.execute(order_count_query, (customer_id,))
    total_order_count = cursor.fetchone()['TotalOrderCount']

    spending_query = "SELECT GetTotalCustomerSpending(%s) AS TotalSpending"
    cursor.execute(spending_query, (customer_id,))
    total_spending = cursor.fetchone()['TotalSpending']

    return render_template('dashboard.html', customer=customer, orders=orders, cart_items=cart_items,total_order_count=total_order_count,total_spending=total_spending)



@app.route('/products')
def products():
    if 'customer_id' not in session:
        flash("Please log in to view products.", "error")
        return redirect(url_for('login'))
    
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Products")
    products = cursor.fetchall()
    cursor.close()
    return render_template('products.html', products=products)

@app.route('/add-to-cart', methods=['POST'])
def add_to_cart():
    customer_id = session.get('customer_id')
    product_id = request.form['product_id']
    quantity = int(request.form['quantity'])
    cursor.execute("SELECT Price, Stock FROM Products WHERE ProductID = %s", (product_id,))
    product = cursor.fetchone()
    if not product:
        flash('Product not found.', 'error')
        return redirect(url_for('products'))
    
    price = product['Price']
    cursor.execute(
        "SELECT Quantity FROM Cart WHERE CustomerID = %s AND ProductID = %s",
        (customer_id, product_id)
    )
    cart_item = cursor.fetchone()

    if cart_item:
            # Update quantity if the product already exists in the cart
            new_quantity = cart_item['Quantity'] + quantity
            cursor.execute(
                "UPDATE Cart SET Quantity = %s, Price = %s WHERE CustomerID = %s AND ProductID = %s",
                (new_quantity, price, customer_id, product_id)
            )
    else:
        # Insert new item into the cart
        cursor.execute(
            "INSERT INTO Cart (CustomerID, ProductID, Quantity, Price) VALUES (%s, %s, %s, %s)",
            (customer_id, product_id, quantity, price)
        )
    
    db.commit()
    flash('Product added to cart successfully!', 'success')


    return redirect(url_for('products'))

@app.route('/place-order', methods=['POST'])
def place_order():
    customer_id = session.get('customer_id')
    product_id = request.form['product_id']
    quantity = request.form['quantity']
    cursor.callproc('Place_order', [customer_id,product_id,quantity])
    flash('Order placed successfully!', 'success')
    return redirect(url_for('products'))


# @app.route('/seller-login', methods=['GET', 'POST'])
# def seller_login():
#     if request.method == 'POST':
#         # Implement seller login logic
#         pass
#     return render_template('seller_login.html')


@app.route('/view-products', methods=['GET'])
def view_products():
    # Fetch the products data or render the products page
    return redirect(url_for('products'))

@app.route('/seller-login', methods=['GET', 'POST'])
def seller_login():
    if request.method == 'POST':
        seller_id = request.form['seller_id']

        cursor.execute(
            "SELECT SellerID, CompanyName FROM Sellers WHERE SellerID = %s",
            (seller_id,)
        )
        seller = cursor.fetchone()

        if seller:
            session['seller_id'] = seller['SellerID']
            session['seller_name'] = seller['CompanyName']
            flash(f"Welcome back, {seller['CompanyName']}!", 'success')
            return redirect(url_for('seller_dashboard'))
        else:
            flash('Seller ID not found.', 'error')
    

    return render_template('seller_login.html')

@app.route('/seller_dashboard')
def seller_dashboard():
    # Ensure the seller is logged in
    if 'seller_id' not in session:
        flash('Please log in to access the dashboard.', 'error')
        return redirect(url_for('seller_login'))

    seller_id = session['seller_id']

    # Fetch seller details
    cursor.execute("SELECT * FROM Sellers WHERE SellerID = %s", (seller_id,))
    seller_details = cursor.fetchone()

    if not seller_details:
        flash('Seller not found.', 'error')
        return redirect(url_for('seller_login'))

    # Render dashboard with seller details
    return render_template('seller_dashboard.html', 
        seller_name=session.get('seller_name', 'Seller'), 
        seller_details=seller_details)


@app.route('/add-product', methods=['GET', 'POST'])
def add_product():
    # Ensure the seller is logged in
    if 'seller_id' not in session:
        flash('Please log in to add a product.', 'error')
        return redirect(url_for('seller_login'))

    if request.method == 'POST':
        # Fetch form data
        product_name = request.form['product_name']
        description = request.form['description']
        price = request.form['price']
        stock = request.form['stock']
        category_name = request.form.get('category_name', '')
        seller_id = session['seller_id']

        # Insert product into the database
        try:
            query = """
            INSERT INTO Products (SellerID, ProductName, Description, Price, Stock, CategoryName)
            VALUES (%s, %s, %s, %s, %s, %s)
            """
            cursor.execute(query, (seller_id, product_name, description, price, stock, category_name))
            db.commit()
            flash('Product added successfully!', 'success')
            # return redirect(url_for('add-product'))
        except mysql.connector.Error as err:
            flash(f"Error: {err}", 'error')
            db.rollback()

    # Render the add product form
    return render_template('add_product.html')


@app.route('/view-orders')
def view_orders():
    # Ensure the seller is logged in
    if 'seller_id' not in session:
        flash('Please log in to view your products.', 'error')
        return redirect(url_for('seller_login'))

    seller_id = session['seller_id']

    # Fetch products ordered by customers
    query = """
    SELECT 
        p.ProductName,
        o.Quantity,
        o.ShippingAddress
    FROM 
        Orders o
    JOIN 
        Products p ON o.ProductID = p.ProductID
    WHERE 
        p.SellerID = %s
    """
    cursor.execute(query, (seller_id,))
    products = cursor.fetchall()

    # Render the page
    return render_template('view_orders.html', products=products)


@app.route('/view-products-seller', methods=['GET'])
def view_products_seller():
    # Ensure the seller is logged in
    if 'seller_id' not in session:
        flash('Please log in to view your products.', 'error')
        return redirect(url_for('seller_login'))

    seller_id = session['seller_id']
    try:
        # Fetch products for the logged-in seller
        query = """
        SELECT ProductName, Description, Price, Stock, CategoryName 
        FROM Products 
        WHERE SellerID = %s
        """
        cursor.execute(query, (seller_id,))
        products = cursor.fetchall()

        return render_template('view_products_seller.html', products=products)
    except mysql.connector.Error as err:
        flash(f"Error: {err}", 'error')
        return redirect(url_for('seller_dashboard'))


@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out.', 'success')
    return redirect(url_for('seller_login'))

@app.route('/logout_cust')
def logout_cust():
    session.clear()
    flash('You have been logged out.', 'success')
    return redirect(url_for('login'))


@app.route('/checkout', methods=['POST'])
def checkout():
    # Ensure customer is logged in
    customer_id = session.get('customer_id')
    if not customer_id:
        flash("You must be logged in to checkout.", "danger")
        return redirect(url_for('login'))

    try:
        # Fetch all items in the cart for the customer
        cursor.execute("""
            SELECT ProductID, Quantity
            FROM Cart
            WHERE CustomerID = %s
        """, (customer_id,))
        cart_items = cursor.fetchall()

        if not cart_items:
            flash("Your cart is empty.", "info")
            return redirect(url_for('dashboard', customer_id=customer_id))

        # Process each cart item by calling the stored procedure
        for item in cart_items:
            product_id = item['ProductID']
            quantity = item['Quantity']

            try:
                # Call the Place_order stored procedure
                cursor.callproc('Place_order', [customer_id, product_id, quantity])
            except mysql.connector.Error as e:
                flash(f"Error placing order for product {product_id}: {str(e)}", "danger")
                return redirect(url_for('dashboard', customer_id=customer_id))

        # Clear the cart after successfully placing all orders
        cursor.execute("DELETE FROM Cart WHERE CustomerID = %s", (customer_id,))
        db.commit()

        flash("Your order has been placed successfully!", "success")
        return redirect(url_for('dashboard', customer_id=customer_id))

    except Exception as e:
        db.rollback()
        flash(f"An error occurred during checkout: {str(e)}", "danger")
        return redirect(url_for('dashboard', customer_id=customer_id))



if __name__ == "__main__":
    app.run(debug=True)