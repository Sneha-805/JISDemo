<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  String cin = (String) session.getAttribute("cin");
  String postMessage = (String) session.getAttribute("postMessage");

  String dismiss = request.getParameter("dismiss");
  if ("true".equals(dismiss)) {
      session.removeAttribute("cin");
      session.removeAttribute("postMessage");
      cin = "";
      postMessage = "";
  }
  if (cin == null) cin = "";
  if (postMessage == null) postMessage = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Registrar Dashboard | Judiciary Information System</title>

  <style>
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');
    *{box-sizing:border-box;margin:0;padding:0;font-family:"Poppins",sans-serif;}
    body{min-height:100vh;color:#4e342e;position:relative;overflow:hidden;}

    /* ===== Background Carousel (pure CSS) ===== */
    .bg-carousel {
      position:fixed; inset:0; z-index:0; overflow:hidden;
    }
    .bg-carousel .slide {
      position:absolute; inset:0; background-size:cover; background-position:center;
      opacity:0; animation:fade 18s infinite;
      filter: brightness(70%) blur(1px);
    }
    .bg-carousel .slide:nth-child(1){ background-image:url('https://media.istockphoto.com/id/487787078/photo/close-up-of-a-statue-of-goddess-of-justice.jpg?s=612x612'); animation-delay:0s; }
    .bg-carousel .slide:nth-child(2){ background-image:url('https://www.shutterstock.com/image-photo/indian-law-concept-showing-wooden-260nw-710676328.jpg'); animation-delay:6s; }
    .bg-carousel .slide:nth-child(3){ background-image:url('https://thumbs.dreamstime.com/b/indian-judge-seated-courtroom-national-emblem-background-india-flag-sides-judiciary-upholding-law-order-jurisdiction-385716495.jpg'); animation-delay:12s; }

    @keyframes fade {
      0%   { opacity:0; transform:scale(1.02); }
      5%   { opacity:1; transform:scale(1); }
      30%  { opacity:1; transform:scale(1); }
      35%  { opacity:0; transform:scale(0.98); }
      100% { opacity:0; transform:scale(0.98); }
    }

    /* ===== Layout ===== */
    .container {
      display:flex;
      min-height:100vh;
      position:relative;
      z-index:1;
    }

    /* ===== Sidebar ===== */
    .sidebar {
      width:250px;
      background: rgba(255, 249, 196, 0.95);
      backdrop-filter: blur(10px);
      border-right: 1px solid #fbc02d;
      padding:25px 20px;
      display:flex;
      flex-direction:column;
      justify-content:space-between;
      min-height:100vh;
    }

    .sidebar h2 {
      text-align:center;
      color:#f57f17;
      font-size:22px;
      margin-bottom:20px;
      font-weight:600;
    }

    /* Unified button styling */
    .nav-btn, .nav-links a {
      background:#ffeb99;
      border:none;
      width:100%;
      padding:12px;
      margin:5px 0;
      border-radius:10px;
      font-size:15px;
      font-weight:600;
      text-align:left;
      color:#4e342e;
      cursor:pointer;
      transition:0.3s;
      display:block;
      text-decoration:none;
      box-shadow:0 2px 6px rgba(0,0,0,0.1);
    }

    .nav-btn:hover, .nav-links a:hover {
      background:#ffe082;
      transform:translateX(4px);
      box-shadow:0 4px 10px rgba(0,0,0,0.15);
    }

    .logout-btn{
    width:100%;
    background:#ef5350;
    color:white;
    padding:10px 15px;
    border-radius:8px;
    font-size:15px;
    cursor:pointer;
    font-weight:600;
    transition:0.3s;
    border:none;
}

.logout-btn:hover{
    background:#e53935;
}

    /* Main content area */
    .main {
      flex:1;
      padding:30px;
      overflow:auto;
    }

    .header { 
      display:flex; 
      justify-content:space-between; 
      align-items:center; 
      margin-bottom:25px;
    }

    .header h1 { color:#4e342e; font-size:26px; }

    .user-info {
      background:#fff59d;
      padding:8px 15px;
      border-radius:8px;
      font-size:14px;
      color:#4e342e;
      font-weight:500;
      box-shadow:0 0 10px rgba(0,0,0,0.1);
    }

    iframe.content-frame {
      width:100%;
      height:calc(100vh - 150px);
      border:none;
      background:rgba(255,255,255,0.4);
      border-radius:14px;
      box-shadow:0 0 20px rgba(255,235,59,0.25);
      backdrop-filter:blur(3px);
    }

    footer {
      text-align:center;
      font-size:13px;
      color:#4e342e;
      margin-top:18px;
      text-shadow:0 1px 1px white;
    }

    /* Modal */
    .modal-overlay {
      position:fixed; inset:0;
      display:flex; align-items:center; justify-content:center;
      background:rgba(0,0,0,0.5);
      z-index:200;
    }

    .modal {
      background:#fffde7;
      padding:22px 28px;
      border-radius:10px;
      text-align:center;
      color:#4e342e;
      box-shadow:0 10px 25px rgba(0,0,0,0.2);
      max-width:420px;
      animation:pop 0.3s ease;
    }

    @keyframes pop {
      from { transform:scale(0.8); opacity:0; }
      to { transform:scale(1); opacity:1; }
    }

    .modal h2 { color:#f57f17; margin-bottom:8px; }
    .modal .ok-btn {
      display:inline-block;
      margin-top:12px;
      padding:10px 18px;
      border-radius:6px;
      background:#fbc02d;
      color:#fff;
      text-decoration:none;
      font-weight:600;
      transition:0.3s;
    }
    .modal .ok-btn:hover {
      background:#fdd835; 
      color:#4e342e;
      box-shadow:0 4px 12px rgba(0,0,0,0.2);
    }

  </style>
</head>

<body>

  <!-- Background carousel -->
  <div class="bg-carousel" aria-hidden="true">
    <div class="slide"></div>
    <div class="slide"></div>
    <div class="slide"></div>
  </div>

  <div class="container">

    <!-- Sidebar -->
    <aside class="sidebar">

      <div>
        <h2>📜 Registrar Panel</h2>

        <!-- Buttons Styled Uniformly -->
        <form action="viewCaseCServlet" method="post" target="contentFrame">
          <button type="submit" class="nav-btn">View Case Details</button>
        </form>
        
        <form action="${pageContext.request.contextPath}/showNoServlet" method="post" target="contentFrame">
          <button type="submit" class="nav-btn">Assign Case</button>
        </form>
          <form action="${pageContext.request.contextPath}/viewAssignedCaseServlet" method="post" target="contentFrame">
          <button type="submit" class="nav-btn">View Assigned Cases</button>
        </form>
          <form action="${pageContext.request.contextPath}/getPendingCasesServlet" method="post" target="contentFrame">
          <button type="submit" class="nav-btn">Update Hearing Dates</button>
        </form>
        <a href="editStatus.jsp" class="nav-btn" target="contentFrame">Edit Case Details</a>

        

        

        <a href="courtUpdate.jsp" class="nav-btn" target="contentFrame">court Updates</a>

        
      </div>

      <form action="LogoutServlet" method="post">
        <input class="logout-btn" type="submit" value="Logout">
      </form>

    </aside>

    <!-- Main Content -->
    <main class="main">
      <div class="header">
        <h1>Registrar Dashboard</h1>
        <div class="user-info">Registrar: ${sessionScope.username} 📜</div>
      </div>

      <iframe name="contentFrame" class="content-frame" src="registrar.html"></iframe>

      <footer>© 2025 Judiciary Information System | Registrar Portal</footer>
    </main>

  </div>

  <!-- Modal -->
  <%
    boolean showModal = !(cin.trim().isEmpty() && postMessage.trim().isEmpty());
    if (showModal) {
  %>
    <div class="modal-overlay">
      <div class="modal">
        <h2>Case Updated ✅</h2>
        <p><strong><%= postMessage %></strong></p>
        <p>Your CIN: <strong><%= cin %></strong></p>
        <a class="ok-btn" href="viewCaseC.jsp?dismiss=true">OK</a>
      </div>
    </div>
  <% } %>

</body>
</html>