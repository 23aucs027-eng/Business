<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="db/DBConnection.jsp" %>
<%@ page import="java.sql.*, java.text.*, java.util.*" %>
<%! 
    String convertToWords(int n) {
        String[] units = { "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
                           "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
                           "Eighteen", "Nineteen" };
        String[] tens = { "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };

        if (n < 20) return units[n];
        if (n < 100) return tens[n / 10] + ((n % 10 != 0) ? " " + units[n % 10] : "");
        if (n < 1000) return units[n / 100] + " Hundred" + ((n % 100 != 0) ? " and " + convertToWords(n % 100) : "");
        if (n < 100000) return convertToWords(n / 1000) + " Thousand" + ((n % 1000 != 0) ? " " + convertToWords(n % 1000) : "");
        return "";
    }
%>

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

        Timestamp ts = rs.getTimestamp("created_at");
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        createdAt = sdf.format(ts);
    }

    PreparedStatement items = conn.prepareStatement(
        "SELECT p.name, p.hsn_code, ii.quantity, ii.price FROM invoice_items ii " +
        "JOIN products p ON ii.product_id = p.id WHERE ii.invoice_id = ?"
    );
    items.setInt(1, invoiceId);
    ResultSet itemsRs = items.executeQuery();

    int sn = 1;
    double cgst = total * 0.025;
    double sgst = total * 0.025;
    double grandTotal = total + cgst + sgst;

    String amountInWords = convertToWords((int) grandTotal) + " Rupees Only";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Print Invoice - #<%= invoiceId %></title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            padding: 30px;
            font-size: 14px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 8px;
            border: 1px solid #000;
        }
        .no-border {
            border: none;
        }
        .header, .footer {
            text-align: center;
        }
        .bold {
            font-weight: bold;
        }
        @media print {
            .print-btn, .back-btn {
                display: none;
            }
        }
    </style>
</head>
<body>

<div class="back-btn" style="margin-bottom: 20px;">
    <button onclick="history.back()" style="padding: 8px 16px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;">
        ← Back
    </button>
</div>

<div class="print-btn" style="text-align: center; margin-bottom: 20px;">
    <button onclick="window.print()" style="padding: 8px 16px;">Print</button>
</div>

<div class="header">
    <h2>MAG ENTERPRISES</h2>
    <p>34, P.P. Vaiyapuri Street, Virudhunagar - 626001, Tamilnadu</p>
    <p><strong>GSTIN:</strong> 33GCOPM6298E1Z2 | <strong>State Code:</strong> 33 | Phone: 93602 02537</p>
</div>

<hr>

<table>
    <tr>
        <td colspan="4"><strong>Customer Name:</strong> <%= customerName %><br><strong>Address:</strong> <%= address %></td>
        <td><strong>Invoice No.:</strong> <%= invoiceId %><br><strong>Date:</strong> <%= createdAt %></td>
    </tr>
    <tr>
        <td colspan="4"><strong>Customer GSTIN:</strong> <%= gst %></td>
        <td><strong>L.R. No:</strong> __________<br><strong>Carrier:</strong> __________</td>
    </tr>
    <tr>
        <td colspan="5"><strong>Document Through:</strong> _______________________________________</td>
    </tr>
</table>

<br>

<table>
    <tr>
        <th>S.No</th>
        <th>Particulars</th>
        <th>HSN Code</th>
        <th>Rate (₹)</th>
        <th>Qty</th>
        <th>Amount (₹)</th>
    </tr>
    <%
        while(itemsRs.next()){
            String pname = itemsRs.getString("name");
            String hsn = itemsRs.getString("hsn_code");
            int qty = itemsRs.getInt("quantity");
            double price = itemsRs.getDouble("price");
            double amount = qty * price;
    %>
    <tr>
        <td><%= sn++ %></td>
        <td><%= pname %></td>
        <td><%= hsn %></td>
        <td><%= String.format("%.2f", price) %></td>
        <td><%= qty %></td>
        <td><%= String.format("%.2f", amount) %></td>
    </tr>
    <% } %>
    <tr>
        <td colspan="5" align="right" class="bold">Add: CGST (2.5%)</td>
        <td><%= String.format("%.2f", cgst) %></td>
    </tr>
    <tr>
        <td colspan="5" align="right" class="bold">Add: SGST (2.5%)</td>
        <td><%= String.format("%.2f", sgst) %></td>
    </tr>
    <tr>
        <td colspan="5" align="right" class="bold">Total</td>
        <td><%= String.format("%.2f", grandTotal) %></td>
    </tr>
</table>

<p><strong>Amount in Words:</strong> <%= amountInWords %></p>

<br>

<table>
    <tr>
        <td class="no-border" colspan="3">
            <strong>Bank Details</strong><br>
            Bank: KARUR VYSYA BANK<br>
            A/C No: 1237115000011037<br>
            IFSC: KVBL0001237
        </td>
        <td class="no-border" align="right">
            <br><br><br>
            For <strong>MAG ENTERPRISES</strong><br><br><br>
            Authorized Signature
        </td>
    </tr>
</table>

</body>
</html>
