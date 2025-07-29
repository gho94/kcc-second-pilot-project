package com.secondproject.cooook.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.secondproject.cooook.common.DatabaseManager;
import com.secondproject.cooook.model.Ingredient;

public class IngredientDao {
	  public List<Ingredient> selectAll() {
	        List<Ingredient> list = new ArrayList<>();

	        String sql = "SELECT ingredient_id, name, unit_default FROM ingredient ORDER BY ingredient_id";

	        try (
	            Connection conn = DatabaseManager.getConnection();
	            PreparedStatement pstmt = conn.prepareStatement(sql);
	            ResultSet rs = pstmt.executeQuery();
	        ) {
	            while (rs.next()) {
	                Ingredient vo = new Ingredient();
	                vo.setIngredientId(rs.getInt("ingredient_id"));
	                vo.setIngredientName(rs.getString("name"));
	                vo.setUnitDefault(rs.getString("unit_default"));
	                list.add(vo);
	            }
	        } catch (Exception e) {
				System.out.println(e.getMessage());
				throw new RuntimeException(e);
			}

	        return list;
	    }

}
