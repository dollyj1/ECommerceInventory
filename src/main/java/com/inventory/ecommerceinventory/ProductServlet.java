package com.inventory.ecommerceinventory;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class ProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");

        HttpSession session = request.getSession();

        try {
            double price = Double.parseDouble(priceStr);
            int quantity = Integer.parseInt(quantityStr);

            try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO products (name, category, price, quantity) VALUES (?, ?, ?, ?)");
                ps.setString(1, name);
                ps.setString(2, category);
                ps.setDouble(3, price);
                ps.setInt(4, quantity);

                int result = ps.executeUpdate();

                if (result > 0) {
                    session.setAttribute("productMessage", "✅ Product added successfully!");
                } else {
                    session.setAttribute("productMessage", "❌ Failed to add product.");
                }

                response.sendRedirect("addProduct.jsp");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("productMessage", "❌ Invalid price or quantity format.");
            response.sendRedirect("addProduct.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("productMessage", "❌ Error: " + e.getMessage());
            response.sendRedirect("addProduct.jsp");
        }
    }
}
