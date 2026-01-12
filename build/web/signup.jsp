<%-- 
    Document   : signup
    Created on : 8 Nov 2025, 3:57:10 pm
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
    <head>
      
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
         <title>Judicial Court Signup Portal</title>
          <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body, html {
            height: 100%;
            width: 100%;
            overflow: hidden;
        }

        /* --- Background carousel --- */
        .carousel-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            overflow: hidden;
        }

        .carousel-slide {
            position: absolute;
            width: 100%;
            height: 100%;
            background-size: cover;
            background-position: center;
            opacity: 0;
            animation: slideShow 16s infinite;
        }

        .carousel-slide:nth-child(1) {
            background-image: url('https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Supreme_Court_of_India%2C_inside_bulidings_01_%28cropped%29.jpg/960px-Supreme_Court_of_India%2C_inside_bulidings_01_%28cropped%29.jpg?20190929035206');
            animation-delay: 0s;
        }

        .carousel-slide:nth-child(2) {
            background-image: url('https://media.istockphoto.com/id/1136594579/photo/justice-system-in-india.jpg?s=612x612&w=0&k=20&c=2a-b37ne5WASbYjsRnw04KoRgzvdPZ5zbKpZyPW4SrI=');
            animation-delay: 4s;
        }

        .carousel-slide:nth-child(3) {
            background-image: url('https://www.lingayasvidyapeeth.edu.in/sanmax/wp-content/uploads/2023/06/INDIAN-LEGAL-SYSTEM.jpg');
            animation-delay: 8s;
        }

        .carousel-slide:nth-child(4) {
            background-image: url('https://www.scobserver.in/wp-content/uploads/2024/06/aerial-view-of-the-supreme-court-1024x486.png');
            animation-delay: 12s;
        }

        @keyframes slideShow {
            0% { opacity: 0; }
            5% { opacity: 1; }
            25% { opacity: 1; }
            30% { opacity: 0; }
            100% { opacity: 0; }
        }

        /* --- Overlay --- */
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.55);
            z-index: 0;
        }

        /* --- Signup Box --- */
        .login-container {
            position: absolute;
            z-index: 1;
            background: rgba(245, 245, 245, 0.93);
            color: #1B263B;
            border-radius: 16px;
            box-shadow: 0 4px 25px rgba(0, 0, 0, 0.4);
            width: 600px;
            padding: 20px 30px;
            top: 50%;
            left: 25%;
            transform: translateY(-50%);
            text-align: center;
            border-top: 6px solid #C9A227;
        }

        .login-container h2 {
            color: #1B263B;
            font-size: 26px;
            margin-bottom: 15px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .form-row {
            display: flex;
            justify-content: space-between;
            gap: 10px;
        }

        .form-group {
            flex: 1;
            text-align: left;
        }

        .login-container select,
        .login-container input {
            width: 100%;
            padding: 10px;
            margin: 6px 0;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .login-container select:focus,
        .login-container input:focus {
            border-color: #C9A227;
            outline: none;
            box-shadow: 0 0 6px rgba(201, 162, 39, 0.5);
        }

        .login-container label {
            color: #1B263B;
            font-weight: 600;
            font-size: 14px;
        }

        .login-container button {
            width: 100%;
            padding: 12px;
            background-color: #C9A227;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 8px;
            margin-top: 10px;
            cursor: pointer;
            transition: background 0.3s;
            font-weight: 600;
        }

        .login-container button:hover {
            background-color: #b08f24;
        }

        .login-container p {
            margin-top: 10px;
            color: #1B263B;
            font-size: 14px;
        }

        .login-container a {
            color: #C9A227;
            text-decoration: none;
            font-weight: bold;
        }

        .login-container a:hover {
            text-decoration: underline;
        }

        .logo {
            width: 80px;
            margin-bottom: 8px;
        }
    </style>
    </head>
    <body>
         <div class="carousel-container">
        <div class="carousel-slide"></div>
        <div class="carousel-slide"></div>
        <div class="carousel-slide"></div>
        <div class="carousel-slide"></div>
    </div>

    <div class="overlay"></div>

    <div class="login-container">
        <img src="https://upload.wikimedia.org/wikipedia/commons/2/2c/Emblem_of_India_%28Tira%E1%B9%85g%C4%81%29.svg" alt="Emblem" class="logo">
        <h2>Judiciary Information System </h2>
        <h4>SignUp Portal </h4>
        <form action="SignupServlet" method="post">

           

            <div class="form-row">
                <div class="form-group">
                    <label for="uname">Username</label>
                    <input name="uname" id="uname" type="text" placeholder="Create username" required>
                </div>
                <div class="form-group">
                    <label for="role">User Type</label>
                    <select name="role" id="role" required>
                        <option value="" disabled selected>Select Role</option>
                        <option value="judge">Judge</option>
                        <option value="lawyer">Lawyer</option>
                        <option value="court registrar">Court Registrar</option>
                        <option value="police">Police</option>
                        <option value="public prosecutor">Public Prosecutor</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="pass">Password</label>
                    <input name="pass" id="pass" type="password" placeholder="Create password" required>
                </div>
                <div class="form-group">
                    <label for="cpass">Confirm Password</label>
                    <input name="cpass" id="cpass" type="password" placeholder="Confirm password" required>
                    <p style="color:red;">
                            ${errorMessage}
                     </p>
                </div>
            </div>

            <button type="submit" name="smt">Sign Up</button>
            <p>Already have an account? <a href="index.html">Login</a></p>
        </form>
    </div>
    </body>
  
</html>

