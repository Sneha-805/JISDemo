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

@WebServlet(name = "assignCaseServlet", urlPatterns = {"/assignCaseServlet"})
public class assignCaseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
         String cin = request.getParameter("cin");
         String judge=request.getParameter("judgeName");
         String lawyer=request.getParameter("lawyerName");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/jis_demo", "root", "emaniel23");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO assign_j_l values(?,?,?,?)");
            ps.setString (1,cin);
            ps.setString (2,lawyer);
            ps.setString(3,judge);
            ps.setNull(4, java.sql.Types.VARCHAR);
            
            int i = ps.executeUpdate();
            
            if(i>0){
                System.out.println("Success");
            }
            else{
                System.out.println("fail");
            }
            
            PreparedStatement ps1 = con.prepareStatement(
                "UPDATE assign set assigned=? where cin=?");
            ps1.setString (1,"YES");
            ps1.setString (2,cin);
            int i1=ps1.executeUpdate();
            
            
            PreparedStatement ps2 = con.prepareStatement(
                "UPDATE judges set status=?,current_case_cin=? where judge_name=?");
            ps2.setString (1,"NOT AVAILABLE");
            ps2.setString (2,cin);
            ps2.setString(3, judge);
            int i2=ps2.executeUpdate();
            
            PreparedStatement ps3 = con.prepareStatement(
                "UPDATE lawyers set status=?,current_case_cin=? where lawyer_name=?");
            ps3.setString (1,"NOT AVAILABLE");
            ps3.setString (2,cin);
            ps3.setString(3, lawyer);
            int i3=ps3.executeUpdate();
            
            
            
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
       response.sendRedirect("showNoServlet");

    }
}
