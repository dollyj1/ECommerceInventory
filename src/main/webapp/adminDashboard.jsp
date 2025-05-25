<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - GroceryMart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow p-4">
            <h2 class="text-center text-primary">👋 Welcome, <%= username %> (Admin)</h2>
            <div class="list-group">
                <a href="inventory.jsp" class="list-group-item list-group-item-action">📦 Manage Inventory</a>
                <a href="addProduct.jsp" class="list-group-item list-group-item-action">➕ Add Product</a>
                <a href="addSale.jsp" class="list-group-item list-group-item-action">📝 Record Sale</a>
                <a href="salesReport.jsp" class="list-group-item list-group-item-action">📈 Sales Report</a>
                <a href="inventoryReport.jsp" class="list-group-item list-group-item-action">📋 Inventory Report</a>
                <a href="charts.jsp" class="list-group-item list-group-item-action">📊 Sales Chart</a>
                <a href="logout.jsp" class="list-group-item list-group-item-action text-danger">🚪 Logout</a>
            </div>
        </div>
    </div>
</body>
</html>
