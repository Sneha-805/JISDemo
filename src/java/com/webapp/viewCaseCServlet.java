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

@WebServlet(name = "viewCaseCServlet", urlPatterns = {"/viewCaseCServlet"})
public class viewCaseCServlet extends HttpServlet {

  
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
                "SELECT * FROM police_reports");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                tableData.append("<tr>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("cin")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("defendant_name")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("defendant_addr")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("crime_typ")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("date_commit")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("crime_addr")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("arrst_off_name")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("date_arrst")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("posted_by")).append("</td>")
                        .append("<td style='padding:12px 15px;'>").append(rs.getString("status")).append("</td>")
                         .append("</tr>");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace(out);
        }
        request.setAttribute("tableData", tableData.toString());
        RequestDispatcher rd = request.getRequestDispatcher("viewCaseC.jsp");
        rd.forward(request, response);
    }
}
