package com.inventory.ecommerceinventory;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class SalesServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession();
        int productCount = (int) session.getAttribute("productCount");
        int orderId = (int) (System.currentTimeMillis() / 1000);
        Timestamp saleDate = new Timestamp(System.currentTimeMillis());

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO sales (product_id, quantity, total_price, sale_date, order_id) VALUES (?, ?, ?, ?, ?)");

            for (int i = 1; i <= productCount; i++) {
                String pidStr = request.getParameter("product_" + i);
                String qtyStr = request.getParameter("quantity_" + i);

                if (pidStr != null && qtyStr != null && !pidStr.isEmpty() && !qtyStr.isEmpty()) {
                    int productId = Integer.parseInt(pidStr);
                    int qty = Integer.parseInt(qtyStr);

                    PreparedStatement psCheck = conn.prepareStatement("SELECT price, quantity FROM products WHERE id = ?");
                    psCheck.setInt(1, productId);
                    ResultSet rs = psCheck.executeQuery();

                    if (rs.next()) {
                        double price = rs.getDouble("price");
                        int stock = rs.getInt("quantity");

                        if (qty > stock) {
                            conn.rollback();
                            response.getWriter().println("❌ Not enough stock for product ID: " + productId);
                            return;
                        }

                        double total = qty * price;

                        ps.setInt(1, productId);
                        ps.setInt(2, qty);
                        ps.setDouble(3, total);
                        ps.setTimestamp(4, saleDate);
                        ps.setInt(5, orderId);
                        ps.executeUpdate();

                        PreparedStatement psUpdate = conn.prepareStatement("UPDATE products SET quantity = quantity - ? WHERE id = ?");
                        psUpdate.setInt(1, qty);
                        psUpdate.setInt(2, productId);
                        psUpdate.executeUpdate();
                    }
                }
            }

            conn.commit();
            response.sendRedirect("SalesReceipt.jsp?order_id=" + orderId);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error: " + e.getMessage());
        }
    }
}
