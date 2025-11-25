<%@ include file="db/DBConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String message = "";

    if (request.getParameter("name") != null) {
        String name = request.getParameter("name");
        String hsn = request.getParameter("hsn");

        try {
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));

            if (conn != null) {
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO products(name, hsn_code, price, stock) VALUES (?, ?, ?, ?)"
                );
                ps.setString(1, name);
                ps.setString(2, hsn);
                ps.setDouble(3, price);
                ps.setInt(4, stock);
                int x = ps.executeUpdate();

                if (x > 0) {
                    message = "Product added successfully!";
                } else {
                    message = "Error adding product.";
                }
            } else {
                message = "Database connection not available.";
            }
        } catch (Exception e) {
            message = "Invalid input: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Product - Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #f0f0f0;
        }

        .form-box {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            padding: 30px 40px;
            border-radius: 20px;
            box-shadow: 0 0 20px rgba(0,255,255,0.1);
            width: 420px;
        }

        .form-box h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #00ffff;
        }

        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            background: rgba(255,255,255,0.1);
            border: 1px solid #00ffff;
            border-radius: 10px;
            color: #fff;
            font-size: 15px;
        }

        button {
            width: 100%;
            padding: 12px;
            margin-top: 15px;
            background: #00ffff;
            color: #000;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s;
        }

        button:hover {
            background: #0ff;
        }

        .msg {
            margin-top: 15px;
            text-align: center;
            color: #00ff99;
            font-weight: bold;
        }

        .back-btn {
            text-align: center;
            margin-top: 20px;
        }

        .back-btn a {
            text-decoration: none;
            padding: 10px 20px;
            background: #333;
            color: #fff;
            border-radius: 8px;
            transition: 0.3s;
        }

        .back-btn a:hover {
            background: #00ffff;
            color: #000;
        }
    </style>
</head>
<body>

<div class="form-box">
    <h2>Add New Product</h2>
    <form method="post">
        <input type="text" name="name" placeholder="Product Name" required>
        <input type="text" name="hsn" placeholder="HSN Code" required>
        <input type="number" step="0.01" name="price" placeholder="Price" required>
        <input type="number" name="stock" placeholder="Stock Quantity" required>
        <button type="submit">Add Product</button>
    </form>

    <div class="msg"><%= message %></div>

    <div class="back-btn">
        <a href="dashboard.jsp">Back to Dashboard</a>
    </div>
</div>

</body>
</html>
