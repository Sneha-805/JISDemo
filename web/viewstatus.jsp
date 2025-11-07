<%-- 
    Document   : viewstatus
    Created on : 7 Nov 2025, 2:20:59 pm
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="statusservlet" method="post">
            <p>please enter the cin of a case to view its status</p><!-- comment -->
            CIN:<input type="text" name="cin">
        </form>
    </body>
</html>
