package com.secondproject.cooook.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;

import com.secondproject.cooook.common.DatabaseManager;
import com.secondproject.cooook.common.LocaleUtil;
import com.secondproject.cooook.model.Dashboard;
import com.secondproject.cooook.model.Menu;


public class DashboardDao {
    private String locale = "_k";

	public DashboardDao (HttpServletRequest request) {	
		Locale browserLocale = detectBrowserLocale(request);
		this.locale = LocaleUtil.getLocale(browserLocale);	    
	}

	
	private Locale detectBrowserLocale(HttpServletRequest request) {
		String acceptLanguage = request.getHeader("Accept-Language");
		if (acceptLanguage == null || acceptLanguage.isEmpty()) {
			return Locale.KOREAN;
		}

		String primaryLanguage = acceptLanguage.split(",")[0].trim();
		String languageCode = primaryLanguage.split("-")[0].toLowerCase();

		switch (languageCode) {
			case "ko":	return Locale.KOREAN;
			case "en":	return Locale.ENGLISH;
			default:	return Locale.KOREAN;
		}
	}

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
                    COALESCE(menu_name{0}, menu_name) AS menuName,
        			price AS price,
        			created_at AS createdAt
        		FROM MENU 
				WHERE ROWNUM  <= 5
				ORDER BY created_at DESC        		
        		""";				
        sql = MessageFormat.format(sql, locale);
        
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
                WHERE deleted_at IS NULL 
                AND created_at BETWEEN SYSDATE - 7 AND SYSDATE
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
