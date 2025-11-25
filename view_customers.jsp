<%@ include file="db/DBConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Handle delete request if deleteId parameter is provided
    String deleteIdParam = request.getParameter("deleteId");
    if (deleteIdParam != null) {
        int deleteId = Integer.parseInt(deleteIdParam);

        // Delete from invoice_items → invoices → customers
        PreparedStatement ps1 = conn.prepareStatement("DELETE FROM invoice_items WHERE invoice_id IN (SELECT id FROM invoices WHERE customer_id=?)");
        ps1.setInt(1, deleteId);
        ps1.executeUpdate();

        PreparedStatement ps2 = conn.prepareStatement("DELETE FROM invoices WHERE customer_id=?");
        ps2.setInt(1, deleteId);
        ps2.executeUpdate();

        PreparedStatement ps3 = conn.prepareStatement("DELETE FROM customers WHERE id=?");
        ps3.setInt(1, deleteId);
        ps3.executeUpdate();
    }

    PreparedStatement ps = conn.prepareStatement("SELECT * FROM customers");
    ResultSet rs = ps.executeQuery();
    int sno = 1;
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Customers - Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #0f2027, #203a43, #2c5364);
            color: #fff;
        }

        h2 {
            text-align: center;
            color: #00f0ff;
            margin-top: 30px;
        }

        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(6px);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 0 15px rgba(0, 255, 255, 0.1);
        }

        th, td {
            padding: 14px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        th {
            background-color: rgba(0, 240, 255, 0.2);
            color: #00f0ff;
            font-size: 15px;
        }

        td {
            color: #eee;
            font-size: 14px;
        }

        .action-btns a {
            margin: 0 4px;
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            font-size: 13px;
        }

        .edit-link {
            background-color: #007bff;
            color: white;
        }

        .edit-link:hover {
            background-color: #0056b3;
        }

        .delete-link {
            background-color: #dc3545;
            color: white;
        }

        .delete-link:hover {
            background-color: #a71d2a;
        }

        .back-btn {
            text-align: center;
            margin: 25px 0;
        }

        .back-btn a {
            text-decoration: none;
            background: #00f0ff;
            color: #000;
            padding: 10px 18px;
            border-radius: 8px;
            margin: 0 5px;
            font-weight: bold;
        }

        .back-btn a:last-child {
            background-color: #28a745;
            color: #fff;
        }

        @media screen and (max-width: 768px) {
            table, th, td {
                font-size: 13px;
            }
            .action-btns a {
                padding: 5px 10px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>

<h2>All Customers</h2>

<table>
    <tr>
        <th>S.No</th>
        <th>Name</th>
        <th>GST No.</th>
        <th>Address</th>
        <th>Actions</th>
    </tr>
    <%
        while (rs.next()) {
    %>
    <tr>
        <td><%= sno++ %></td>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("gst_number") %></td>
        <td><%= rs.getString("address") %></td>
        <td class="action-btns">
            <a class="edit-link" href="edit_customer.jsp?id=<%= rs.getInt("id") %>">Edit</a>
            <a class="delete-link" href="view_customers.jsp?deleteId=<%= rs.getInt("id") %>" 
               onclick="return confirm('Are you sure you want to delete this customer and their invoices?');">Delete</a>
        </td>
    </tr>
    <%
        }
    %>
</table>

<div class="back-btn">
    <a href="dashboard.jsp">Back To Dashboard</a>
    <a href="add_customer.jsp">Add New Customer</a>
</div>

</body>
</html>
