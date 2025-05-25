<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"user".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - GroceryMart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-5">
<div class="container text-center">
    <h2>💳 Proceed to Checkout</h2>
    <form action="CheckoutServlet" method="post">
        <button type="submit" class="btn btn-success mt-4">✅ Confirm Order & Generate Invoice</button>
    </form>
    <br><a href="cart.jsp">⬅️ Back to Cart</a>
</div>
</body>
</html>
