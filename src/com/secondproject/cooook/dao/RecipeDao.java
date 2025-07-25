package com.secondproject.cooook.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.secondproject.cooook.db.DatabaseManager;
import com.secondproject.cooook.model.Menu;
import com.secondproject.cooook.model.Recipe;

public class RecipeDao {

	public List<Menu> selectMenusWithRecipe() {
	    List<Menu> list = new ArrayList<>();

	    String sql = """
	        SELECT DISTINCT m.menu_id, m.menu_name, m.price
	        FROM menu m
	        JOIN recipe r ON m.menu_id = r.menu_id
	        ORDER BY m.menu_id
	    """;

	    try (
	        Connection conn = DatabaseManager.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        ResultSet rs = pstmt.executeQuery();
	    ) {
	        while (rs.next()) {
	        	Menu vo = new Menu();
	            vo.setMenuId(rs.getInt("menu_id"));
	            vo.setMenuName(rs.getString("menu_name"));
	            vo.setPrice(rs.getInt("price"));
	            list.add(vo);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	public List<Recipe> selectByMenuId(int menuId) {
	    List<Recipe> list = new ArrayList<>();

	    String sql = """
	        SELECT r.recipe_id, r.menu_id, r.ingredient_id, r.quantity, r.unit, r.description,
	               i.name AS ingredient_name,
	               m.menu_name
	        FROM recipe r
	        JOIN ingredient i ON r.ingredient_id = i.ingredient_id
	        JOIN menu m ON r.menu_id = m.menu_id
	        WHERE r.menu_id = ?
	        ORDER BY r.recipe_id
	    """;

	    try (
	        Connection conn = DatabaseManager.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	    ) {
	        pstmt.setInt(1, menuId);
	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {
	            Recipe vo = new Recipe();
	            vo.setRecipeId(rs.getInt("recipe_id"));
	            vo.setMenuId(rs.getInt("menu_id"));
	            vo.setQuantity(rs.getDouble("quantity"));
	            vo.setUnit(rs.getString("unit"));
	            vo.setDescription(rs.getString("description"));
	            vo.setIngredientName(rs.getString("ingredient_name"));
	            vo.setMenuName(rs.getString("menu_name"));
	            list.add(vo);
	        }
	    } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} 

	    return list;
	}

	public int recipeInsert(Recipe vo) {
	    int result = 0;

	    String sql = """
	        INSERT INTO recipe (menu_id, ingredient_id, quantity, unit, description)
	        VALUES (?, ?, ?, ?, ?)
	    """;

	    try (
	        Connection conn = DatabaseManager.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	    ) {
	        pstmt.setInt(1, vo.getMenuId());
	        pstmt.setInt(2, vo.getCategoryId()); 
	        pstmt.setDouble(3, vo.getQuantity());
	        pstmt.setString(4, vo.getUnit());
	        pstmt.setString(5, vo.getDescription());

	        result = pstmt.executeUpdate();
	    } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} 

	    return result;
	}

	public List<Menu> selectMenusWithoutRecipe() {
	    List<Menu> list = new ArrayList<>();

	    String sql = """
	        SELECT m.menu_id, m.menu_name, m.price
	        FROM menu m
	        WHERE NOT EXISTS (
	            SELECT 1 FROM recipe r
	            WHERE r.menu_id = m.menu_id
	        )
	        ORDER BY m.menu_id
	    """;

	    try (
	        Connection conn = DatabaseManager.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        ResultSet rs = pstmt.executeQuery();
	    ) {
	        while (rs.next()) {
	            Menu vo = new Menu();
	            vo.setMenuId(rs.getInt("menu_id"));
	            vo.setMenuName(rs.getString("menu_name"));
	            vo.setPrice(rs.getInt("price"));
	            list.add(vo);
	        }
	    } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} 

	    return list;
	}

	public int updateRecipe(Recipe vo) {
	    int result = 0;

	    String sql = """
	        UPDATE recipe
	        SET quantity = ?, unit = ?, description = ?
	        WHERE recipe_id = ?
	    """;

	    try (
	        Connection conn = DatabaseManager.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	    ) {
	        pstmt.setDouble(1, vo.getQuantity());
	        pstmt.setString(2, vo.getUnit());
	        pstmt.setString(3, vo.getDescription());
	        pstmt.setInt(4, vo.getRecipeId());

	        result = pstmt.executeUpdate();
	    } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} 

	    return result;
	}
	
	public int deleteRecipeById(int recipeId) {
	    int result = 0;

	    String sql = "DELETE FROM recipe WHERE recipe_id = ?";

	    try (
	        Connection conn = DatabaseManager.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	    ) {
	        pstmt.setInt(1, recipeId);
	        result = pstmt.executeUpdate();
	    } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} 

	    return result;
	}

	public int deleteRecipeByMenuId(int menuId) {
	    int result = 0;
	    String sql = "DELETE FROM recipe WHERE menu_id = ?";

	    try (
	        Connection conn = DatabaseManager.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	    ) {
	        pstmt.setInt(1, menuId);
	        result = pstmt.executeUpdate();
	    } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} 

	    return result;
	}


}
