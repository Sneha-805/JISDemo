<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Check Case Status — Police Portal</title>
  <style>
    body {
      font-family: "Poppins", sans-serif;
      background: linear-gradient(180deg, #fff 0%, #fbf8f3 100%);
      color: #5d4037;
      display: flex;
      justify-content: center;
      align-items: flex-start;
      min-height: 100vh;
      padding: 40px 20px;
    }
    .wrap { width: 100%; max-width: 700px; }
    .card {
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
      padding: 30px;
    }
    h1, h2 { color: #f57f17; text-align: center; }
    label { font-weight: 600; display: block; margin-top: 10px; }
    input[type="text"] {
      width: 100%; padding: 10px; margin-top: 5px;
      border: 1px solid #fbc02d; border-radius: 8px;
      background: #fffde7;
    }
    .btn {
      background: #fbc02d; color: #fff; border: none;
      padding: 10px 16px; border-radius: 8px;
      cursor: pointer; margin-top: 10px;
    }
    .btn:hover { background: #fdd835; color: #5d4037; }
    .result { margin-top: 15px; background: #fffde7; padding: 10px; border-radius: 8px; }
  </style>
</head>
<body>
  <div class="wrap">
    <main class="card">
      <h1>Edit Case Status</h1>

      <!-- FORM 1: Get CIN -->
      <form action="editCaseCServlet" method="post">
        <label for="cin">Enter CIN:</label>
        <input type="text" id="cin" name="cin" required>
        <button type="submit" class="btn">Search</button>
      </form>

      <!-- Display message if any -->
      <c:if test="${not empty message}">
        <div class="result">
          <p>${message}</p>
        </div>
      </c:if>

      <!-- FORM 2: Edit Status (only if CIN exists) -->
      <c:if test="${not empty cin}">
        <div class="result">
          <p><b>CIN:</b> ${cin}</p>
          <p><b>Current Status:</b> ${status}</p>

          <form action="updateStatusServlet" method="post">
            <!-- Hidden CIN so we know which record to update -->
            <input type="hidden" name="cin" value="${cin}">
            <label>Edit Status:</label>
            <input type="radio" name="status" value="pending" required> Pending<br>
            <input type="radio" name="status" value="resolved"> Resolved<br>
            <button type="submit" class="btn">UPDATE</button>
          </form>
        </div>
      </c:if>
    </main>
  </div>
</body>
</html>
