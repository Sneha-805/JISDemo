package com.webapp;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet(name = "updateStatusServlet", urlPatterns = {"/updateStatusServlet"})
public class updateStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cin = request.getParameter("cin");
        String newStatus = request.getParameter("status");
        String message = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/jis_demo", "root", "emaniel23");

            PreparedStatement ps = con.prepareStatement(
                "UPDATE case_status SET status = ? WHERE cin = ?");
            ps.setString(1, newStatus);
            ps.setString(2, cin);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                message = "✅ Status updated to '" + newStatus + "' for CIN: " + cin;
            } else {
                message = "⚠️ No record found for CIN: " + cin;
            }

            ps.close();
            con.close();

            // Show confirmation on same JSP
            request.setAttribute("message", message);
            request.setAttribute("cin", cin);
            request.setAttribute("status", newStatus);
            request.getRequestDispatcher("editStatus.jsp").forward(request, response);

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("editStatus.jsp").forward(request, response);
        }
    }
}
