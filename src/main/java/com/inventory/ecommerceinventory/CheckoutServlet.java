package com.inventory.ecommerceinventory;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to POST
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp?error=empty");
            return;
        }

        int orderId = (int) (System.currentTimeMillis() / 1000); // Unique ID
        Timestamp saleDate = new Timestamp(System.currentTimeMillis());

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            PreparedStatement insertStmt = conn.prepareStatement(
                "INSERT INTO sales (product_id, quantity, total_price, sale_date, order_id) VALUES (?, ?, ?, ?, ?)");

            for (Map<String, Object> item : cart) {
                int productId = (int) item.get("productId");
                int quantity = (int) item.get("quantity");

                PreparedStatement checkStmt = conn.prepareStatement(
                    "SELECT price, quantity FROM products WHERE id = ?");
                checkStmt.setInt(1, productId);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    double price = rs.getDouble("price");
                    int currentStock = rs.getInt("quantity");

                    if (quantity > currentStock) {
                        conn.rollback();
                        response.getWriter().println("❌ Not enough stock for product ID: " + productId);
                        return;
                    }

                    double total = price * quantity;

                    insertStmt.setInt(1, productId);
                    insertStmt.setInt(2, quantity);
                    insertStmt.setDouble(3, total);
                    insertStmt.setTimestamp(4, saleDate);
                    insertStmt.setInt(5, orderId);
                    insertStmt.executeUpdate();

                    PreparedStatement updateStmt = conn.prepareStatement(
                        "UPDATE products SET quantity = quantity - ? WHERE id = ?");
                    updateStmt.setInt(1, quantity);
                    updateStmt.setInt(2, productId);
                    updateStmt.executeUpdate();

                } else {
                    conn.rollback();
                    response.getWriter().println("❌ Product not found (ID: " + productId + ")");
                    return;
                }
            }

            conn.commit();
            session.removeAttribute("cart"); // Empty the cart

            response.sendRedirect("payment.jsp?order_id=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Checkout Error: " + e.getMessage());
        }
    }
}
