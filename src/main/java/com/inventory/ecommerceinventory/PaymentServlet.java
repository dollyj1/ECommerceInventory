/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.ecommerceinventory;

/**
 *
 * @author dolly
 */
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class PaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("order_id");
        String cardholder = request.getParameter("cardholder");

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO payments (order_id, status, method, payer) VALUES (?, ?, ?, ?)");
            ps.setInt(1, Integer.parseInt(orderIdStr));
            ps.setString(2, "PAID");
            ps.setString(3, "Simulated Razorpay");
            ps.setString(4, cardholder);
            ps.executeUpdate();

            response.sendRedirect("SalesReceipt.jsp?order_id=" + orderIdStr);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Payment Failed: " + e.getMessage());
        }
    }
}

