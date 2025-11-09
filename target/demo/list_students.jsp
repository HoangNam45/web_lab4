<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        h1 { color: #333; }
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-bottom: 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }
        th {
            background-color: #007bff;
            color: white;
            padding: 12px;
            text-align: left;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover { background-color: #f8f9fa; }
        .action-link {
            color: #007bff;
            text-decoration: none;
            margin-right: 10px;
        }
        .delete-link { color: #dc3545; }
        
        /* Search Form Styles */
        .search-form {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .search-form input[type="text"] {
            width: 300px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-right: 10px;
        }
        .search-form button {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        .search-form button:hover {
            background-color: #218838;
        }
        .search-form .clear-link {
            color: #6c757d;
            text-decoration: none;
            padding: 10px 15px;
        }
        .search-result {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 10px;
        }
        .highlight {
            background-color: yellow;
            font-weight: bold;
        }
        
        /* Pagination Styles */
        .pagination {
            display: flex;
            justify-content: center;
            margin: 20px 0;
            padding: 20px;
        }
        .pagination a, .pagination strong {
            display: inline-block;
            padding: 8px 12px;
            margin: 0 2px;
            text-decoration: none;
            border: 1px solid #ddd;
            color: #007bff;
            border-radius: 4px;
        }
        .pagination a:hover {
            background-color: #e9ecef;
        }
        .pagination strong {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .pagination .disabled {
            color: #6c757d;
            pointer-events: none;
            background-color: #f8f9fa;
        }
        
        /* Exercise 7.2: Improved UI/UX */
        /* Success/Error Message Styling */
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            position: relative;
            display: flex;
            align-items: center;
        }
        .message::before {
            font-size: 18px;
            margin-right: 10px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .success::before {
            content: "✓";
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .error::before {
            content: "✗";
        }
        
        /* Loading States */
        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        /* Responsive Table */
        .table-responsive {
            overflow-x: auto;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .search-form input[type="text"] {
                width: 100%;
                margin-bottom: 10px;
            }
            .search-form button, .search-form .clear-link {
                display: inline-block;
                width: 48%;
                text-align: center;
                margin-right: 2%;
            }
            .search-form .clear-link {
                margin-right: 0;
            }
            table {
                font-size: 12px;
            }
            th, td {
                padding: 5px;
            }
            .btn {
                width: 100%;
                margin-bottom: 10px;
            }
            .pagination {
                flex-wrap: wrap;
            }
            .pagination a, .pagination strong {
                margin: 2px;
                padding: 6px 8px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <h1>📚 Student Management System</h1>
    
    <% if (request.getParameter("message") != null) { %>
        <div class="message success">
            <%= request.getParameter("message") %>
        </div>
    <% } %>
    
    <% if (request.getParameter("error") != null) { %>
        <div class="message error">
            <%= request.getParameter("error") %>
        </div>
    <% } %>
    
    <!-- Search Form -->
    <div class="search-form">
        <form action="list_students.jsp" method="GET">
            <input type="text" name="keyword" 
                   placeholder="Search by name or code..." 
                   value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
            <button type="submit">🔍 Search</button>
            <a href="list_students.jsp" class="clear-link">🗑️ Clear</a>
        </form>
    </div>
    
    <%
        String keyword = request.getParameter("keyword");
        if (keyword != null && !keyword.trim().isEmpty()) {
    %>
        <div class="search-result">
            📊 Search results for: "<strong><%= keyword %></strong>"
        </div>
    <%
        }
    %>
    
    <a href="add_student.jsp" class="btn">➕ Add New Student</a>
    
    <div class="table-responsive">
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Student Code</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Major</th>
                <th>Created At</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    PreparedStatement countPstmt = null;
    Statement stmt = null;
    Statement countStmt = null;
    ResultSet rs = null;
    ResultSet countRs = null;
    
    // Get search keyword (already declared above)
    keyword = request.getParameter("keyword");
    
    // Exercise 7.1: Pagination
    String pageParam = request.getParameter("page");
    int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
    int recordsPerPage = 10;
    int offset = (currentPage - 1) * recordsPerPage;
    
    int totalRecords = 0;
    int totalPages = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/weblab",
            "root",
            "vvhynol806"
        );
        
        // First, get total count for pagination
        String countSql;
        if (keyword != null && !keyword.trim().isEmpty()) {
            countSql = "SELECT COUNT(*) FROM students WHERE full_name LIKE ? OR student_code LIKE ?";
            countPstmt = conn.prepareStatement(countSql);
            String searchPattern = "%" + keyword.trim() + "%";
            countPstmt.setString(1, searchPattern);
            countPstmt.setString(2, searchPattern);
            countRs = countPstmt.executeQuery();
        } else {
            countStmt = conn.createStatement();
            countSql = "SELECT COUNT(*) FROM students";
            countRs = countStmt.executeQuery(countSql);
        }
        
        if (countRs.next()) {
            totalRecords = countRs.getInt(1);
        }
        totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        // Now get the actual data with pagination
        String sql;
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Search query with LIKE operator and pagination
            sql = "SELECT * FROM students WHERE full_name LIKE ? OR student_code LIKE ? ORDER BY id DESC LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword.trim() + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setInt(3, recordsPerPage);
            pstmt.setInt(4, offset);
            rs = pstmt.executeQuery();
        } else {
            // Normal query with pagination
            stmt = conn.createStatement();
            sql = "SELECT * FROM students ORDER BY id DESC LIMIT " + recordsPerPage + " OFFSET " + offset;
            rs = stmt.executeQuery(sql);
        }
        
        boolean hasResults = false;
        while (rs.next()) {
            hasResults = true;
            int id = rs.getInt("id");
            String studentCode = rs.getString("student_code");
            String fullName = rs.getString("full_name");
            String email = rs.getString("email");
            String major = rs.getString("major");
            Timestamp createdAt = rs.getTimestamp("created_at");
            
            // Highlight search term in results (bonus feature)
            String displayName = fullName;
            String displayCode = studentCode;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String keywordRegex = "(?i)(" + keyword.trim().replaceAll("[^a-zA-Z0-9]", "\\\\$0") + ")";
                displayName = fullName.replaceAll(keywordRegex, "<span class='highlight'>$1</span>");
                displayCode = studentCode.replaceAll(keywordRegex, "<span class='highlight'>$1</span>");
            }
%>
            <tr>
                <td><%= id %></td>
                <td><%= displayCode %></td>
                <td><%= displayName %></td>
                <td><%= email != null ? email : "N/A" %></td>
                <td><%= major != null ? major : "N/A" %></td>
                <td><%= createdAt %></td>
                <td>
                    <a href="edit_student.jsp?id=<%= id %>" class="action-link">✏️ Edit</a>
                    <a href="delete_student.jsp?id=<%= id %>" 
                       class="action-link delete-link"
                       onclick="return confirm('Are you sure?')">🗑️ Delete</a>
                </td>
            </tr>
<%
        }
        
        // Show "No results found" message if search yielded no results
        if (!hasResults && keyword != null && !keyword.trim().isEmpty()) {
%>
            <tr>
                <td colspan="7" style="text-align: center; color: #6c757d; padding: 20px;">
                    No students found matching "<%= keyword %>"
                </td>
            </tr>
<%
        } else if (!hasResults) {
%>
            <tr>
                <td colspan="7" style="text-align: center; color: #6c757d; padding: 20px;">
                    No students found. <a href="add_student.jsp">Add the first student</a>
                </td>
            </tr>
<%
        }
    } catch (ClassNotFoundException e) {
        out.println("<tr><td colspan='7'>Error: JDBC Driver not found!</td></tr>");
        e.printStackTrace();
    } catch (SQLException e) {
        out.println("<tr><td colspan='7'>Database Error: " + e.getMessage() + "</td></tr>");
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (countRs != null) countRs.close();
            if (pstmt != null) pstmt.close();
            if (countPstmt != null) countPstmt.close();
            if (stmt != null) stmt.close();
            if (countStmt != null) countStmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
        </tbody>
    </table>
    </div>
    
    <!-- Exercise 7.1: Pagination -->
    <% if (totalPages > 1) { %>
    <div class="pagination">
        <% if (currentPage > 1) { %>
            <a href="list_students.jsp?page=<%= currentPage - 1 %><%= keyword != null ? "&keyword=" + keyword : "" %>">« Previous</a>
        <% } else { %>
            <span class="disabled">« Previous</span>
        <% } %>
        
        <% 
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(totalPages, currentPage + 2);
            
            if (startPage > 1) {
        %>
            <a href="list_students.jsp?page=1<%= keyword != null ? "&keyword=" + keyword : "" %>">1</a>
            <% if (startPage > 2) { %>
                <span>...</span>
            <% } %>
        <% } %>
        
        <% for (int i = startPage; i <= endPage; i++) { %>
            <% if (i == currentPage) { %>
                <strong><%= i %></strong>
            <% } else { %>
                <a href="list_students.jsp?page=<%= i %><%= keyword != null ? "&keyword=" + keyword : "" %>"><%= i %></a>
            <% } %>
        <% } %>
        
        <% if (endPage < totalPages) { %>
            <% if (endPage < totalPages - 1) { %>
                <span>...</span>
            <% } %>
            <a href="list_students.jsp?page=<%= totalPages %><%= keyword != null ? "&keyword=" + keyword : "" %>"><%= totalPages %></a>
        <% } %>
        
        <% if (currentPage < totalPages) { %>
            <a href="list_students.jsp?page=<%= currentPage + 1 %><%= keyword != null ? "&keyword=" + keyword : "" %>">Next »</a>
        <% } else { %>
            <span class="disabled">Next »</span>
        <% } %>
    </div>
    
    <div style="text-align: center; color: #6c757d; margin-top: 10px;">
        Showing page <%= currentPage %> of <%= totalPages %> 
        (Total: <%= totalRecords %> students)
    </div>
    <% } %>
    
    <!-- Exercise 7.2: JavaScript for UX improvements -->
    <script>
        // Auto-hide messages after 3 seconds
        setTimeout(function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) {
                msg.style.transition = 'opacity 0.5s';
                msg.style.opacity = '0';
                setTimeout(function() {
                    msg.style.display = 'none';
                }, 500);
            });
        }, 3000);
        
        // Loading states for forms
        function submitForm(form) {
            var btn = form.querySelector('button[type="submit"]');
            if (btn) {
                btn.disabled = true;
                btn.textContent = 'Processing...';
            }
            return true;
        }
        
        // Add loading state to search form
        document.addEventListener('DOMContentLoaded', function() {
            var searchForm = document.querySelector('.search-form form');
            if (searchForm) {
                searchForm.onsubmit = function() {
                    return submitForm(this);
                };
            }
        });
    </script>
</body>
</html>
