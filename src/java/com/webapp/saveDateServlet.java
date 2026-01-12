package com.webapp;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "saveDateServlet", urlPatterns = {"/saveDateServlet"})
public class saveDateServlet extends HttpServlet {

    private static final String DB_URL  = "jdbc:mysql://localhost:3306/jis_demo";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "emaniel23";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // allow direct GET if needed — forward to POST logic
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cin = request.getParameter("cin");
        String dateStr = request.getParameter("working_date"); // expected "YYYY-MM-DD"

        if (cin == null || cin.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing CIN");
            return;
        }

        java.sql.Date sqlDate = null;
        if (dateStr != null && !dateStr.trim().isEmpty()) {
            try {
                sqlDate = java.sql.Date.valueOf(dateStr.trim());
            } catch (IllegalArgumentException ex) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date format (YYYY-MM-DD)");
                return;
            }
        }

        String upsertSql = "INSERT INTO update_hearing (cin, hearing_date) VALUES (?, ?) "
                         + "ON DUPLICATE KEY UPDATE hearing_date = VALUES(hearing_date)";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            throw new ServletException("JDBC driver not found", ex);
        }

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement ps = con.prepareStatement(upsertSql)) {

            ps.setString(1, cin);
            if (sqlDate == null) {
                ps.setNull(2, Types.DATE);
            } else {
                ps.setDate(2, sqlDate);
            }

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database error saving hearing date", e);
        }

        // Redirect back to the pending-cases page so it reloads and shows the disabled Edit button
        response.sendRedirect(request.getContextPath() + "/getPendingCasesServlet");
    }
}
