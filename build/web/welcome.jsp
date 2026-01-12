<%-- 
    Document   : welcome
    Created on : 31 Oct 2025, 2:31:46 pm
    Author     : Sneha
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome Page</title>

    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f2f5fa;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 450px;
            margin: 100px auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 4px 15px rgba(0,0,0,0.1);
            text-align: center;
        }

        h2 {
            color: #2b4c7e;
            margin-bottom: 10px;
        }

        p {
            font-size: 18px;
            color: #333;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 22px;
            background: #2b4c7e;
            color: white;
            text-decoration: none;
            font-size: 16px;
            border-radius: 8px;
            transition: 0.3s;
        }

        a:hover {
            background: #1e3558;
        }
    </style>

</head>

<body>

    <div class="container">
        <h2>Registration Successful!</h2>

        <p>Welcome, <strong>${sessionScope.username}</strong>!</p>

        <c:choose>
            <c:when test="${sessionScope.role == 'police'}">
                <a href="policeDashboard.jsp">Go to your Dashboard</a>
            </c:when>

            <c:when test="${sessionScope.role == 'court registrar'}">
                <a href="courtRegistrarDashboard.jsp">Go to your Dashboard</a>
            </c:when>

            <c:when test="${sessionScope.role == 'judge'}">
                <a href="judgeDashboard.jsp">Go to your Dashboard</a>
            </c:when>

            <c:when test="${sessionScope.role == 'lawyer'}">
                <a href="lawyerDashboard.jsp">Go to your Dashboard</a>
            </c:when>

            <c:when test="${sessionScope.role == 'public prosecutor'}">
                <a href="publicProsecutorDashboard.jsp">Go to your Dashboard</a>
            </c:when>

            <c:otherwise>
                <a href="userDashboard.jsp">Go to User Dashboard</a>
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>