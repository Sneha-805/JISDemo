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

@WebServlet(name = "datesJServlet", urlPatterns = {"/datesJServlet"})
public class datesJServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
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

            // 1️⃣ Get CIN assigned to judge
            PreparedStatement ps = con.prepareStatement(
                "SELECT current_case_cin FROM judges WHERE judge_name=?");
            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();
            String cin = null;

            if (rs.next()) {
                cin = rs.getString("current_case_cin");
            }

            // If judge has no assigned case → no need to query hearing table
            if (cin != null) {

                // 2️⃣ Fetch hearing date (CORRECT QUERY)
                PreparedStatement ps1 = con.prepareStatement(
                    "SELECT cin, hearing_date FROM update_hearing WHERE cin=?");
                ps1.setString(1, cin);

                ResultSet rs1 = ps1.executeQuery();

                while (rs1.next()) {
                    tableData.append("<tr>")
                             .append("<td style='padding:12px 15px;'>").append(rs1.getString("cin")).append("</td>")
                             .append("<td style='padding:12px 15px;'>").append(rs1.getString("hearing_date")).append("</td>")
                             .append("</tr>");
                }
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace(out);
        }

        request.setAttribute("tableData", tableData.toString());
        RequestDispatcher rd = request.getRequestDispatcher("datesJ.jsp");
        rd.forward(request, response);
    }
}
