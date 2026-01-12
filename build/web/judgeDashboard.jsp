<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:choose>
<c:when test="${sessionScope.role == 'judge'}">

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Judge Dashboard | Judiciary Information System</title>

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

/* ===== BACKGROUND CAROUSEL ===== */
.bg-carousel{
    position:fixed;
    inset:0;
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

/* ===== UNIFIED BUTTON STYLE ===== */
.nav-btn, .nav-links a{
    background:#ffeb99;
    border:none;
    width:100%;
    padding:12px;
    margin:6px 0;
    border-radius:10px;
    font-size:15px;
    font-weight:600;
    text-decoration:none;
    color:#4e342e;
    cursor:pointer;
    transition:0.3s;
    display:block;
    text-align:left;
    box-shadow:0 2px 6px rgba(0,0,0,0.1);
}

.nav-btn:hover, .nav-links a:hover{
    background:#ffe082;
    transform:translateX(4px);
    box-shadow:0 4px 10px rgba(0,0,0,0.15);
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

/* ===== IFRAME ===== */
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
    <img src="judge1.jpg">
    <img src="judge2.jpeg">
    <img src="judge3.jpeg">
</div>

<!-- SIDEBAR -->
<div class="sidebar">
    <div>
        <h2>⚖️ JIS Judge</h2>

        <ul class="nav-links">

            <!-- View Assigned Case -->
            <li>
                <form action="viewAssignedCaseJServlet" method="post" target="contentFrame">
                    <input type="hidden" name="username" value="${username}">
                    <button type="submit" class="nav-btn">View Assigned Case</button>
                </form>
            </li>

            <!-- Hearing Dates -->
            <li>
                <form action="datesJServlet" method="post" target="contentFrame">
                    <input type="hidden" name="username" value="${username}">
                    <button type="submit" class="nav-btn">Hearing Dates</button>
                </form>
            </li>
            <li>
            <form action="viewCaseCServlet" method="post" target="contentFrame">
                <button type="submit" class="nav-btn">View Case Details</button>
            </form>
            </li>
            <!-- Court Updates -->
            <li>
                <a href="courtUpdate.jsp" class="nav-btn" target="contentFrame">Court Updates</a>
            </li>
        </ul>
    </div>

    <!-- LOGOUT -->
    <div>
        <form action="LogoutServlet" method="post">
            <input class="logout-btn" type="submit" value="Logout">
        </form>
    </div>
</div>

<!-- MAIN CONTENT AREA -->
<div class="main-content">
    <div class="header">
        <h1>Judge Dashboard</h1>
        <div class="user-info">
            Judge : ${sessionScope.username} ⚖️
        </div>
    </div>

    <!-- Iframe -->
    <iframe name="contentFrame" src="judge.html"></iframe>

    <footer>© 2025 Judiciary Information System | Judge Portal</footer>
</div>

</body>
</html>

</c:when>

<c:otherwise>
<!DOCTYPE html>
<html><body><h2>You didn't belong here !!!</h2></body></html>
</c:otherwise>
</c:choose>