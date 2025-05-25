<%@ page import="java.sql.*" %>
<%@ page import="com.inventory.ecommerceinventory.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
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
    <title>Product Inventory - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow p-4">
        <h3 class="text-center text-primary mb-4">📦 Inventory Management</h3>

        <!-- ✅ BEGIN CART FORM -->
        <form action="CartServlet" method="post">
        <table class="table table-bordered table-striped align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Select</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Price (₹)</th>
                    <th>Stock</th>
                    <th>Qty</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    Connection conn = DBConnection.getConnection();
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM products ORDER BY quantity ASC");

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
                    <td><input type="number" name="quantity_<%= count %>" class="form-control" min="1" max="<%= rs.getInt("quantity") %>" value="1"></td>
                    <td>
                        <a href="editProduct.jsp?id=<%= id %>" class="btn btn-sm btn-primary"><i class="bi bi-pencil"></i></a>
                        <a href="DeleteProductServlet?id=<%= id %>" onclick="return confirm('Are you sure?');" class="btn btn-sm btn-danger"><i class="bi bi-trash"></i></a>
                    </td>
                </tr>
            <%
                    }
                    session.setAttribute("productCount", count);
                    conn.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='7'>❌ Error: " + e.getMessage() + "</td></tr>");
                }
            %>
            </tbody>
        </table>

        <div class="text-center">
            <input type="submit" value="🛒 Add Selected Items to Cart" class="btn btn-success px-4">
        </div>
        </form>
        <!-- ✅ END CART FORM -->

        <div class="text-center mt-4">
            <a href="addProduct.jsp" class="btn btn-outline-primary me-2">➕ Add New Product</a>
            <a href="dashboard.jsp" class="btn btn-outline-secondary me-2">🏠 Back to Dashboard</a>
            <a href="cart.jsp" class="btn btn-outline-dark">🛒 View Cart</a>
        </div>
    </div>
</div>

</body>
</html>
