<%@ include file="db/DBConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String message = "";
    String method = request.getMethod();

    if ("POST".equalsIgnoreCase(method)) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String hsn = request.getParameter("hsn");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));

            PreparedStatement ps = conn.prepareStatement(
                "UPDATE products SET name=?, hsn_code=?, price=?, stock=? WHERE id=?"
            );
            ps.setString(1, name);
            ps.setString(2, hsn);
            ps.setDouble(3, price);
            ps.setInt(4, stock);
            ps.setInt(5, id);
            int result = ps.executeUpdate();

            if (result > 0) {
                message = "Product updated successfully.";
            } else {
                message = "Failed to update product.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }

    int id = Integer.parseInt(request.getParameter("id"));
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE id=?");
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();
    rs.next();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Product</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #0f2027, #203a43, #2c5364);
            color: #fff;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 500px;
            margin: 60px auto;
            padding: 30px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(8px);
            border-radius: 15px;
            box-shadow: 0 0 25px rgba(0, 255, 255, 0.15);
        }

        h2 {
            text-align: center;
            color: #00f0ff;
            margin-bottom: 25px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-top: 12px;
            color: #ccc;
        }

        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 12px;
            margin-top: 6px;
            margin-bottom: 16px;
            background: rgba(255,255,255,0.1);
            border: none;
            border-radius: 10px;
            color: #fff;
        }

        input::placeholder {
            color: #ccc;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #00f0ff;
            color: #000;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 10px;
            cursor: pointer;
        }

        button:hover {
            background-color: #00c8d8;
        }

        .back-btn {
            text-align: center;
            margin-bottom: 20px;
        }

        .back-btn a {
            text-decoration: none;
            color: #00f0ff;
            background: rgba(255, 255, 255, 0.1);
            padding: 10px 20px;
            border-radius: 8px;
            display: inline-block;
        }

        .back-btn a:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .msg {
            text-align: center;
            margin-bottom: 20px;
            color: #ffdf00;
            font-weight: bold;
        }

        @media (max-width: 600px) {
            .container {
                margin: 20px;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="back-btn">
            <a href="view_products.jsp">Back to Products</a>
        </div>

        <h2>Edit Product</h2>

        <% if (!message.isEmpty()) { %>
            <div class="msg"><%= message %></div>
        <% } %>

        <form method="post" action="edit_product.jsp?id=<%= id %>">
            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">

            <label>Product Name:</label>
            <input type="text" name="name" value="<%= rs.getString("name") %>" required>

            <label>HSN Code:</label>
            <input type="text" name="hsn" value="<%= rs.getString("hsn_code") %>" required>

            <label>Price:</label>
            <input type="number" name="price" step="0.01" value="<%= rs.getDouble("price") %>" required>

            <label>Stock Quantity:</label>
            <input type="number" name="stock" min="0" value="<%= rs.getInt("stock") %>" required>

            <button type="submit">Update Product</button>
        </form>
    </div>
</body>
</html>
