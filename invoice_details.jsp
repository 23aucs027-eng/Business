<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="db/DBConnection.jsp" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>

<%
    if(session.getAttribute("admin") == null){
        response.sendRedirect("index.jsp");
        return;
    }

    int invoiceId = Integer.parseInt(request.getParameter("id"));

    PreparedStatement ps = conn.prepareStatement(
        "SELECT i.id, i.total_amount, i.created_at, c.name, c.address, c.gst_number " +
        "FROM invoices i JOIN customers c ON i.customer_id = c.id WHERE i.id = ?"
    );
    ps.setInt(1, invoiceId);
    ResultSet rs = ps.executeQuery();

    String customerName = "", address = "", gst = "", createdAt = "";
    double total = 0;
    if(rs.next()){
        customerName = rs.getString("name");
        address = rs.getString("address");
        gst = rs.getString("gst_number");
        total = rs.getDouble("total_amount");
        createdAt = rs.getString("created_at");
    }

    PreparedStatement items = conn.prepareStatement(
        "SELECT p.name, p.hsn_code, ii.quantity, ii.price " +
        "FROM invoice_items ii JOIN products p ON ii.product_id = p.id WHERE ii.invoice_id = ?"
    );
    items.setInt(1, invoiceId);
    ResultSet itemsRs = items.executeQuery();

    double subtotal = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Invoice #<%= invoiceId %></title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f4f4;
        }
        .box {
            width: 85%;
            margin: 30px auto;
            background: #fff;
            padding: 25px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2, h3 {
            text-align: center;
        }
        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #3e8e41;
            color: white;
        }
        .back-button {
            margin: 20px;
        }
        .back-button button {
            padding: 8px 16px;
            border-radius: 5px;
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
        }
        .print-btn {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 15px;
            background-color: #ff5722;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 15px;
        }
    </style>
</head>
<body>

<div class="back-button">
    <button onclick="history.back()">← Back</button>
</div>

<div class="box">
    <h2>MAG Enterprises</h2>
    <h3>Invoice #<%= invoiceId %> | Date: <%= createdAt %></h3>

    <p>
        <strong>Customer:</strong> <%= customerName %><br>
        <strong>Address:</strong> <%= address %><br>
        <strong>GST No:</strong> <%= gst %>
    </p>

    <table>
        <tr>
            <th>Product</th>
            <th>HSN Code</th>
            <th>Qty</th>
            <th>Price/Unit (₹)</th>
            <th>Total (₹)</th>
        </tr>
        <%
            while(itemsRs.next()){
                String pname = itemsRs.getString("name");
                String hsn = itemsRs.getString("hsn_code");
                int qty = itemsRs.getInt("quantity");
                double price = itemsRs.getDouble("price");
                double lineTotal = qty * price;
                subtotal += lineTotal;
        %>
        <tr>
            <td><%= pname %></td>
            <td><%= hsn %></td>
            <td><%= qty %></td>
            <td><%= String.format("%.2f", price) %></td>
            <td><%= String.format("%.2f", lineTotal) %></td>
        </tr>
        <% } %>
        <tr>
            <td colspan="4" align="right"><strong>Subtotal:</strong></td>
            <td><strong>₹<%= String.format("%.2f", subtotal) %></strong></td>
        </tr>
        <tr>
            <td colspan="4" align="right"><strong>CGST (2.5%):</strong></td>
            <td>₹<%= String.format("%.2f", subtotal * 0.025) %></td>
        </tr>
        <tr>
            <td colspan="4" align="right"><strong>SGST (2.5%):</strong></td>
            <td>₹<%= String.format("%.2f", subtotal * 0.025) %></td>
        </tr>
        <tr>
            <td colspan="4" align="right"><strong>Grand Total:</strong></td>
            <td><strong>₹<%= String.format("%.2f", total) %></strong></td>
        </tr>
    </table>

    <a class="print-btn" href="print_invoice.jsp?id=<%= invoiceId %>" target="_blank">🖨️ Print Invoice</a>
</div>

</body>
</html>
