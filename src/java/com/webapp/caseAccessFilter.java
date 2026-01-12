package com.webapp;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "caseAccessFilter", urlPatterns = {"/caseAccessFilter"})
public class caseAccessFilter extends HttpServlet {

    private static final String DB_URL  = "jdbc:mysql://localhost:3306/jis_demo";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "emaniel23";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        // Use session attributes set by your LoginServlet
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username"); // from LoginServlet
        String role = (String) session.getAttribute("role");         // from LoginServlet, e.g. "lawyer"
        Object userIdObj = session.getAttribute("userId");
        String userId = userIdObj != null ? String.valueOf(userIdObj) : null;

        // If this request is a direct "view" action (cin param present), handle that first
        String requestedCin = request.getParameter("cin");
        if (requestedCin != null && !requestedCin.trim().isEmpty()) {
            // Check ownership/payment below — but simplest: forward to this servlet itself to decide.
            // For clarity here we'll proceed to ownership/payment checks below with requestedCin set.
        }

        // Only lawyers need payment-check; others can be forwarded directly to the view servlet
        boolean isLawyer = (role != null && role.equalsIgnoreCase("lawyer"));

        try (PrintWriter out = response.getWriter()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                throw new ServletException("JDBC driver not found", e);
            }

            // If no specific CIN (i.e. page load to list reports), build the table
            if (requestedCin == null || requestedCin.trim().isEmpty()) {
                StringBuilder tableData = new StringBuilder();
                String currentCaseCin = null;

                String selectLawyerSql = "SELECT current_case_cin FROM lawyers WHERE lawyer_name = ?";
                try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                     PreparedStatement ps = con.prepareStatement(selectLawyerSql)) {

                    ps.setString(1, username);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            currentCaseCin = rs.getString("current_case_cin");
                            if (currentCaseCin != null) currentCaseCin = currentCaseCin.trim();
                        }
                    }

                    // Use safe query: if currentCaseCin is null, select all; otherwise exclude it
                    PreparedStatement ps1;
                    if (currentCaseCin == null || currentCaseCin.isEmpty()) {
                        ps1 = con.prepareStatement("SELECT cin FROM police_reports");
                    } else {
                        ps1 = con.prepareStatement("SELECT cin FROM police_reports WHERE cin <> ?");
                        ps1.setString(1, currentCaseCin);
                    }

                    try (PreparedStatement stmt = ps1; ResultSet rs1 = stmt.executeQuery()) {
                        while (rs1.next()) {
                            String policeCin = rs1.getString("cin");
                            if (policeCin == null) continue;
                            policeCin = policeCin.trim();

                            tableData.append("<tr>")
                                     .append("<td style='padding:12px 15px;'>").append(policeCin).append("</td>")
                                     .append("<td>")
                                     // form submits to this servlet with cin param; target iframe as in your dashboard
                                     .append("<form action='paymentServlet' method='post' target='contentFrame' style='margin:0;'>")
                                     .append("<input type='hidden' name='cin' value='").append(policeCin).append("'/>")
                                     .append("<button type='submit'>View</button>")
                                     .append("</form>")
                                     .append("</td>")
                                     .append("</tr>");
                        }
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace(out);
                    throw new ServletException("Database error listing police reports", ex);
                }

                request.setAttribute("tableData", tableData.toString());
                RequestDispatcher rd = request.getRequestDispatcher("casefilter.jsp");
                rd.forward(request, response);
            }

        }
    }
}
