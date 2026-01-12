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

@WebServlet(name = "viewAssignedCaseJServlet", urlPatterns = {"/viewAssignedCaseJServlet"})
public class viewAssignedCaseJServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        // allow GET to behave the same as POST (prevents 405 for iframe initial load)
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
         String username = request.getParameter("username");
        StringBuilder tableData = new StringBuilder();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/jis_demo", "root", "emaniel23");

            PreparedStatement ps = con.prepareStatement(
                "SELECT current_case_cin FROM judges where judge_name=?");
            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();
            String cin=null;
            if(rs.next()) {
               cin=rs.getString("current_case_cin");
            }
            PreparedStatement ps1 = con.prepareStatement(
                "SELECT * FROM police_reports where cin=?");
            ps1.setString(1, cin);

            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                tableData.append("<tr>")
                         .append("<td style='padding:12px 15px;'>").append(rs1.getString("cin")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs1.getString("defendant_name")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs1.getString("defendant_addr")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs1.getString("crime_typ")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs1.getString("date_commit")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs1.getString("crime_addr")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs1.getString("arrst_off_name")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs1.getString("date_arrst")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs1.getString("posted_by")).append("</td>")
                        .append("<td style='padding:12px 15px;'>").append(rs1.getString("status")).append("</td>")
                         .append("</tr>");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace(out);
        }
        request.setAttribute("tableData", tableData.toString());
        RequestDispatcher rd = request.getRequestDispatcher("viewAssignedCaseJ.jsp");
        rd.forward(request, response);
    }
}
