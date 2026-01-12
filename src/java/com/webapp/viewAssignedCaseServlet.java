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

@WebServlet(name = "viewAssignedCaseServlet", urlPatterns = {"/viewAssignedCaseServlet"})
public class viewAssignedCaseServlet extends HttpServlet {

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
        StringBuilder tableData = new StringBuilder();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/jis_demo", "root", "emaniel23");

            PreparedStatement ps = con.prepareStatement(
                "SELECT cin,lawyer,judge FROM assign_j_l");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                tableData.append("<tr>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("cin")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("lawyer")).append("</td>")
                         .append("<td style='padding:12px 15px;'>").append(rs.getString("judge")).append("</td>")
                         .append("</tr>");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace(out);
        }
        request.setAttribute("tableData", tableData.toString());
        RequestDispatcher rd = request.getRequestDispatcher("viewAssignedCase.jsp");
        rd.forward(request, response);
    }
}
