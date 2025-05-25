<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page import="com.inventory.ecommerceinventory.DBConnection" %>
<%@ page session="true" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String orderParam = request.getParameter("order_id");
    if (orderParam == null) {
        out.println("❌ Missing order_id in URL.");
        return;
    }

    int orderId = Integer.parseInt(orderParam);
    double grandTotal = 0;
    int totalItems = 0;
    Timestamp saleDate = null;

    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
<div class="container invoice-box border p-4 rounded">
    <h2 class="text-center mb-3">🧾 Invoice - GroceryMart</h2>
    <p><strong>Order ID:</strong> #<%= orderId %></p>

    <table class="table table-bordered">
        <thead class="table-light">
            <tr>
                <th>Product</th>
                <th>Qty</th>
                <th>Price/Unit (₹)</th>
                <th>Total (₹)</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                    "SELECT s.quantity, s.total_price, s.sale_date, p.name, p.price " +
                    "FROM sales s JOIN products p ON s.product_id = p.id WHERE s.order_id = ?");
                ps.setInt(1, orderId);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    String name = rs.getString("name");
                    int qty = rs.getInt("quantity");
                    double price = rs.getDouble("price");
                    double total = rs.getDouble("total_price");
                    saleDate = rs.getTimestamp("sale_date");

                    totalItems++;
                    grandTotal += total;
        %>
            <tr>
                <td><%= name %></td>
                <td><%= qty %></td>
                <td>₹<%= price %></td>
                <td>₹<%= total %></td>
            </tr>
        <%
                }
                conn.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='4'>❌ Error: " + e.getMessage() + "</td></tr>");
            }
        %>
        <tr>
            <td colspan="3" class="text-end"><strong>Total Items:</strong></td>
            <td><%= totalItems %></td>
        </tr>
        <tr>
            <td colspan="3" class="text-end"><strong>Grand Total:</strong></td>
            <td><strong>₹<%= grandTotal %></strong></td>
        </tr>
        </tbody>
    </table>

    <p><strong>Date:</strong> <%= (saleDate != null ? sdf.format(saleDate) : "N/A") %></p>

    <div class="text-center mt-4">
        ✅ Thank you for shopping with GroceryMart!
        <br><br>
        <button class="btn btn-primary" onclick="window.print()">🖨️ Print Invoice</button>
    </div>
</div>
</body>
</html>
