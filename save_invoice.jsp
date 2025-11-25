<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="db/DBConnection.jsp" %>
<%@ page import="java.sql.*, java.util.*" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int customerId = Integer.parseInt(request.getParameter("customer_id"));
    String[] productIds = request.getParameterValues("product_id[]");
    String[] quantities = request.getParameterValues("quantity[]");
    String[] prices = request.getParameterValues("price[]");

    if (productIds == null || quantities == null || prices == null || productIds.length == 0) {
        out.println("<h3>Error: No product data received.</h3>");
        return;
    }

    boolean stockIssue = false;
    String stockMessage = "";

    for (int i = 0; i < productIds.length; i++) {
        int pid = Integer.parseInt(productIds[i]);
        int qty = Integer.parseInt(quantities[i]);

        PreparedStatement stockCheck = conn.prepareStatement("SELECT stock, name FROM products WHERE id=?");
        stockCheck.setInt(1, pid);
        ResultSet stockRs = stockCheck.executeQuery();
        if (stockRs.next()) {
            int stock = stockRs.getInt("stock");
            String productName = stockRs.getString("name");
            if (qty > stock) {
                stockIssue = true;
                stockMessage += "Not enough stock for product: <strong>" + productName + "</strong> (Available: " + stock + ", Requested: " + qty + ")<br>";
            }
        }
        stockRs.close();
        stockCheck.close();
    }

    if (stockIssue) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Insufficient Stock</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { font-family: Arial; padding: 40px; background: #fff3f3; color: #a00; }
        .box {
            max-width: 600px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border: 2px solid #f44336;
            border-radius: 12px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }
        .box h2 {
            color: #d8000c;
        }
        .back-btn {
            margin-top: 20px;
            display: inline-block;
            background: #444;
            color: white;
            padding: 10px 18px;
            text-decoration: none;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="box">
        <h2>Invoice Not Created</h2>
        <p><%= stockMessage %></p>
        <a class="back-btn" href="new_invoice.jsp">Back to Invoice Form</a>
    </div>
</body>
</html>
<%
        return;
    }

    // --- Create Invoice ---
    double total = 0.0;
    for (int i = 0; i < productIds.length; i++) {
        int qty = Integer.parseInt(quantities[i]);
        double price = Double.parseDouble(prices[i]);
        total += qty * price;
    }

    PreparedStatement ps = conn.prepareStatement("INSERT INTO invoices (customer_id, total_amount, created_at) VALUES (?, ?, NOW())", Statement.RETURN_GENERATED_KEYS);
    ps.setInt(1, customerId);
    ps.setDouble(2, total);
    ps.executeUpdate();

    ResultSet rs = ps.getGeneratedKeys();
    rs.next();
    int invoiceId = rs.getInt(1);
    rs.close();
    ps.close();

    // --- Insert Items & Update Stock ---
    for (int i = 0; i < productIds.length; i++) {
        int pid = Integer.parseInt(productIds[i]);
        int qty = Integer.parseInt(quantities[i]);
        double price = Double.parseDouble(prices[i]);

        // Insert invoice item
        ps = conn.prepareStatement("INSERT INTO invoice_items (invoice_id, product_id, quantity, price) VALUES (?, ?, ?, ?)");
        ps.setInt(1, invoiceId);
        ps.setInt(2, pid);
        ps.setInt(3, qty);
        ps.setDouble(4, price);
        ps.executeUpdate();
        ps.close();

        // Reduce stock
        ps = conn.prepareStatement("UPDATE products SET stock = stock - ? WHERE id = ?");
        ps.setInt(1, qty);
        ps.setInt(2, pid);
        ps.executeUpdate();
        ps.close();
    }

    response.sendRedirect("print_invoice.jsp?id=" + invoiceId);
%>
