<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"user".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Dashboard - GroceryMart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow p-4">
            <h2 class="text-center text-success">👋 Hello, <%= username %>!</h2>
            <p class="text-center text-muted">You are logged in as a <strong>User</strong>.</p>

            <div class="list-group">
                <a href="shop.jsp" class="list-group-item list-group-item-action">🛒 Start Shopping</a>
                <a href="cart.jsp" class="list-group-item list-group-item-action">🧺 View Cart</a>
                <a href="CheckoutServlet" class="list-group-item list-group-item-action">💳 Proceed to Checkout</a>
                <a href="logout.jsp" class="list-group-item list-group-item-action text-danger">🚪 Logout</a>
            </div>
        </div>
    </div>
</body>
</html>
