package com.inventory.ecommerceinventory;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class DeleteProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        response.setContentType("text/html;charset=UTF-8");

        try (Connection conn = DBConnection.getConnection();
             PrintWriter out = response.getWriter()) {

            // Check if the product is referenced in the sales table
            PreparedStatement check = conn.prepareStatement(
                "SELECT COUNT(*) FROM sales WHERE product_id = ?");
            check.setInt(1, id);
            ResultSet rs = check.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                // Product has associated sales — do not allow delete
                out.println("<script>alert('❌ Cannot delete: Product has existing sales.'); window.location='inventory.jsp';</script>");
                return;
            }

            // If no sales, proceed to delete
            PreparedStatement ps = conn.prepareStatement("DELETE FROM products WHERE id = ?");
            ps.setInt(1, id);
            int result = ps.executeUpdate();

            if (result > 0) {
                response.sendRedirect("inventory.jsp");
            } else {
                out.println("<script>alert('❌ Failed to delete product.'); window.location='inventory.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error: " + e.getMessage());
        }
    }
}
