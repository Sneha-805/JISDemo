<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:choose>
<c:when test="${sessionScope.role == 'lawyer'}">

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Lawyer Dashboard | Judiciary Information System</title>

<style>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:"Poppins",sans-serif;
}

body{
    height:100vh;
    display:flex;
    overflow:hidden;
}

/* ===== BACKGROUND CAROUSEL (CSS ONLY) ===== */
.bg-carousel{
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    z-index:0;
    overflow:hidden;
}

.bg-carousel img{
    position:absolute;
    width:100%;
    height:100%;
    object-fit:cover;
    opacity:0;
    animation:fadeSlide 18s infinite;
    filter:brightness(70%) blur(1px);
}

.bg-carousel img:nth-child(1){animation-delay:0s;}
.bg-carousel img:nth-child(2){animation-delay:6s;}
.bg-carousel img:nth-child(3){animation-delay:12s;}

@keyframes fadeSlide {
    0%{opacity:0;}
    10%{opacity:1;}
    40%{opacity:1;}
    50%{opacity:0;}
    100%{opacity:0;}
}

/* ====== BUTTON STYLE (GLOBAL) ====== */
button, .action-btn{
    width:100%;
    background:#fbc02d;
    color:#4e342e;
    padding:10px 15px;
    border:none;
    border-radius:8px;
    font-size:15px;
    cursor:pointer;
    font-weight:600;
    transition:0.3s;
}

button:hover, .action-btn:hover{
    background:#fdd835;
    transform:scale(1.03);
}

/* ===== SIDEBAR ===== */
.sidebar{
    width:250px;
    background:rgba(255,249,196,0.95);
    border-right:1px solid #fbc02d;
    padding:25px 20px;
    z-index:2;
    display:flex;
    flex-direction:column;
    justify-content:space-between;
}

.sidebar h2{
    text-align:center;
    color:#f57f17;
    font-size:22px;
    margin-bottom:30px;
}

.nav-links{
    list-style:none;
}

.nav-links li{
    margin:15px 0;
}

/* Sidebar links */
.nav-links a{
    text-decoration:none;
    display:block;
    padding:10px 15px;
    border-radius:8px;
    background:#fff8c6;
    color:#5d4037;
    font-size:15px;
    transition:0.3s;
    font-weight:600;
}

.nav-links a:hover{
    background:#ffecb3;
}

/* ===== LOGOUT BUTTON ===== */
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

/* ===== MAIN CONTENT ===== */
.main-content{
    flex:1;
    padding:30px;
    position:relative;
    z-index:1;
}

.header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:20px;
}

.header h1{
    color:#5d4037;
}

.user-info{
    background:#fff59d;
    padding:8px 15px;
    border-radius:8px;
    font-size:14px;
    font-weight:500;
}

/* ===== IFRAME AREA ===== */
iframe{
    width:100%;
    height:80vh;
    border:none;
    border-radius:14px;
    background:rgba(255,255,255,0.9);
    box-shadow:0 0 20px rgba(255,235,59,0.3);
}

footer{
    text-align:center;
    margin-top:10px;
    font-size:13px;
    color:#5d4037;
}
</style>

</head>
<body>

<!-- Background Images -->
<div class="bg-carousel">
    <img src="lawyer1.jpg">
    <img src="lawyer2.jpeg">
    <img src="lawyer3.jpeg">
</div>

<!-- SIDEBAR -->
<div class="sidebar">
    <div>
        <h2>⚖️ JIS Lawyer</h2>

        <ul class="nav-links">

            <li>
                <form action="viewAssignedCaseLServlet" method="post" target="contentFrame">
                    <input type="hidden" name="username" value="${username}">
                    <button type="submit">View Assigned Case</button>
                </form>
            </li>

            <li>
                <form action="datesLServlet" method="post" target="contentFrame">
                    <input type="hidden" name="username" value="${username}">
                    <button type="submit">Hearing Dates</button>
                </form>
            </li>

            <li>
                <form action="courtUpdate.jsp" method="get" target="contentFrame">
                    <button type="submit">Court Updates</button>
                </form>
            </li>



            <li style="margin-top:12px;">
                <form action="caseAccessFilter" method="post" target="contentFrame">
                    <button type="submit">View Case</button>
                </form>
            </li>

        </ul>
    </div>

    <div>
        <form action="LogoutServlet" method="post">
            <input class="logout-btn" type="submit" value="Logout">
        </form>
    </div>
</div>

<!-- MAIN CONTENT AREA -->
<div class="main-content">
    <div class="header">
        <h1>Lawyer Dashboard</h1>
        <div class="user-info">
            Lawyer : ${sessionScope.username} ⚖️
        </div>
    </div>

    <!-- IFRAME -->
    <iframe name="contentFrame" src="lawyer.html"></iframe>

    <footer>© 2025 Judiciary Information System | Lawyer Portal</footer>
</div>

</body>
</html>

</c:when>

<c:otherwise>
<!DOCTYPE html>
<html><body><h2>You didn't belong here !!!</h2></body></html>
</c:otherwise>
</c:choose>