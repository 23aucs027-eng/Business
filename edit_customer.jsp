<%@ include file="db/DBConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String method = request.getMethod();
    String message = "";
    String name = "", gst = "", address = "";
    int id = 0;

    if (method.equals("GET")) {
        id = Integer.parseInt(request.getParameter("id"));
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM customers WHERE id=?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            gst = rs.getString("gst_number");
            address = rs.getString("address");
        }
    } else if (method.equals("POST")) {
        id = Integer.parseInt(request.getParameter("id"));
        name = request.getParameter("name");
        gst = request.getParameter("gst_number");
        address = request.getParameter("address");

        PreparedStatement ps = conn.prepareStatement(
            "UPDATE customers SET name=?, gst_number=?, address=? WHERE id=?"
        );
        ps.setString(1, name);
        ps.setString(2, gst);
        ps.setString(3, address);
        ps.setInt(4, id);
        ps.executeUpdate();

        response.sendRedirect("view_customers.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Customer</title>
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
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
            color: #ccc;
        }

        input, textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 16px;
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
            border: none;
            border-radius: 10px;
        }

        textarea {
            resize: vertical;
        }

        input::placeholder, textarea::placeholder {
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
            background-color: #00d0e0;
        }

        .back-link {
            text-align: center;
            margin-top: 15px;
        }

        .back-link a {
            text-decoration: none;
            color: #00f0ff;
            font-weight: bold;
        }

        .back-link a:hover {
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
        <h2>Edit Customer</h2>
        <form method="post" action="edit_customer.jsp">
            <input type="hidden" name="id" value="<%= id %>">

            <label>Name</label>
            <input type="text" name="name" value="<%= name %>" required>

            <label>GST Number</label>
            <input type="text" name="gst_number" value="<%= gst %>" required>

            <label>Address</label>
            <textarea name="address" rows="3" required><%= address %></textarea>

            <button type="submit">Update Customer</button>
        </form>

        <div class="back-link">
            <a href="view_customers.jsp">Back to Customer List</a>
        </div>
    </div>

</body>
</html>
