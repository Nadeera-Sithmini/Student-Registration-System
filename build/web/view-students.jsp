<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - View Students</title>
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght=300;400;600&display=swap" rel="stylesheet">
    <style>
        .dashboard-container {
            width: 90%;
            max-width: 1200px;
            margin: 50px auto;
            background: rgba(31, 40, 51, 0.6);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
        }
        .student-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 0.95rem;
        }
        .student-table th, .student-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .student-table th {
            background-color: rgba(102, 252, 241, 0.1);
            color: #66fcf1;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
        }
        .student-table tr:hover {
            background-color: rgba(255, 255, 255, 0.05);
        }
        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.8rem;
            text-decoration: none;
            display: inline-block;
        }
        .btn-edit {
            background-color: #66fcf1;
            color: #0b0c10;
            margin-right: 5px;
        }
        .btn-edit:hover {
            background-color: #45a29e;
        }
        .btn-delete {
            background-color: #ff4d4d;
            color: #fff;
        }
        .btn-delete:hover {
            background-color: #ff3333;
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid rgba(102, 252, 241, 0.3);
            padding-bottom: 15px;
        }
        /* Search Area එකට අලුතින්ම දාපු CSS Styles */
        .search-container {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
        .search-input {
            flex: 1;
            padding: 10px 15px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.05);
            color: #fff;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
        }
        .search-input:focus {
            outline: none;
            border-color: #66fcf1;
        }
        .btn-search {
            padding: 10px 25px;
            background-color: #66fcf1;
            color: #0b0c10;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-clear {
            padding: 10px 20px;
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
        }
    </style>
</head>
<body style="height: auto; overflow-y: auto; display: block;">

    <div class="dashboard-container">
        <div class="top-bar">
            <h2>Admin Dashboard</h2>
            <a href="index.html" style="color: #66fcf1; text-decoration: none; font-weight: 600;">+ Add New Student</a>
        </div>
        
        <!-- මෙන්න අලුතින්ම එකතු කරපු Search Form එක -->
        <form method="GET" action="view-students.jsp">
            <div class="search-container">
                <% 
                    // කලින් සර්ච් කරපු අකුරක් තියෙනවා නම් ඒක ආයේ බාර් එකේ පෙන්වන්න ගන්නවා
                    String searchQuery = request.getParameter("search");
                    if(searchQuery == null) searchQuery = "";
                %>
                <input type="text" name="search" class="search-input" placeholder="Search students by Name or Course..." value="<%= searchQuery %>">
                <button type="submit" class="btn-search">Search</button>
                <% if(!searchQuery.equals("")) { %>
                    <a href="view-students.jsp" class="btn-clear">Clear</a>
                <% } %>
            </div>
        </form>

        <table class="student-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>DOB</th>
                    <th>Course</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_db", "root", "");
                        
                        String sql = "";
                        PreparedStatement stmt = null;
                        
                        // Admin කෙනෙක් සර්ච් බාර් එකේ යමක් ටයිප් කරලා තිබුණොත් ඒකට ගැලපෙන Query එක රන් කරනවා
                        if (!searchQuery.equals("")) {
                            sql = "SELECT * FROM students WHERE fullname LIKE ? OR course LIKE ?";
                            stmt = conn.prepareStatement(sql);
                            stmt.setString(1, "%" + searchQuery + "%");
                            stmt.setString(2, "%" + searchQuery + "%");
                        } else {
                            // කිසිවක් සර්ච් කර නැත්නම් සාමාන්‍ය පරිදි ඔක්කොම පෙන්වනවා
                            sql = "SELECT * FROM students";
                            stmt = conn.prepareStatement(sql);
                        }
                        
                        ResultSet rs = stmt.executeQuery();
                        boolean hasData = false;
                        
                        while(rs.next()) {
                            hasData = true;
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("fullname") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("phone") %></td>
                    <td><%= rs.getString("dob") %></td>
                    <td style="color: #66fcf1; text-transform: uppercase;"><%= rs.getString("course") %></td>
                    <td>
                        <a href="edit-student.jsp?id=<%= rs.getInt("id") %>" class="btn-action btn-edit">Edit</a>
                        <a href="DeleteStudentServlet?id=<%= rs.getInt("id") %>" class="btn-action btn-delete" onclick="return confirm('Are you sure you want to delete this student?');">Delete</a>
                    </td>
                </tr>
                <%
                        }
                        // කිසිම ශිෂ්‍යයෙක් හොයාගන්න බැරි වුණොත් වැටෙන මැසේජ් එක
                        if(!hasData) {
                            out.println("<tr><td colspan='7' style='text-align:center; padding: 20px; color: #ff4d4d;'>No students found matching your search.</td></tr>");
                        }
                        
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                    } finally {
                        try { if(conn != null) conn.close(); } catch(Exception e) {}
                    }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>