<%@ include file="db/DBConnection.jsp" %>
<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Sambrani System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #ffffff;
        }

        .container {
            max-width: 1200px;
            margin: auto;
            padding: 60px 30px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .topbar h1 {
            font-size: 36px;
            font-weight: 500;
            color: #00f0ff;
            text-shadow: 0 0 5px #00f0ff;
        }

        .logout {
            background: #ff4b5c;
            color: #fff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: background 0.3s;
        }

        .logout:hover {
            background: #e0384a;
        }

        .hero {
            margin: 20px 0 40px;
            text-align: center;
            color: #ccc;
            font-size: 20px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 30px;
        }

        .card {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
            padding: 30px;
            border-radius: 18px;
            box-shadow: 0 0 20px rgba(0, 255, 255, 0.1);
            text-align: center;
            transition: 0.3s ease-in-out;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 25px rgba(0, 255, 255, 0.2);
        }

        .card h3 {
            font-size: 24px;
            color: #00f0ff;
            margin-bottom: 10px;
        }

        .card a {
            color: #ffffff;
            font-weight: bold;
            text-decoration: none;
            background: #00f0ff;
            padding: 10px 20px;
            border-radius: 8px;
            display: inline-block;
            margin-top: 15px;
            transition: background 0.3s;
        }

        .card a:hover {
            background: #00c4e6;
        }

        .footer {
            margin-top: 60px;
            text-align: center;
            color: #888;
            font-size: 13px;
        }

        @media (max-width: 600px) {
            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="topbar">
        <h1>Welcome, GOPI</h1>
        <a class="logout" href="logout.jsp">Logout</a>
    </div>

    <div class="hero">
        Manage everything from one place. Quick access to your business essentials.
    </div>

    <div class="grid">
        <div class="card">
            <h3> Products</h3>
            <a href="view_products.jsp">View All</a>
        </div>
        <div class="card">
            <h3> Customers</h3>
            <a href="view_customers.jsp">Manage</a>
        </div>
        <div class="card">
            <h3> Invoices</h3>
            <a href="view_invoices.jsp">Invoices</a>
        </div>
    </div>

    <div class="footer">
        CopyRights 2025 MAG Enterprises. All rights reserved.
    </div>
</div>

</body>
</html>
