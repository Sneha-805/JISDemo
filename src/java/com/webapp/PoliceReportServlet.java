/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.webapp;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;


/**
 *
 * @author HP
 */
@WebServlet(name = "PoliceReportServlet", urlPatterns = {"/PoliceReportServlet"})
public class PoliceReportServlet extends HttpServlet {

 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name_def=request.getParameter("name_def");
        String addr=request.getParameter("addr");
        String crime_typ=request.getParameter("crime_typ");
        String date_comt=request.getParameter("date_comt");
        String where =request.getParameter("where");
        String arrst_off=request.getParameter("arrst_off");
        String date_arrst=request.getParameter("date_arrst");
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        if (name_def == null || name_def.isBlank() || addr == null || addr.isBlank()
                || crime_typ == null || date_comt == null || date_comt.isBlank()) {
            out.println("Required fields are missing.");
            return;
        }
        if (addr != null) addr = addr.trim();
        if (where != null) where = where.trim();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/jis_demo", "root", "emaniel23");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO police_reports(defendant_name,defendant_addr,crime_typ,date_commit,crime_addr,arrst_off_name,date_arrst) VALUES(?,?,?,?,?,?,?)");
            ps.setString(1,name_def );
            ps.setString(2, addr);
            ps.setString(3, crime_typ);
            ps.setString(4,date_comt);
            ps.setString(5,where);
            ps.setString(6,arrst_off);
            ps.setString(7,date_arrst);
            int i = ps.executeUpdate();
            if (i > 0) {
               response.getWriter().println("Details submitted succesfully");
              
            } else {
                response.getWriter().println("Error! Details not submitted");
            }
          

            con.close();
        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }

   

}
