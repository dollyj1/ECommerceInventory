
package com.inventory.ecommerceinventory;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class UpdateCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
        }

        int cartSize = Integer.parseInt(request.getParameter("cartSize"));
        List<Map<String, Object>> updatedCart = new ArrayList<>();

        for (int i = 0; i < cartSize; i++) {
            String remove = request.getParameter("remove_" + i);
            String qtyStr = request.getParameter("quantity_" + i);
            String pidStr = request.getParameter("productId_" + i);

            if (pidStr != null && qtyStr != null && !qtyStr.isEmpty()) {
                int productId = Integer.parseInt(pidStr);
                int quantity = Integer.parseInt(qtyStr);

                if (remove == null) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("productId", productId);
                    item.put("quantity", quantity);
                    updatedCart.add(item);
                }
                // if 'remove' checkbox was ticked, we skip adding it to updated cart
            }
        }

        session.setAttribute("cart", updatedCart);
        response.sendRedirect("cart.jsp"); // back to updated cart
    }
}