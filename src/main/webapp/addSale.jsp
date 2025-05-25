<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.inventory.ecommerceinventory.DBConnection" %>
<%@ page session="true" %>
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
    <title>Record Sale</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
    <div class="container">
        <h2 class="mb-4">📦 Record New Sale</h2>
        <form action="SalesServlet" method="post" class="table-responsive">
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Select</th>
                        <th>Product</th>
                        <th>Available</th>
                        <th>Price</th>
                        <th>Quantity</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection conn = DBConnection.getConnection();
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM products");

                            int count = 0;
                            while (rs.next()) {
                                count++;
                    %>
                        <tr>
                            <td><input type="checkbox" name="product_<%= count %>" value="<%= rs.getInt("id") %>"></td>
                            <td><%= rs.getString("name") %></td>
                            <td><%= rs.getInt("quantity") %></td>
                            <td>₹<%= rs.getDouble("price") %></td>
                            <td><input type="number" name="quantity_<%= count %>" min="1" class="form-control" value="1"></td>
                        </tr>
                    <%
                            }
                            session.setAttribute("productCount", count);
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5'>❌ Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
            <button type="submit" class="btn btn-success">✅ Record Sale</button>
            <a href="inventory.jsp" class="btn btn-secondary">🔙 Back to Inventory</a>
        </form>
    </div>
</body>
</html>
