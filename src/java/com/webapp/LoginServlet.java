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
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                if (role.equals("judge")) {
                    response.sendRedirect("judgeDashboard.jsp");
                } else if (role.equals("lawyer")) {
                    response.sendRedirect("lawyerDashboard.jsp");
                }  else if (role.equals("court registrar")) {
                    response.sendRedirect("courtRegistrarDashboard.jsp");
                }  else if (role.equals("police")) {
                    response.sendRedirect("policeDashboard.jsp");
                }  else if (role.equals("publicProsecutor")) {
                    response.sendRedirect("publicProsecutorDashboard.jsp");
                }else {
                    response.sendRedirect("userDashboard.jsp");
                }
            } else {
                out.println("<h3 style='color:red;'>Invalid credentials or role!</h3>");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace(out);
        }
         }
  

    

}
