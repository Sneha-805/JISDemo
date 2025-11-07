<%-- 
    Document   : policeDashboard
    Created on : 31 Oct 2025, 3:34:48 pm
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
         <h1>Welcome ${sessionScope.username}</h1>
         <form action="PoliceReportServlet" method="post">
             Name of the defendant<input type="text" name="name_def"><br><br>
             Defendant address<input name="addr"><br><br>
             Crime type<select name="crime_typ">
                 <option value="theft">Theft</option>
                 <option value="arson">Arson</option>
                 <option value="kidnap">Kidnap</option>
                 <option value="murder">Murder</option>
             </select><br><br>
             Date when crime is committed<input type="date" name="date_comt"><br><br>
             Where does the crime is committed<input name="where"><br><br>
             Name of arresting officer<input type="text" name="arrst_off"><br><br>
             Date of the arrest<input type="date" name="date_arrst"><br><br>
              <button type="submit" name="smt">submit</button>
         </form>
    </body>
</html>
