package com.inventory.ecommerceinventory;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class CartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Map<String, Object>> cart = new ArrayList<>();

        try {
            int productCount = Integer.parseInt(session.getAttribute("productCount").toString());

            for (int i = 1; i <= productCount; i++) {
                String productIdStr = request.getParameter("product_" + i);
                String quantityStr = request.getParameter("quantity_" + i);

                if (productIdStr != null && quantityStr != null && !quantityStr.isEmpty()) {
                    try {
                        int productId = Integer.parseInt(productIdStr);
                        int quantity = Integer.parseInt(quantityStr);

                        Map<String, Object> item = new HashMap<>();
                        item.put("productId", productId);
                        item.put("quantity", quantity);
                        cart.add(item);
                    } catch (NumberFormatException ignored) {}
                }
            }

            if (!cart.isEmpty()) {
                session.setAttribute("cart", cart);
                response.sendRedirect("cart.jsp");
            } else {
                response.sendRedirect("shop.jsp?error=noselection");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("shop.jsp?error=session");
        }
    }
}
