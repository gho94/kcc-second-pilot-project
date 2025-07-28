package com.secondproject.cooook.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.secondproject.cooook.db.DatabaseManager;
import com.secondproject.cooook.model.Dashboard;
import com.secondproject.cooook.model.Menu;


public class DashboardDao {
	public Dashboard selectDashboard() {
		Dashboard dashboard = null;
		
		String sql = """
				SELECT * FROM dashboard_view
				""";
		
		try (Connection connection = DatabaseManager.getConnection();
			PreparedStatement statement = connection.prepareStatement(sql);
			ResultSet resultSet = statement.executeQuery()	
		){
			if (resultSet.next()) {
				dashboard = new Dashboard();
				
				dashboard.setToday(resultSet.getDate("TODAY"));
				dashboard.setRecipeCount(resultSet.getInt("Recipe_Count"));
				dashboard.setOrderCount(resultSet.getInt("Order_Count"));
				dashboard.setMenuCount(resultSet.getInt("Menu_Count"));
				dashboard.setCategoryCount(resultSet.getInt("Category_Count"));
				
				List<Menu> menus = getTop5Menus();
				dashboard.setMenus(menus);
				
				String totalEarnings = getTotalEarnings();
				dashboard.setTotalEarnings(totalEarnings);
				
				return dashboard;
			}
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
		return dashboard;
	}
	

    private List<Menu> getTop5Menus() {
        List<Menu> menus = new ArrayList<>();
        String sql = """
        		SELECT        		    		 
        			menu_id AS menuId, 
        			menu_name AS menuName, 
        			price AS price,
        			created_at AS createdAt
        		FROM MENU 
				WHERE ROWNUM  <= 5
				ORDER BY created_at DESC        		
        		""";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Menu menu = new Menu();
                menu.setMenuId(rs.getInt("menuId"));
                menu.setMenuName(rs.getString("menuName"));
                menu.setPrice(rs.getInt("price"));
                menu.setCreatedAt(rs.getDate("createdAt"));
                menus.add(menu);
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
        return menus;
    }
    

    private String getTotalEarnings() {        
        String sql = """
        		SELECT
                    TO_CHAR(created_at, 'YYYY-MM-DD') AS day,
                    SUM(total_price) AS total_earnings
                FROM orders
                WHERE created_at BETWEEN SYSDATE - 7 AND SYSDATE
                GROUP BY TO_CHAR(created_at, 'YYYY-MM-DD')
                ORDER BY TO_CHAR(created_at, 'YYYY-MM-DD')		
        		""";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            JSONArray jsonArray = new JSONArray();
            
            while (rs.next()) {
                String day = rs.getString("day");
                int totalEarnings = rs.getInt("total_earnings");
                
                JSONObject jsonObject = new JSONObject();
                
                jsonObject.put("day", day);
                jsonObject.put("earnings", totalEarnings);
                
                jsonArray.put(jsonObject);
            }
            
            return jsonArray.toString();
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
    }
    

}
