package com.webapp;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet(name = "getPendingCasesServlet", urlPatterns = {"/getPendingCasesServlet"})
public class getPendingCasesServlet extends HttpServlet {

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
        PrintWriter out = response.getWriter();
        StringBuilder tableData = new StringBuilder();

        String sql = "SELECT cs.cin, cs.status, uh.hearing_date " +
                     "FROM case_status cs " +
                     "LEFT JOIN update_hearing uh ON cs.cin = uh.cin " +
                     "WHERE LOWER(cs.status) = ? " +
                     "ORDER BY cs.cin";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            throw new ServletException("JDBC driver not found", ex);
        }

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "pending");

            try (ResultSet rs = ps.executeQuery()) {
                boolean any = false;
                while (rs.next()) {
                    any = true;
                    String cin = rs.getString("cin");
                    String status = rs.getString("status");
                    Date hearingDate = rs.getDate("hearing_date"); // may be null

                    tableData.append("<tr>");
                    tableData.append("<td style='padding:12px 15px;'>").append(escape(cin)).append("</td>");
                    tableData.append("<td style='padding:12px 15px;'>").append(escape(status)).append("</td>");

                    // hearing date cell
                    if (hearingDate != null) {
                        tableData.append("<td style='padding:12px 15px;'>").append(hearingDate.toString()).append("</td>");
                    } else {
                        tableData.append("<td style='padding:12px 15px;'>-</td>");
                    }

                    // Edit / Disabled button column
                    tableData.append("<td style='padding:12px 15px;'>");

                    if (hearingDate != null) {

                        // DISABLED BUTTON (hearing date already exists)
                        tableData.append("<button type='button' disabled "
                            + "style=\"background:#d7ccc8; color:#5d4037; padding:6px 14px; "
                            + "border:none; border-radius:8px; font-size:14px; font-weight:600; "
                            + "opacity:0.6; cursor:not-allowed;\">Edit</button>");

                    } else {

                        // ACTIVE EDIT BUTTON
                        tableData.append("<form action='uploadDatesServlet' method='post' style='margin:0;'>")
                                 .append("<input type='hidden' name='cin' value='").append(escape(cin)).append("'/>")
                                 .append("<button type='submit' "
                                 + "style=\"background:#fbc02d; color:#4e342e; padding:6px 14px; border:none; "
                                 + "border-radius:8px; font-size:14px; font-weight:600; cursor:pointer;\">"
                                 + "Edit</button>")
                                 .append("</form>");
                    }

                    tableData.append("</td>");


                    tableData.append("</tr>");
                }

                if (!any) {
                    tableData.append("<tr><td colspan='4' style='text-align:center;'>No pending cases found.</td></tr>");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace(out);
            throw new ServletException("Database error", e);
        }

        request.setAttribute("tableData", tableData.toString());
        RequestDispatcher rd = request.getRequestDispatcher("getPendingCases.jsp");
        rd.forward(request, response);
    }

    private static String escape(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
