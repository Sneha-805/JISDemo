<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String cin = request.getParameter("cin");
    if (cin == null) cin = (String) request.getAttribute("cin");
    if (cin == null) cin = "";
%>
<!doctype html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Payment Required</title>
    <style>
        body { font-family: Poppins, Arial, sans-serif; padding:24px; background:#fffbea; color:#5d4037; }
        .card { max-width:640px; margin:20px auto; padding:20px; border-radius:8px; background:#fff; box-shadow:0 6px 18px rgba(0,0,0,0.06); }
        .btn { background:#fbc02d; border:none; padding:10px 14px; border-radius:6px; font-weight:600; cursor:pointer; }
        .btn:hover { background:#fdd835; }
        label { display:block; margin-bottom:6px; font-weight:600; }
        input[type="number"], input[type="text"] { width:100%; padding:8px; border-radius:6px; border:1px solid #ddd; margin-bottom:12px; }
        .meta { font-size:13px; color:#6b4b3b; margin-bottom:10px; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Payment required to view case</h2>

        <p class="meta">
            Logged in as: <strong>${sessionScope.username}</strong>
            &nbsp;|&nbsp;
            Role: <strong>${sessionScope.role}</strong>
        </p>

        <p>Case CIN: <strong>${fn:escapeXml(param.cin != null ? param.cin : '')}</strong></p>

        <p>This case does not belong to you. To view the case details, please pay the access fee below.</p>

       <form id="payForm" action="${pageContext.request.contextPath}/paymentServlet" method="post" target="_self">

            <input type="hidden" name="cin" value="${fn:escapeXml(param.cin)}" />
            <label for="amount">Amount (INR)</label>
            <input type="number" id="amount" name="amount" value="50.00" step="0.01" min="0.01" required />

            <button type="button" class="btn" onclick="showQR()">Pay and View</button>

                <div id="qrBox" style="display:none; margin-top:20px; text-align:center;">
                    <h3>Scan to Pay</h3>
                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=DummyPayment" alt="qr" width="200" height="200" />

                    <br><br>
                    <button class="btn" onclick="document.getElementById('payForm').submit();">I Have Paid — Continue</button>
                </div>

                <script>
                function showQR() {
                    document.getElementById('qrBox').style.display = 'block';
                }
                </script>

        </form>

        <hr/>
        <p><a href="${pageContext.request.contextPath}/caseAccessFilter" target="contentFrame">Back to pending cases</a></p>
    </div>
</body>
</html>
