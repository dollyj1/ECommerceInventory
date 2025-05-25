<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.inventory.ecommerceinventory.DBConnection" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    String name = "", category = "";
    double price = 0;
    int quantity = 0;

    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE id = ?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            category = rs.getString("category");
            price = rs.getDouble("price");
            quantity = rs.getInt("quantity");
        }

        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card p-4 shadow">
            <h3 class="text-center text-primary mb-4">✏️ Edit Product</h3>
            <form action="UpdateProductServlet" method="post">
                <input type="hidden" name="id" value="<%= id %>">

                <div class="mb-3">
                    <label>Product Name</label>
                    <input type="text" name="name" class="form-control" value="<%= name %>" required>
                </div>
                <div class="mb-3">
                    <label>Category</label>
                    <input type="text" name="category" class="form-control" value="<%= category %>">
                </div>
                <div class="mb-3">
                    <label>Price (₹)</label>
                    <input type="number" step="0.01" name="price" class="form-control" value="<%= price %>" required>
                </div>
                <div class="mb-3">
                    <label>Quantity</label>
                    <input type="number" name="quantity" class="form-control" value="<%= quantity %>" required>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-warning">Update Product</button>
                    <a href="inventory.jsp" class="btn btn-secondary ms-2">Back</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
