<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page import="com.inventory.ecommerceinventory.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

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
    <title>Sales Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-4">
    <div class="container">
        <h2 class="text-center mb-4">📈 Sales Report</h2>
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>Order ID</th>
                    <th>Product</th>
                    <th>Qty</th>
                    <th>Price/Unit</th>
                    <th>Total</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    Connection conn = DBConnection.getConnection();
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(
                        "SELECT s.order_id, s.quantity, s.total_price, s.sale_date, p.name, p.price " +
                        "FROM sales s JOIN products p ON s.product_id = p.id ORDER BY s.sale_date DESC"
                    );
                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");
                    while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getInt("order_id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getInt("quantity") %></td>
                    <td>₹<%= rs.getDouble("price") %></td>
                    <td>₹<%= rs.getDouble("total_price") %></td>
                    <td><%= sdf.format(rs.getTimestamp("sale_date")) %></td>
                </tr>
            <%
                    }
                    conn.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='6'>❌ Error: " + e.getMessage() + "</td></tr>");
                }
            %>
            </tbody>
        </table>
        <div class="text-center mt-4">
            <a href="adminDashboard.jsp" class="btn btn-secondary">⬅ Back to Admin Dashboard</a>
        </div>
    </div>
</body>
</html>
