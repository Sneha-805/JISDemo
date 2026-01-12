<%-- 
    Document   : publicProsecutorDashboard
    Created on : 31 Oct 2025, 3:36:28 pm
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:choose>
            <c:when test="${sessionScope.role == 'public prosecutor'}">
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Welcome ${sessionScope.username}</h1>
    </body>
</html>
 </c:when>
 <c:when test="${sessionScope.role != 'public prosecutor'}">
     <!DOCTYPE html>
     <html>
         <body>
             <h2>You didn't belong to here !!!</h2>
         </body>
     </html>    
 </c:when>
 </c:choose>
