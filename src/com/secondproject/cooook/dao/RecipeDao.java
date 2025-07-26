package com.secondproject.cooook.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.secondproject.cooook.db.DatabaseManager;
import com.secondproject.cooook.model.Menu;
import com.secondproject.cooook.model.Recipe;

public class RecipeDao {

	// RecipeDao.java
	public List<Recipe> selectAllRecipes() {
	    List<Recipe> list = new ArrayList<>();

	    String sql =
	      "SELECT "
	    + "  r.recipe_id        AS recipeId, "
	    + "  r.menu_id          AS menuId, "
	    + "  r.quantity         AS quantity, "
	    + "  r.description      AS description, "
	    + "  i.name             AS ingredientName, " // 재료 테이블의 이름(ingredient.name)
	    + "  i.unit_default     AS unit, "
	    + "  m.menu_name        AS menuName "        // 메뉴명
	    + "FROM recipe r "
	    + "  JOIN menu m            ON r.menu_id            = m.menu_id "
	    + "  JOIN ingredient i      ON r.ingredient_id      = i.ingredient_id "
	    + "ORDER BY r.recipe_id";

	    try (
	        Connection conn = DatabaseManager.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery()
	    ) {
	        while (rs.next()) {
	            Recipe r = new Recipe();
	            r.setRecipeId(       rs.getInt("recipeId"));
	            r.setMenuId(         rs.getInt("menuId"));
	            r.setQuantity(       rs.getDouble("quantity"));
	            r.setDescription(    rs.getString("description"));
	            r.setIngredientName( rs.getString("ingredientName"));
	            r.setUnit(           rs.getString("unit"));
	            r.setMenuName(       rs.getString("menuName"));
	            list.add(r);
	        }
	    } catch (SQLException e) {
	        throw new RuntimeException("전체 레시피 조회 중 오류", e);
	    }

	    return list;
	}


	
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
	public List<Recipe> selectByMenuName(String keyword) {
	    List<Recipe> list = new ArrayList<>();
	    String sql = """
	        SELECT r.recipe_id,
	               r.menu_id,
	               r.ingredient_id,
	               r.quantity,
	               r.unit,
	               r.description,
	               i.name         AS ingredient_name,
	               m.menu_name    AS menu_name
	          FROM recipe r
	          JOIN ingredient i ON r.ingredient_id = i.ingredient_id
	          JOIN menu       m ON r.menu_id       = m.menu_id
	         WHERE LOWER(m.menu_name) LIKE LOWER(?)
	         ORDER BY r.recipe_id
	    """;

	    try (
	        Connection conn = DatabaseManager.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql)
	    ) {
	        // 메뉴명이 '%keyword%' 인 경우
	        pstmt.setString(1, "%" + keyword.trim() + "%");
	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                Recipe vo = new Recipe();
	                vo.setRecipeId(rs.getInt("recipe_id"));
	                vo.setMenuId(rs.getInt("menu_id"));
	                vo.setCategoryId(rs.getInt("ingredient_id")); // ingredient_id 사용
	                vo.setQuantity(rs.getDouble("quantity"));
	                vo.setUnit(rs.getString("unit"));
	                vo.setDescription(rs.getString("description"));
	                vo.setIngredientName(rs.getString("ingredient_name"));
	                vo.setMenuName(rs.getString("menu_name"));
	                list.add(vo);
	            }
	        }
	    } catch (SQLException e) {
	        throw new RuntimeException("메뉴명으로 레시피 검색 중 오류", e);
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
