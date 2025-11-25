<%@ include file="db/DBConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // --- Delete logic if delete ID is passed ---
    String deleteId = request.getParameter("delete");
    if (deleteId != null) {
        try {
            int idToDelete = Integer.parseInt(deleteId);
            PreparedStatement del = conn.prepareStatement("DELETE FROM products WHERE id = ?");
            del.setInt(1, idToDelete);
            del.executeUpdate();
        } catch (Exception e) {
            out.println("<p style='color:red;text-align:center;'>Error deleting product: " + e.getMessage() + "</p>");
        }
        // Refresh to clear delete param from URL
        response.sendRedirect("view_products.jsp");
        return;
    }

    PreparedStatement ps = conn.prepareStatement("SELECT * FROM products");
    ResultSet rs = ps.executeQuery();
    int sno = 1;
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Products - Sambrani System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #0f2027, #203a43, #2c5364);
            color: #fff;
        }

        table {
            width: 90%;
            margin: 50px auto;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 0 15px rgba(0, 255, 255, 0.08);
        }

        th, td {
            padding: 14px 10px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
            color: #f1f1f1;
        }

        th {
            background-color: rgba(0, 255, 255, 0.1);
            color: #00f0ff;
            font-size: 15px;
        }

        .btn {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
            margin: 2px;
            transition: background 0.3s;
        }

        .edit-btn {
            background-color: #007bff;
            color: white;
        }

        .edit-btn:hover {
            background-color: #0056b3;
        }

        .delete-btn {
            background-color: #dc3545;
            color: white;
        }

        .delete-btn:hover {
            background-color: #a71d2a;
        }

        .back-btn {
            text-align: center;
            margin: 40px 0;
        }

        .back-btn a {
            text-decoration: none;
            background: #00f0ff;
            color: #000;
            padding: 10px 18px;
            border-radius: 6px;
            font-weight: bold;
            margin: 0 10px;
            display: inline-block;
            transition: background 0.3s;
        }

        .back-btn a:hover {
            background: #00c4e6;
        }

        @media (max-width: 768px) {
            table {
                font-size: 14px;
            }

            .btn {
                font-size: 12px;
                padding: 5px 10px;
            }
        }
    </style>
</head>
<body>

    <table>
        <tr>
            <th>S.No</th>
            <th>Product Name</th>
            <th>HSN Code</th>
            <th>Price</th>
            <th>Stock</th>
            <th>Actions</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= sno++ %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("hsn_code") %></td>
            <td><%= rs.getDouble("price") %></td>
            <td><%= rs.getInt("stock") %></td>
            <td>
                <a class="btn edit-btn" href="edit_product.jsp?id=<%= rs.getInt("id") %>">Edit</a>
                <a class="btn delete-btn" href="view_products.jsp?delete=<%= rs.getInt("id") %>" onclick="return confirm('Are you sure you want to delete this product?');">Delete</a>
            </td>
        </tr>
        <%
            }
        %>
    </table>

    <div class="back-btn">
        <a href="dashboard.jsp">Back to Dashboard</a>
        <a href="add_product.jsp">Add New Product</a>
    </div>

</body>
</html>
