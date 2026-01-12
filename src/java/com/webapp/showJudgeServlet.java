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

@WebServlet(name = "showJudgeServlet", urlPatterns = {"/showJudgeServlet"})
public class showJudgeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
         String selectedCin = request.getParameter("cin");
        StringBuilder optionData = new StringBuilder();
        StringBuilder optionData1 = new StringBuilder();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/jis_demo", "root", "emaniel23");

            PreparedStatement ps = con.prepareStatement(
                "SELECT judge_name from judges where status=?");
            ps.setString (1,"AVAILABLE");
            
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String judge_name = rs.getString("judge_name");

                optionData.append("<option value='")
                          .append(judge_name)
                          .append("'>")
                          .append(judge_name)
                          .append("</option>");
            }
            PreparedStatement ps1=con.prepareStatement(
                "SELECT lawyer_name from lawyers where status=?");
            ps1.setString(1, "AVAILABLE");
            
            ResultSet rs1 = ps1.executeQuery();

            while (rs1.next()) {
                String lawyer_name = rs1.getString("lawyer_name");

                optionData1.append("<option value='")
                          .append(lawyer_name)
                          .append("'>")
                          .append(lawyer_name)
                          .append("</option>");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("cin", selectedCin);     
        request.setAttribute("optionData", optionData.toString());
        request.setAttribute("optionData1", optionData1.toString());
        RequestDispatcher rd = request.getRequestDispatcher("showJudge.jsp");
        rd.forward(request, response);
    }
}
