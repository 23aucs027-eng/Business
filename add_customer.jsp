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
        String address = request.getParameter("address");
        String gst = request.getParameter("gst");

        try {
            PreparedStatement ps = conn.prepareStatement("INSERT INTO customers(name, address, gst_number) VALUES (?, ?, ?)");
            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, gst);
            int x = ps.executeUpdate();

            if (x > 0) {
                message = "Customer added successfully!";
            } else {
                message = "Error adding customer.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Customer</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #141e30, #243b55);
            font-family: 'Segoe UI', sans-serif;
            color: #fff;
        }

        .container {
            max-width: 500px;
            margin: 60px auto;
            padding: 30px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(6px);
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 255, 255, 0.15);
        }

        h2 {
            text-align: center;
            color: #00f0ff;
            margin-bottom: 30px;
        }

        input[type="text"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 18px;
            border: none;
            border-radius: 10px;
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
        }

        input[type="text"]::placeholder {
            color: #ccc;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #00f0ff;
            color: #000;
            font-size: 16px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.3s ease;
        }

        button:hover {
            background-color: #00c8cc;
        }

        .msg {
            margin-top: 20px;
            text-align: center;
            font-weight: bold;
            color: #00ff99;
        }

        .back-btn {
            display: inline-block;
            margin-bottom: 15px;
            text-decoration: none;
            color: #00f0ff;
            font-weight: bold;
        }

        .back-btn:hover {
            text-decoration: underline;
        }

        @media screen and (max-width: 600px) {
            .container {
                margin: 20px;
                padding: 20px;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <a href="dashboard.jsp" class="back-btn">Back to Dashboard</a>
        <h2>Add New Customer</h2>
        <form method="post">
            <input type="text" name="name" placeholder="Customer Name" required>
            <input type="text" name="address" placeholder="Address" required>
            <input type="text" name="gst" placeholder="GST Number" required>
            <button type="submit">Save Customer</button>
        </form>

        <div class="msg"><%= message %></div>
    </div>

</body>
</html>
