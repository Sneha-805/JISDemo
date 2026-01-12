/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.webapp;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;

/**
 *
 * @author HP
 */

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {
         @Override
         protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("uname");
        String password = request.getParameter("pass");
        String role = request.getParameter("role");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/jis_demo", "root", "emaniel23");

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE username=? AND password=? AND role=?");
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);

            ResultSet rs = ps.executeQuery();

           if (rs.next()) {
            
            int userId = rs.getInt("id");            
            String dbRole = rs.getString("role");      

            HttpSession session = request.getSession();
            session.setAttribute("userId", userId);
            session.setAttribute("username", rs.getString("username"));
            session.setAttribute("role", dbRole);
            request.setAttribute("username", rs.getString("username"));
           

          
            if ("judge".equalsIgnoreCase(dbRole)) {
                 request.getRequestDispatcher("judgeDashboard.jsp").forward(request, response);
            } else if ("lawyer".equalsIgnoreCase(dbRole)) {
                response.sendRedirect("lawyerDashboard.jsp");
            } else if ("court registrar".equalsIgnoreCase(dbRole)) {
                response.sendRedirect("courtRegistrarDashboard.jsp");
            } else if ("police".equalsIgnoreCase(dbRole)) {
                response.sendRedirect("policeDashboard.jsp");
            } else if ("public Prosecutor".equalsIgnoreCase(dbRole)) {
                response.sendRedirect("publicProsecutorDashboard.jsp");
            } else {
                response.sendRedirect("userDashboard.jsp");
            }
        }
     else {
                out.println("<h3 style='color:red;'>Invalid credentials or role!</h3>");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace(out);
        }
         }
  

    

}
