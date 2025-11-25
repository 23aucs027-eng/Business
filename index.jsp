<%@ include file="db/DBConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%
    String message = "";

    if(request.getParameter("username") != null){
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        if(user.equals("admin") && pass.equals("admin123")){
            session.setAttribute("admin", "admin");
            response.sendRedirect("dashboard.jsp");
            return;
        } else {
            message = "Invalid username or password!";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title> Admin Login - Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            background: linear-gradient(135deg, #141E30, #243B55);
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
        }
        .login-box {
            width: 380px;
            margin: 120px auto;
            background: #1f1f2e;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 0 25px rgba(0, 0, 0, 0.4);
            color: white;
        }
        .login-box h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #00ffe0;
            font-weight: normal;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-top: 12px;
            border-radius: 8px;
            border: none;
            background: #2c2c3c;
            color: white;
            font-size: 15px;
            outline: none;
        }
        input::placeholder {
            color: #aaa;
        }
        button {
            width: 100%;
            margin-top: 20px;
            padding: 12px;
            background: #00c896;
            border: none;
            color: #fff;
            font-size: 16px;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s;
        }
        button:hover {
            background: #00a882;
        }
        .msg {
            text-align: center;
            margin-top: 15px;
            color: #ff4d4d;
            font-weight: bold;
        }
        .footer {
            text-align: center;
            margin-top: 25px;
            font-size: 13px;
            color: #aaa;
        }
    </style>
</head>
<body>

    <div class="login-box">
        <h2>Admin Login</h2>
        <form method="post">
            <input type="text" name="username" placeholder=" Enter Username" required>
            <input type="password" name="password" placeholder=" Enter Password" required>
            <button type="submit">Login</button>
        </form>
        <div class="msg"><%= message %></div>
    </div>

    <div class="footer">CopyRight 2025 MAG Enterprises - Management System</div>

</body>
</html>
