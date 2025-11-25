<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="db/DBConnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    PreparedStatement ps = conn.prepareStatement("SELECT * FROM customers");
    ResultSet customers = ps.executeQuery();

    PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM products");
    ResultSet products = ps2.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>New Invoice - Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #0f2027, #203a43, #2c5364);
            margin: 0;
            color: #fff;
        }

        .container {
            width: 90%;
            margin: 30px auto;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 0 15px rgba(0, 255, 255, 0.1);
        }

        h2 {
            text-align: center;
            color: #00f0ff;
            margin-bottom: 25px;
        }

        label {
            font-weight: bold;
            display: block;
            margin: 12px 0 6px;
            color: #eee;
        }

        select, input[type="number"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: none;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.08);
            color: #fff;
            backdrop-filter: blur(6px);
        }

        select option {
            color: #000;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            background: rgba(255, 255, 255, 0.03);
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        th {
            color: #00f0ff;
            font-size: 15px;
        }

        button {
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s ease;
        }

        .add-btn {
            background-color: #007bff;
            color: white;
            margin-top: 20px;
        }

        .add-btn:hover {
            background-color: #0056b3;
        }

        .remove-btn {
            background-color: #dc3545;
            color: white;
        }

        .remove-btn:hover {
            background-color: #a71d2a;
        }

        button[type="submit"] {
            background-color: #28a745;
            color: white;
            width: 100%;
            margin-top: 30px;
        }

        .back-btn {
            text-align: center;
            margin-bottom: 20px;
        }

        .back-btn a {
            text-decoration: none;
            background-color: #00f0ff;
            color: #000;
            padding: 10px 18px;
            border-radius: 6px;
            font-weight: bold;
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 20px;
            }

            th, td {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="back-btn">
        <a href="dashboard.jsp">Back to Dashboard</a>
    </div>

    <h2>Create New Invoice</h2>

    <form method="post" action="save_invoice.jsp">
        <label>Select Customer:</label>
        <select name="customer_id" required>
            <option value="">-- Select Customer --</option>
            <% while (customers.next()) { %>
                <option value="<%= customers.getInt("id") %>">
                    <%= customers.getString("name") %> - <%= customers.getString("gst_number") %>
                </option>
            <% } %>
        </select>

        <table id="productTable">
            <thead>
            <tr>
                <th>Product</th>
                <th>Qty</th>
                <th>Price</th>
                <th>Remove</th>
            </tr>
            </thead>
            <tbody id="productRows"></tbody>
        </table>

        <!-- Product Row Template -->
        <template id="productRowTemplate">
            <tr>
                <td>
                    <select name="product_id[]" onchange="updatePrice(this)" required>
                        <option value="">-- Select Product --</option>
                        <%
                            PreparedStatement ps3 = conn.prepareStatement("SELECT * FROM products");
                            ResultSet pList = ps3.executeQuery();
                            while (pList.next()) {
                        %>
                        <option value="<%= pList.getInt("id") %>" data-price="<%= pList.getDouble("price") %>">
                            <%= pList.getString("name") %> - ₹<%= pList.getDouble("price") %>
                        </option>
                        <% } %>
                        <%
                            pList.close();
                            ps3.close();
                        %>
                    </select>
                </td>
                <td><input type="number" name="quantity[]" min="1" required></td>
                <td><input type="number" name="price[]" step="0.01" readonly required></td>
                <td><button type="button" class="remove-btn" onclick="removeRow(this)">Delete</button></td>
            </tr>
        </template>

        <button type="button" class="add-btn" onclick="addRow()">Add Product</button>
        <button type="submit">Save Invoice</button>
    </form>
</div>

<script>
    function addRow() {
        const template = document.getElementById("productRowTemplate");
        const clone = template.content.cloneNode(true);
        document.getElementById("productRows").appendChild(clone);
    }

    function removeRow(btn) {
        const row = btn.closest("tr");
        const tbody = document.getElementById("productRows");
        if (tbody.children.length > 1) row.remove();
    }

    function updatePrice(select) {
        const selected = select.options[select.selectedIndex];
        const price = selected.getAttribute("data-price") || 0;
        const row = select.closest("tr");
        row.querySelector('input[name="price[]"]').value = price;
    }

    window.onload = addRow;
</script>
</body>
</html>
