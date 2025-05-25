<%@ page session="true" %>
<%@ page import="java.util.*, java.sql.*" %>
<%@ page import="com.inventory.ecommerceinventory.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Shopping Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-4">
<div class="container">
    <h2 class="mb-4 text-center">🛒 Your Shopping Cart</h2>

    <%
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
    %>
        <div class="alert alert-info text-center">Your cart is empty. <a href="shop.jsp">Start Shopping</a></div>
    <%
        } else {
            double grandTotal = 0;
    %>
        <form action="UpdateCartServlet" method="post">
        <table class="table table-bordered">
            <thead class="table-light">
                <tr>
                    <th>#</th>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                    <th>Remove</th>
                </tr>
            </thead>
            <tbody>
            <%
                int count = 0;
                for (int i = 0; i < cart.size(); i++) {
                    Map<String, Object> item = cart.get(i);
                    int productId = (int) item.get("productId");
                    int qty = (int) item.get("quantity");
                    double price = 0;
                    String name = "";

                    try {
                        Connection conn = DBConnection.getConnection();
                        PreparedStatement ps = conn.prepareStatement("SELECT name, price FROM products WHERE id = ?");
                        ps.setInt(1, productId);
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) {
                            name = rs.getString("name");
                            price = rs.getDouble("price");
                        }
                        conn.close();
                    } catch (Exception e) {
                        name = "❌ Error fetching product";
                    }

                    double subtotal = price * qty;
                    grandTotal += subtotal;
            %>
                <tr>
                    <td><%= ++count %></td>
                    <td><%= name %></td>
                    <td>₹<%= price %></td>
                    <td>
                        <input type="number" name="quantity_<%= i %>" value="<%= qty %>" min="1" class="form-control" style="width:80px;">
                        <input type="hidden" name="productId_<%= i %>" value="<%= productId %>">
                    </td>
                    <td>₹<%= subtotal %></td>
                    <td>
                        <input type="checkbox" name="remove_<%= i %>">
                    </td>
                </tr>
            <%
                }
            %>
                <tr>
                    <td colspan="4" class="text-end"><strong>Grand Total:</strong></td>
                    <td colspan="2"><strong>₹<%= grandTotal %></strong></td>
                </tr>
            </tbody>
        </table>

        <div class="d-flex justify-content-between">
            <a href="shop.jsp" class="btn btn-secondary">⬅ Continue Shopping</a>
            <div>
                <input type="hidden" name="cartSize" value="<%= cart.size() %>">
                <button type="submit" class="btn btn-warning">🔁 Update Cart</button>
                <a href="CheckoutServlet" class="btn btn-success">💳 Proceed to Checkout</a>
            </div>
        </div>
        </form>
    <%
        }
    %>
</div>
</body>
</html>
