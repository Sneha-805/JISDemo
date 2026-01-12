package com.webapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/paymentServlet"})
public class PaymentServlet extends HttpServlet {

    private static final String DB_URL  = "jdbc:mysql://localhost:3306/jis_demo";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "emaniel23";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role"); // as set by LoginServlet
        if (role == null || !role.equalsIgnoreCase("lawyer")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only lawyers can pay for case access.");
            return;
        }

        Object userIdObj = session.getAttribute("userId");
        String lawyerId = userIdObj != null ? String.valueOf(userIdObj) : (String) session.getAttribute("username");

        String cin = request.getParameter("cin");
        String amountStr = request.getParameter("amount");
        double amount = 0.0;
        try {
            amount = Double.parseDouble(amountStr);
        } catch (Exception e) {
            amount = 0.0;
        }

        if (cin == null || cin.trim().isEmpty() || amount <= 0.0) {
            request.setAttribute("error", "Invalid payment details.");
            request.getRequestDispatcher("/paymentRequired.jsp").forward(request, response);
            return;
        }

        // Record simulated payment (replace with real gateway verification)
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("JDBC driver not found", e);
        }

        String insertSql = "INSERT INTO case_access_payment (lawyer_id, cin, amount, paid_at, transaction_ref) " +
                           "VALUES (?, ?, ?, NOW(), ?) " +
                           "ON DUPLICATE KEY UPDATE amount = VALUES(amount), paid_at = VALUES(paid_at), transaction_ref = VALUES(transaction_ref)";

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement ps = con.prepareStatement(insertSql)) {

            ps.setString(1, lawyerId);
            ps.setString(2, cin);
            ps.setDouble(3, amount);
            ps.setString(4, "SIM_TXN_" + System.currentTimeMillis());
            ps.executeUpdate();

        } catch (SQLException ex) {
            throw new ServletException("Database error recording payment", ex);
        }

        // redirect back to original URL stored in session
        String redirectUrl = (String) session.getAttribute("postPaymentRedirect");
        session.removeAttribute("postPaymentRedirect");
        if (redirectUrl == null || redirectUrl.trim().isEmpty()) {
            redirectUrl = request.getContextPath() + "/caseAccessFilter";
        }
        response.sendRedirect(redirectUrl);
    }
}
