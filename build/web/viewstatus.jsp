<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Handle dismiss link for popup message clearing
    String dismiss = request.getParameter("dismiss");
    if ("true".equals(dismiss)) {
        session.removeAttribute("message");
        session.removeAttribute("cin");
        // Redirect to clean the query string
        response.sendRedirect(request.getRequestURI());
        return;
    }

    String msg = (String) session.getAttribute("message");
    String cinVal = (String) session.getAttribute("cin");
    if (msg == null) msg = "";
    if (cinVal == null) cinVal = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>View Case Status — Police Portal</title>

  <style>
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');
    :root{
      --bg:#f7f6f3;
      --card:#ffffff;
      --accent:#fbc02d;
      --accent-dark:#f57f17;
      --muted:#6b5e53;
      --radius:12px;
    }

    *{box-sizing:border-box;margin:0;padding:0;}
    body{
      font-family:"Poppins",sans-serif;
      background:linear-gradient(180deg,#fff 0%,#fbf8f3 100%);
      color:var(--muted);
      display:flex;
      justify-content:center;
      align-items:flex-start;
      min-height:100vh;
      padding:40px 20px;
    }

    .wrap{ width:100%; max-width:720px; }

    header{
      display:flex;
      align-items:center;
      justify-content:space-between;
      margin-bottom:24px;
    }
    header h1{
      color:var(--accent-dark);
      font-size:22px;
      letter-spacing:0.3px;
    }
    .who{
      font-size:14px;
      background:linear-gradient(90deg,rgba(255,245,157,0.9),rgba(255,249,196,0.9));
      padding:8px 12px;
      border-radius:999px;
      color:var(--muted);
      font-weight:600;
    }

    .card{
      background:var(--card);
      border-radius:var(--radius);
      box-shadow:0 8px 30px rgba(98,80,67,0.06);
      padding:28px;
    }

    h2{
      text-align:center;
      color:var(--accent-dark);
      text-transform:uppercase;
      font-size:15px;
      margin-bottom:18px;
    }

    form{
      margin-bottom:18px;
    }
    label{
      display:block;
      margin-bottom:8px;
      font-weight:600;
      color:#5d4037;
      font-size:14px;
    }
    input[type="text"]{
      width:100%;
      padding:10px 12px;
      border-radius:8px;
      border:1px solid #ffe082;
      background:#fffdf2;
      color:var(--muted);
      font-size:14px;
      margin-bottom:14px;
    }
    input[type="text"]:focus{
      border-color:var(--accent);
      box-shadow:0 0 0 4px rgba(251,192,45,0.08);
      outline:none;
    }
    .btn{
      background:var(--accent);
      color:white;
      padding:10px 18px;
      border:none;
      border-radius:10px;
      font-weight:700;
      cursor:pointer;
      transition:transform .15s ease, box-shadow .15s ease;
    }
    .btn:hover{
      transform:translateY(-2px);
      box-shadow:0 8px 20px rgba(251,192,45,0.18);
    }

    .result{
      margin-top:18px;
      font-size:15px;
      color:#4e342e;
    }
    .result h3{
      color:var(--accent-dark);
      margin-bottom:8px;
    }
    .result p{
      margin-bottom:4px;
    }

    footer{
      text-align:center;
      margin-top:25px;
      font-size:13px;
      color:#8d6e63;
    }

    /* Popup modal */
    .modal-overlay{
      position:fixed;
      inset:0;
      display:flex;
      align-items:center;
      justify-content:center;
      background:rgba(0,0,0,0.4);
      z-index:999;
      animation:fadeIn .2s ease;
    }
    .modal{
      background:#fffde7;
      padding:24px 30px;
      border-radius:10px;
      text-align:center;
      width:clamp(280px,70%,420px);
      box-shadow:0 10px 25px rgba(0,0,0,0.2);
    }
    .modal h3{
      color:var(--accent-dark);
      margin-bottom:10px;
    }
    .modal p{
      margin-bottom:10px;
      color:var(--muted);
    }
    .modal .cin{
      display:inline-block;
      background:linear-gradient(90deg,#fff59d,#fff8e1);
      padding:8px 12px;
      border-radius:8px;
      font-weight:700;
      color:#5d4037;
      margin-bottom:10px;
    }
    .modal a.ok{
      display:inline-block;
      background:var(--accent);
      color:#fff;
      text-decoration:none;
      padding:8px 16px;
      border-radius:8px;
      font-weight:700;
    }
    .modal a.ok:hover{
      background:#fdd835;
      color:#5d4037;
    }

    @keyframes fadeIn {
      from{opacity:0; transform:translateY(6px);}
      to{opacity:1; transform:none;}
    }
  </style>
</head>

<body>
  <div class="wrap">
    <header>
      <h1>Check Case Status</h1>
      <div class="who">Officer: ${sessionScope.username}</div>
    </header>

    <main class="card">
      <h2>Enter CIN to View Status</h2>
      <form action="statusservlet" method="post">
        <label for="cin">CIN</label>
        <input id="cin" type="text" name="cin" required>
        <button type="submit" class="btn" name="sub">Submit</button>
      </form>

      <c:if test="${not empty message}">
        <div class="result">
          <p style="color:#1e88e5;">${message}</p>
        </div>
      </c:if>

      <c:if test="${not empty cin}">
        <div class="result">
          <h3>Case Details</h3>
          <p><b>CIN:</b> ${cin}</p>
          <p><b>Status:</b> ${status}</p>
        </div>
      </c:if>
    </main>

    <footer>© 2025 Judiciary Information System | Police Portal</footer>
  </div>

  <!-- Server-driven modal popup -->
  <%
    boolean showPopup = !(msg.trim().isEmpty() && cinVal.trim().isEmpty());
    if (showPopup) {
  %>
  <div class="modal-overlay" role="dialog" aria-modal="true">
    <div class="modal">
      <h3>Status Retrieved ✅</h3>
      <p><strong><%= msg %></strong></p>
      <div class="cin">CIN: <%= cinVal %></div>
      <a class="ok" href="<%= request.getRequestURI() + "?dismiss=true" %>">OK</a>
    </div>
  </div>
  <% } %>
</body>
</html>
