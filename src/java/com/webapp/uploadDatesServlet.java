package com.webapp;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "uploadDatesServlet", urlPatterns = {"/uploadDatesServlet"})
public class uploadDatesServlet extends HttpServlet {
     @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
       throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String cin = request.getParameter("cin");
        if (cin == null || cin.trim().isEmpty()) {
            response.getWriter().println("<p>No CIN received.</p>");
            return;
        }

        String url = "jdbc:mysql://localhost:3306/jis_demo";
        String user = "root";
        String pass = "emaniel23";

        List<String> workingDates = new ArrayList<>();

        String sql = "SELECT working_date FROM court_working_days"; // assume format YYYY-MM-DD

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String workingDate = rs.getString("working_date");
                if (workingDate != null && !workingDate.trim().isEmpty()) {
                    workingDates.add(workingDate.trim());
                }
            }

        } catch (SQLException e) {
            e.printStackTrace(response.getWriter());
            return;
        }

        // build a small JSON array string for the JSP JS to consume
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < workingDates.size(); i++) {
            if (i > 0) json.append(",");
            json.append("\"").append(escapeJson(workingDates.get(i))).append("\"");
        }
        json.append("]");

        request.setAttribute("cin", cin);
        request.setAttribute("workingDatesJson", json.toString());
        RequestDispatcher rd = request.getRequestDispatcher("uploadDates.jsp");
        rd.forward(request, response);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
