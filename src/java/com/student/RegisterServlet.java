package com.student;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// දැනට තියෙන @WebServlet("/RegisterServlet") එක වෙනුවට මේක දාන්න:
@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dob = request.getParameter("dob");
        String course = request.getParameter("course");
        String password = request.getParameter("password");

        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_db", "root", "");
            
            String sql = "INSERT INTO students (fullname, email, phone, dob, course, password) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, fullname);
            statement.setString(2, email);
            statement.setString(3, phone);
            statement.setString(4, dob);
            statement.setString(5, course);
            statement.setString(6, password);
            
            int rowsInserted = statement.executeUpdate();
            if (rowsInserted > 0) {
                out.println("<body style='background:#0b0c10; color:#66fcf1; font-family:sans-serif; display:flex; justify-content:center; align-items:center; height:100vh;'>");
                out.println("<div style='text-align:center; border:1px solid #66fcf1; padding:30px; border-radius:15px; box-shadow:0 0 20px #66fcf1;'>");
                out.println("<h2>Registration Successful!</h2>");
                out.println("<p>Welcome aboard, " + fullname + ".</p>");
                out.println("<a href='login.html' style='color:#0b0c10; text-decoration:none; background:#66fcf1; padding:10px 20px; border-radius:5px; display:inline-block; margin-top:15px; font-weight:600;'>Login Now</a>");
                out.println("</div></body>");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }
}