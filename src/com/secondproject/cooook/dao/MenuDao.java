package com.secondproject.cooook.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import com.secondproject.cooook.common.DatabaseManager;
import com.secondproject.cooook.model.Menu;

public class MenuDao {  
    private String locale = "_k";
    public MenuDao() {}
    public MenuDao(String locale) {
        this.locale = locale;
    }

    public List<Menu> getAllMenus() {
        List<Menu> menus = new ArrayList<>();
        String sql = """
        		SELECT 
        			m.menu_id AS menuId, 
                    COALESCE(m.menu_name{0}, m.menu_name) AS menuName, 
        			m.price AS price,
        			m.created_at AS createdAt,
        			mc.category_id AS categoryId,
        			c.category_name AS categoryName
        		FROM menu m inner join menu_category mc on m.menu_id = mc.menu_id
        				inner join category c on c.category_id = mc.category_id
        		""";
        sql = MessageFormat.format(sql, locale);
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Menu menu = new Menu();
                menu.setMenuId(rs.getInt("menuId"));
                menu.setCategoryId(rs.getInt("categoryId"));
                menu.setCategoryName(rs.getString("categoryName"));
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
    
    public Menu getMenuById(int id) {
    	String sql = """
    			SELECT 
    				m.menu_id AS menuId, 
                    COALESCE(m.menu_name{0}, m.menu_name) AS menuName,
    				m.price AS price,
    				m.created_at AS createdAt,
    				mc.category_id AS categoryId,
        			c.category_name AS categoryName
    			FROM menu m inner join menu_category mc on m.menu_id = mc.menu_id
        				inner join category c on c.category_id = mc.category_id WHERE m.menu_id = ?    			
    			""";
        sql = MessageFormat.format(sql, locale);
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Menu menu = new Menu();
                menu.setMenuId(rs.getInt("menuId"));
                menu.setCategoryId(rs.getInt("categoryId"));
                menu.setCategoryName(rs.getString("categoryName"));
                menu.setMenuName(rs.getString("menuName"));
                menu.setPrice(rs.getInt("price"));
                menu.setCreatedAt(rs.getDate("createdAt"));
                return menu;
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
        return null;
    }
    
    public int insertMenu(Menu menu) {
    	String sql = """
    			INSERT INTO menu (
    				menu_id, menu_name, menu_name{0}, price, created_at
    			) VALUES (
    				MENU_SEQ.NEXTVAL, ?, ?, ?, SYSDATE
    			)
    			""";
        sql = MessageFormat.format(sql, locale);
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, new String[] {"menu_id"})) {
            
        	ResultSet generatedKeys = null;
        	
            pstmt.setString(1, menu.getMenuName());
            pstmt.setString(2, menu.getMenuName());
            pstmt.setInt(3, menu.getPrice());
            
            pstmt.executeUpdate();
            
            generatedKeys = pstmt.getGeneratedKeys();
            
            int menuId = 0;
            if (generatedKeys.next()) {
                menuId = generatedKeys.getInt(1);
            }
            
            return menuId;
            
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
    }
    
    public boolean updateMenu(Menu menu) {
        String sql = "UPDATE menu SET menu_name = ?, menu_name{0} = ?, price = ? WHERE menu_id = ?";        
        sql = MessageFormat.format(sql, locale);

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, menu.getMenuName());
            pstmt.setString(2, menu.getMenuName());
            pstmt.setInt(3, menu.getPrice());
            pstmt.setInt(4, menu.getMenuId());
            
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
    
    public List<Menu> selectMenusWithoutRecipe() {
        List<Menu> list = new ArrayList<>();
        String sql = """
            SELECT m.menu_id, m.menu_name, m.price
              FROM menu m
             WHERE NOT EXISTS (
                   SELECT 1 FROM recipe r WHERE r.menu_id = m.menu_id
                   )
             ORDER BY m.menu_id
        """;

        try (
            Connection conn = DatabaseManager.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Menu vo = new Menu();
                vo.setMenuId(rs.getInt("menu_id"));
                vo.setMenuName(rs.getString("menu_name"));
                vo.setPrice(rs.getInt("price"));
                list.add(vo);
            }
        } catch (SQLException e) {
            throw new RuntimeException("레시피 미등록 메뉴 조회 중 오류", e);
        }
        return list;
    }
    
}
