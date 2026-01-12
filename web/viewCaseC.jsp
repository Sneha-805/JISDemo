<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<div style="padding:18px;">
  <div style="background:rgba(255,255,255,0.98); border-radius:10px; padding:18px;">
    <h2 style="text-align:center; color:#f57f17; text-transform:uppercase; margin-bottom:12px;">
      View Case Details
    </h2>

    <table style="width:100%; border-collapse:collapse; text-align:left;">
      <thead>
        <tr style="background:#fff59d;">
          <th style="padding:12px 15px;">CIN</th>
          <th style="padding:12px 15px;">Name of the defendant</th>
          <th style="padding:12px 15px;">Defendant address</th>
          <th style="padding:12px 15px;">Crime type</th>
          <th style="padding:12px 15px;">Date of crime</th>
          <th style="padding:12px 15px;">Place of crime</th>
          <th style="padding:12px 15px;">Name of arresting officer</th>
          <th style="padding:12px 15px;">Date of arrest</th>
          <th style="padding:12px 15px;">Posted by</th>
           <th style="padding:12px 15px;">Status</th>
        </tr>
      </thead>
      <tbody>
       <%
    Object td = request.getAttribute("tableData");
    if (td != null) {
        out.print(td.toString());   // Renders your <tr> rows correctly
    } else {
        out.print("<tr><td colspan='10' style='text-align:center;'>No cases found.</td></tr>");
    }
%>

      </tbody>
    </table>
  </div>
</div>
