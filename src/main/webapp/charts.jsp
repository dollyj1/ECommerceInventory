<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setCharacterEncoding("UTF-8");
%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sales Analytics</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="p-4">
        <div class="container">
            <h2 class="text-center"> Sales Analytics - Product Wise</h2>
            <div class="text-center mt-4">
                <img src="ChartServlet" alt="Sales Chart" class="img-fluid border">
            </div>
            <div class="text-center mt-4">
                <a href="adminDashboard.jsp" class="btn btn-secondary"> Back to Admin Dashboard</a>
            </div>
        </div>
    </body>
</html>
