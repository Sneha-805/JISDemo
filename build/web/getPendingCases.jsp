<%-- 
    Document   : uploadDates
    Created on : 11 Nov 2025, 10:41:40 am
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
        
        <div style="padding:18px;">
  <div style="background:rgba(255,255,255,0.98); border-radius:10px; padding:18px;">
    <h2 style="text-align:center; color:#f57f17; text-transform:uppercase; margin-bottom:12px;">
       Upload hearing dates
    </h2>

    <table style="width:100%; border-collapse:collapse; text-align:left;">
      <thead>
        <tr style="background:#fff59d;">
          <th style="padding:12px 15px;">CIN</th>
          <th style="padding:12px 15px;">Status</th>
          <th style="padding:12px 15px;">Hearing Date</th>
          <th style="padding:12px 15px;">Upload</th>
        </tr>
      </thead>
      <tbody>
        <%= request.getAttribute("tableData") != null ? request.getAttribute("tableData") : "<tr><td colspan='4'>No data</td></tr>" %>
      </tbody>

    </table>
  </div>
</div>

    </body>
</html>
