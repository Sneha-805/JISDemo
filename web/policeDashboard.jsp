<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  // Read session values set by servlet
  String cin = (String) session.getAttribute("cin");
  String postMessage = (String) session.getAttribute("postMessage");

  // If user clicked the "OK" link to dismiss the modal, remove attributes
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
 <c:choose>
            <c:when test="${sessionScope.role == 'police'}">
           
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Police Dashboard | Judiciary Information System</title>

  <style>
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');
    *{box-sizing:border-box;margin:0;padding:0;font-family:"Poppins",sans-serif;}
    body{min-height:100vh;color:#5d4037;position:relative;overflow:hidden;}

    /* ===== Background Carousel (pure CSS) ===== */
    .bg-carousel {
      position:fixed; inset:0; z-index:0; overflow:hidden;
    }
    .bg-carousel .slide {
      position:absolute; inset:0; background-size:cover; background-position:center;
      opacity:0; animation:fade 18s infinite;
      filter: brightness(70%) blur(1px);
    }
    /* staggered delays produce the carousel */
    .bg-carousel .slide:nth-child(1){ background-image:url('https://media.istockphoto.com/id/487787078/photo/close-up-of-a-statue-of-goddess-of-justice.jpg?s=612x612&w=0&k=20&c=faT25Z1jK2_WASpmGjESYq37Ql32GfKQwRdntsGJzes='); animation-delay:0s; }
    .bg-carousel .slide:nth-child(2){ background-image:url('https://image.shutterstock.com/image-photo/indian-law-concept-showing-wooden-260nw-710676328.jpg'); animation-delay:6s; }
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
      z-index:1; /* above background */
    }

    /* Sidebar */
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
    .sidebar h2 { text-align:center;color:#f57f17;font-size:22px;margin-bottom:20px; }
    .nav-links { list-style:none; padding-left:0; }
    .nav-links li { margin:12px 0; }
    .nav-links a {
      display:block; padding:10px 12px; border-radius:8px; text-decoration:none; color:#5d4037;
      font-weight:600;
    }
    .nav-links a:hover, .nav-links a:focus { background:#fff59d; color:#5d4037; }

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

    /* Main content area (contains iframe) */
    .main {
      flex:1;
      padding:30px;
      overflow:auto;
    }
    .header { display:flex; justify-content:space-between; align-items:center; margin-bottom:25px;}
    .header h1 { color:#5d4037; font-size:26px; }
    .user-info { background:#fff59d; padding:8px 15px; border-radius:8px; font-size:14px; color:#5d4037; font-weight:500; }

    /* iframe styling */
    .content-frame {
      width:100%;
      height:calc(100vh - 150px);
      border:none;
      background:transparent;
      border-radius:14px;
      box-shadow:0 0 20px rgba(255,235,59,0.25);
    }

    footer { text-align:center; font-size:13px; color:#5d4037; margin-top:18px; }

    /* Modal (server-driven; no JS) */
    .modal-overlay {
      position:fixed; inset:0; display:flex; align-items:center; justify-content:center;
      background:rgba(0,0,0,0.5); z-index:200; 
    }
    .modal {
      background:#fffde7; padding:22px 28px; border-radius:10px; text-align:center; color:#5d4037;
      box-shadow:0 10px 25px rgba(0,0,0,0.2); max-width:420px;
    }
    .modal h2 { color:#f57f17; margin-bottom:8px; }
    .modal p { margin:8px 0; }
    .modal .ok-btn {
      display:inline-block; margin-top:12px; padding:8px 14px; border-radius:6px;
      background:#fbc02d; color:#fff; text-decoration:none; font-weight:600;
    }
    .modal .ok-btn:hover { background:#fdd835; color:#5d4037; }

    /* Responsive adjustments */
    @media (max-width:800px){
      .sidebar{ width:220px; padding:18px; }
      .main{ padding:18px; }
    }
  </style>
</head>
<body>
    
       
                
           
  <!-- Background carousel (pure CSS) -->
  <div class="bg-carousel" aria-hidden="true">
    <div class="slide"></div>
    <div class="slide"></div>
    <div class="slide"></div>
  </div>

  <div class="container">
    <!-- Sidebar -->
    <aside class="sidebar" role="navigation" aria-label="Main navigation">
      <div>
        <h2>🚔 Police Panel</h2>
        <ul class="nav-links">
          <!-- Links target the iframe named "contentFrame" -->
          <li><a href="postCase.jsp" target="contentFrame">Post a Case</a></li>
          <li><a href="viewstatus.jsp" target="contentFrame">View Case Status</a></li>
          <li><a href="courtUpdate.jsp" target="contentFrame">Court Announcements</a></li>
        </ul>
      </div>

      <div>
        <form action="LogoutServlet" method="post">
            <input class="logout-btn" type="submit" value="Logout">
        </form>
    </div>
    </aside>

    <!-- Main area -->
    <main class="main">
      <div class="header">
        <h1>Police Dashboard</h1>
        <div class="user-info">Officer: ${sessionScope.username} 🚔</div>
      </div>

      <!-- iframe: initial src is the Post Case content -->
      <iframe name="contentFrame" class="content-frame" src="police.html" title="Content Frame"></iframe>

      <footer>© 2025 Judiciary Information System | Police Portal</footer>
    </main>
  </div>

  <!-- Server-side modal (no JS). Modal appears only when session contains cin or postMessage -->
  <%
    boolean showModal = !(cin.trim().isEmpty() && postMessage.trim().isEmpty());
    if (showModal) {
  %>
    <div class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
      <div class="modal">
        <h2 id="modalTitle">Case Submitted ✅</h2>
        <p><strong><%= postMessage %></strong></p>
        <p>Your CIN: <strong><%= cin %></strong></p>
        <!-- clicking OK reloads the page with a dismiss param which causes the JSP to clear the session attrs -->
        <a class="ok-btn" href="postCase.jsp?dismiss=true">OK</a>
      </div>
    </div>
  <% } %>

</body>
</html>
 </c:when>
 <c:when test="${sessionScope.role != 'police'}">
     <!DOCTYPE html>
     <html>
         <body>
             <h2>You didn't belong to here !!!</h2>
         </body>
     </html>    
 </c:when>
 </c:choose>