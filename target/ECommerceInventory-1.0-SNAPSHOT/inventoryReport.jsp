<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.inventory.ecommerceinventory.DBConnection" %>
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
    <title>Inventory Report - GroceryMart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="text-center mb-4 text-primary">📦 Inventory Report</h2>
    <table class="table table-bordered table-striped align-middle">
        <thead class="table-dark">
            <tr>
                <th>Product</th>
                <th>Category</th>
                <th>Price (₹)</th>
                <th>Stock</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM products");

                while (rs.next()) {
                    int qty = rs.getInt("quantity");
        %>
        <tr>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("category") %></td>
            <td>₹<%= rs.getDouble("price") %></td>
            <td><%= qty %></td>
            <td>
                <%= (qty < 10) 
                    ? "<span class='text-danger fw-bold'>Low Stock</span>" 
                    : "<span class='text-success'>OK</span>" %>
            </td>
        </tr>
        <%
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='5'>❌ Error: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>
    <div class="text-center mt-4">
        <a href="adminDashboard.jsp" class="btn btn-outline-secondary">🏠 Back to Dashboard</a>
    </div>
</div>
</body>
</html>
