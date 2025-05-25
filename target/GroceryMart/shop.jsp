<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.inventory.ecommerceinventory.DBConnection" %>
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
    <title>🛍️ GroceryMart - Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-4">
        <div class="card shadow p-4">
            <h2 class="text-center text-primary">🛍️ Welcome to GroceryMart, <%= username %>!</h2>
            <p class="text-center text-muted mb-4">Select products to add to your cart</p>

            <form action="CartServlet" method="post">
                <table class="table table-bordered table-striped align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Select</th>
                            <th>Product</th>
                            <th>Category</th>
                            <th>Price (₹)</th>
                            <th>In Stock</th>
                            <th>Qty</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        try {
                            Connection conn = DBConnection.getConnection();
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM products ORDER BY name ASC");

                            int count = 0;
                            while (rs.next()) {
                                count++;
                                int id = rs.getInt("id");
                    %>
                        <tr>
                            <td><input type="checkbox" name="product_<%= count %>" value="<%= id %>"></td>
                            <td><%= rs.getString("name") %></td>
                            <td><%= rs.getString("category") %></td>
                            <td>₹<%= rs.getDouble("price") %></td>
                            <td><%= rs.getInt("quantity") %></td>
                            <td>
                                <input type="number" name="quantity_<%= count %>" min="1" max="<%= rs.getInt("quantity") %>" value="1" class="form-control" style="width: 80px;">
                            </td>
                        </tr>
                    <%
                            }
                            session.setAttribute("productCount", count);
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6'>❌ Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                    </tbody>
                </table>

                <div class="text-center">
                    <input type="submit" value="🛒 Add Selected Items to Cart" class="btn btn-success px-4">
                </div>
            </form>

            <div class="text-center mt-4">
                <a href="cart.jsp" class="btn btn-outline-primary me-2">🧺 View Cart</a>
                <a href="dashboard.jsp" class="btn btn-outline-secondary">🏠 Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>
