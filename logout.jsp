<%@ page language="java" %>
<%
    session.invalidate();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Logging Out...</title>
    <meta http-equiv="refresh" content="3;url=index.jsp" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }
        .message-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0,0,0,0.2);
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="message-box">
        <h2> You have been logged out.</h2>
        <p>Redirecting to login page...</p>
    </div>
</body>
</html>
