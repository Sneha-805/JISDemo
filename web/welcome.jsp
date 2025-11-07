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
