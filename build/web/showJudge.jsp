<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Assign Judge</title>
</head>
<body>
<div style="padding:18px;">
  <div style="background:rgba(255,255,255,0.98); border-radius:10px; padding:18px;">
    <h2 style="text-align:center; color:#f57f17; text-transform:uppercase; margin-bottom:12px;">
      Assign Judge to Case
    </h2>

    <%
      String cin = (String) request.getAttribute("cin");
      if (cin == null) cin = "";
    %>

    <form action="assignCaseServlet" method="post"> 
      <!-- show the CIN visibly -->
      <div style="margin-bottom:12px;">
        <label><strong>Selected CIN:</strong></label>
        <input type="text" name="displayCin" value="${fn:escapeXml(cin)}" readonly
           style="width:100%; padding:8px; font-size:14px;"/>
    <input type="hidden" name="cin" value="${fn:escapeXml(cin)}"/>
      </div>

      <div style="margin-bottom:12px;">
        <label><strong>Select Judge:</strong></label>
        <select name="judgeName" style="width:100%; padding:10px; font-size:16px;" required>
          <option value="">-- Select judge --</option>
          <%
             Object opts = request.getAttribute("optionData");
             if (opts != null) {
                 out.print(opts.toString());  // options already escaped in servlet
             } else {
                 out.print("<option value=''>No judges found</option>");
             }
          %>
        </select>
      </div>
         <div style="margin-bottom:12px;">
        <label><strong>Select Lawyer:</strong></label>
        <select name="lawyerName" style="width:100%; padding:10px; font-size:16px;" required>
          <option value="">-- Select lawyer --</option>
          <%
             Object opts1 = request.getAttribute("optionData1");
             if (opts1 != null) {
                 out.print(opts1.toString());  // options already escaped in servlet
             } else {
                 out.print("<option value=''>No lawyers found</option>");
             }
          %>
        </select>
      </div>

      <button type="submit" style="padding:8px 16px;">Assign</button>
    </form>
  </div>
</div>
</body>
</html>
