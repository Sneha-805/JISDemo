package com.webapp;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet(name = "editCaseCServlet", urlPatterns = {"/editCaseCServlet"})
public class editCaseCServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cin = request.getParameter("cin");
        String message = "";
        String status = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/jis_demo", "root", "emaniel23");

            PreparedStatement ps = con.prepareStatement(
                "SELECT status FROM case_status WHERE cin = ?");
            ps.setString(1, cin);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                status = rs.getString("status");
                message = "CIN found successfully.";
                request.setAttribute("cin", cin);
                request.setAttribute("status", status);
            } else {
                message = cin + " Not assigned";
            }

            request.setAttribute("message", message);
            request.getRequestDispatcher("editStatus.jsp").forward(request, response);

            rs.close();
            ps.close();
            con.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("editStatus.jsp").forward(request, response);
        }
    }
}
