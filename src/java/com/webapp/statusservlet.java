package com.webapp;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet(name = "statusservlet", urlPatterns = {"/statusservlet"})
public class statusservlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cin = request.getParameter("cin");
        String message = "";
        String status = "";

        response.setContentType("text/html;charset=UTF-8");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/jis_demo", "root", "emaniel23");

            // ✅ Trim the CIN both in input and in DB comparison
            PreparedStatement ps = con.prepareStatement(
                "SELECT status FROM case_status WHERE TRIM(cin) = TRIM(?)");

            ps.setString(1, cin.trim());

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                status = rs.getString("status");
                message = "CIN found successfully.";
                request.setAttribute("cin", cin);
                request.setAttribute("status", status);
            } else {
                message = "No record found for CIN: " + cin;
            }

            request.setAttribute("message", message);
            request.getRequestDispatcher("viewstatus.jsp").forward(request, response);

            rs.close();
            ps.close();
            con.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("viewstatus.jsp").forward(request, response);
        }
    }
}
