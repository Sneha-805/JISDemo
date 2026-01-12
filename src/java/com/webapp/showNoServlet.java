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

@WebServlet(name = "showNoServlet", urlPatterns = {"/showNoServlet"})
public class showNoServlet extends HttpServlet {
      @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // delegate to doPost so a redirect (GET) works
        doPost(req, resp);
    }
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        StringBuilder tableData = new StringBuilder();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/jis_demo", "root", "emaniel23");

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM assign");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
    String cin = rs.getString("cin");
    String assigned = rs.getString("assigned");  // YES/NO from DB

    tableData.append("<tr>");

    tableData.append("<td style='padding:12px 15px;'>")
             .append(cin)
             .append("</td>");

    tableData.append("<td style='padding:12px 15px;'>")
             .append(assigned)
             .append("</td>");

    tableData.append("<td style='padding:12px 15px;'>");

    if ("YES".equalsIgnoreCase(assigned)) {
        tableData.append("<button type='button' disabled "
            + "style=\"background:#d7ccc8; color:#5d4037; padding:8px 16px; "
            + "border:none; border-radius:8px; font-size:14px; font-weight:600; "
            + "opacity:0.6; cursor:not-allowed;\">Assigned</button>");
    } else {
        tableData.append("<form action='showJudgeServlet' method='post' style='margin:0;'>")
                 .append("<input type='hidden' name='cin' value='").append(cin).append("'/>")
                 .append("<button type='submit' "
                 + "style=\"background:#fbc02d; color:#4e342e; padding:8px 16px; border:none; "
                 + "border-radius:8px; font-size:14px; font-weight:600; cursor:pointer;\">"
                 + "Assign</button>")
                 .append("</form>");
    }


    tableData.append("</td>");
    tableData.append("</tr>");
}


            con.close();
        } catch (Exception e) {
            e.printStackTrace(out);
        }
        request.setAttribute("tableData", tableData.toString());
        RequestDispatcher rd = request.getRequestDispatcher("showNoCases.jsp");
        rd.forward(request, response);
    }
}
