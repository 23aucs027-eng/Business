<%@ include file="db/DBConnection.jsp" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    if (conn == null) {
        out.println(" Database connection is not available.");
        return;
    }

    String query = "SELECT i.id, i.total_amount, i.created_at, c.name AS customer_name " +
                   "FROM invoices i INNER JOIN customers c ON i.customer_id = c.id " +
                   "ORDER BY i.id DESC";

    PreparedStatement ps = conn.prepareStatement(query);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Invoices - Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #fff;
        }

        .header, .btn-back {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h2 {
            font-size: 28px;
            color: #00f0ff;
            text-shadow: 0 0 5px #00f0ff;
        }

        .add-btn {
            background-color: #00f0ff;
            color: #000;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            transition: background 0.3s;
        }

        .add-btn:hover {
            background-color: #00c4e6;
        }

        .btn-back button {
            padding: 8px 18px;
            background-color: #00f0ff;
            color: black;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-back button:hover {
            background-color: #00c4e6;
        }

        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 0 15px rgba(0,255,255,0.1);
        }

        th, td {
            padding: 14px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            text-align: center;
        }

        th {
            background-color: rgba(0,255,255,0.1);
            color: #00f0ff;
            font-weight: bold;
        }

        td {
            color: #f1f1f1;
        }

        .view {
            background-color: #28a745;
            color: #fff;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            transition: background 0.3s;
        }

        .view:hover {
            background-color: #218838;
        }

        @media (max-width: 768px) {
            .header, .btn-back {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            table {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

<div class="btn-back">
    <button onclick="history.back()">Back</button>
</div>

<div class="header">
    <h2>Invoice List</h2>
    <a href="new_invoice.jsp" class="add-btn">Create New Invoice</a>
</div>

<table>
    <tr>
        <th>Invoice ID</th>
        <th>Customer</th>
        <th>Date</th>
        <th>Total Amount</th>
        <th>Action</th>
    </tr>
    <%
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy hh:mm a");
        while(rs.next()){
    %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("customer_name") %></td>
        <td><%= sdf.format(rs.getTimestamp("created_at")) %></td>
        <td><%= String.format("%.2f", rs.getDouble("total_amount")) %></td>
        <td><a class="view" href="invoice_details.jsp?id=<%= rs.getInt("id") %>">View</a></td>
    </tr>
    <% } %>
</table>

</body>
</html>
