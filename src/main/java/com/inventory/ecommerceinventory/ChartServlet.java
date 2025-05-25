package com.inventory.ecommerceinventory;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtils;
import org.jfree.chart.JFreeChart;
import org.jfree.data.category.DefaultCategoryDataset;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class ChartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DefaultCategoryDataset dataset = new DefaultCategoryDataset();

        try (Connection conn = DBConnection.getConnection()) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(
                "SELECT p.name, SUM(s.quantity) as total_sold " +
                "FROM sales s JOIN products p ON s.product_id = p.id " +
                "GROUP BY p.name");

            while (rs.next()) {
                String product = rs.getString("name");
                int soldQty = rs.getInt("total_sold");
                dataset.addValue(soldQty, "Sales", product);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        JFreeChart chart = ChartFactory.createBarChart(
                "📊 Product Sales Summary",
                "Product Name",
                "Units Sold",
                dataset
        );

        response.setContentType("image/png");
        ChartUtils.writeChartAsPNG(response.getOutputStream(), chart, 800, 500);
    }
}
