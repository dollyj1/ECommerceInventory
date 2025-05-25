<%@page contentType="text/html; charset=UTF-8"%>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"user".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String orderId = request.getParameter("order_id");
    if (orderId == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment - GroceryMart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow p-4">
        <h2 class="text-center text-primary">💳 Choose Payment Method</h2>
        <p class="text-center">Order ID: <strong>#<%= orderId %></strong></p>

        <form action="SalesReceipt.jsp" method="get" class="text-center">
            <input type="hidden" name="order_id" value="<%= orderId %>">

            <div class="mb-3">
                <label>Select Method:</label>
                <select class="form-select" style="max-width: 300px; margin: auto;" name="method" required>
                    <option value="">-- Choose --</option>
                    <option value="razorpay">💳 Razorpay</option>
                    <option value="gpay">📱 Google Pay</option>
                    <option value="paytm">💰 Paytm</option>
                    <option value="cod">🚚 Cash on Delivery</option>
                </select>
            </div>

            <button class="btn btn-success">✅ Pay & View Invoice</button>
        </form>
    </div>
</div>

</body>
</html>

