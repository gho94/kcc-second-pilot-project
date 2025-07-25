package com.secondproject.cooook.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.secondproject.cooook.db.DatabaseManager;
import com.secondproject.cooook.model.Menu;

public class MenuDao {  
    public List<Menu> getAllMenus() {
        List<Menu> menus = new ArrayList<>();
        
        String sql = "SELECT menu_id AS menuId, menu_name AS menuName, price AS price FROM menu";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Menu menu = new Menu();
                menu.setMenuId(rs.getInt("menuId"));
                menu.setMenuName(rs.getString("menuName"));
                menu.setPrice(rs.getInt("price"));
                menus.add(menu);
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
        return menus;
    }
    
    public Menu getMenuById(int id) {
        String sql = "SELECT menu_id AS menuId, menu_name AS menuName, price AS price FROM menu WHERE menu_id = ?";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Menu menu = new Menu();
                menu.setMenuId(rs.getInt("menuId"));
                menu.setMenuName(rs.getString("menuName"));
                menu.setPrice(rs.getInt("price"));
                return menu;
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
        return null;
    }
    
    public int insertMenu(Menu menu) {
        String sql = "INSERT INTO menu VALUES (MENU_SEQ.NEXTVAL, ?, ?)";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, menu.getMenuName());
            pstmt.setInt(2, menu.getPrice());
            return pstmt.executeUpdate();
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
    }
    
    public boolean updateMenu(Menu menu) {
        String sql = "UPDATE menu SET menu_name = ?, price = ? WHERE menu_id = ?";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, menu.getMenuName());
            pstmt.setInt(2, menu.getPrice());
            pstmt.setInt(3, menu.getMenuId());
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
    }
    
    public boolean deleteMenu(int menuId) {
        String deleteMenuCategorySql = "DELETE FROM menu_category WHERE menu_id = ?";
        String deleteMenuSql = "DELETE FROM menu WHERE menu_id = ?";

        try (Connection connection = DatabaseManager.getConnection()) {
            connection.setAutoCommit(false);

            try (PreparedStatement menuCategoryStatement = connection.prepareStatement(deleteMenuCategorySql);
                PreparedStatement menuStatement = connection.prepareStatement(deleteMenuSql)) {

                menuCategoryStatement.setInt(1, menuId);
                menuCategoryStatement.executeUpdate();

                menuStatement.setInt(1, menuId);
                int affectedRows = menuStatement.executeUpdate();

                connection.commit();
                return affectedRows > 0;

            } catch (SQLException e) {
                connection.rollback();
                System.err.println("❌ 트랜잭션 롤백됨: " + e.getMessage());
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
        return false;
    }
    
    public List<Menu> searchMenusByName(String keyword) {
        List<Menu> menus = new ArrayList<>();
        
        String sql = "SELECT menu_id AS menuId, menu_name AS menuName, price AS price FROM menu WHERE menu_name LIKE ? ORDER BY menu_name";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + keyword + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Menu menu = new Menu();
                menu.setMenuId(rs.getInt("menuId"));
                menu.setMenuName(rs.getString("menuName"));
                menu.setPrice(rs.getInt("price"));
                menus.add(menu);
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
        return menus;
    }
}
