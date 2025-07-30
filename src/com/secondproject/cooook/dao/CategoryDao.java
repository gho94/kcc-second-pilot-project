package com.secondproject.cooook.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import com.secondproject.cooook.common.DatabaseManager;
import com.secondproject.cooook.model.Category;

public class CategoryDao {
	private String locale = "_k";
	public CategoryDao() {}
	public CategoryDao(String locale) {
		this.locale = locale;	
	}
	
	public List<Category> selectCategory() {
		List<Category> categories = new ArrayList<>();
		
		String sql = """
				SELECT 
					category_id 	AS categoryId, 
					COALESCE(category_name{0}, category_name) AS categoryName,
					parent_id 		AS parentId, 
					level
				FROM category
				START WITH parent_id IS NULL
				CONNECT BY PRIOR category_id = parent_id
				ORDER SIBLINGS BY category_id				
				""";
        sql = MessageFormat.format(sql, locale);
		
		try (Connection connection = DatabaseManager.getConnection();
				PreparedStatement statement = connection.prepareStatement(sql);
				ResultSet resultSet = statement.executeQuery()) {
			
			while (resultSet.next()) {
				Category category = new Category();
				
				category.setCategoryId(resultSet.getInt("categoryId"));
				category.setCategoryName(resultSet.getString("categoryName"));
				category.setParentId(resultSet.getObject("parentId", Integer.class));
				category.setLevel(resultSet.getInt("level"));
				
				categories.add(category);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
		return categories;
	}
	


	public boolean isCircularReference(int categoryId, int newParentId) {
		String sql = """
				SELECT COUNT(*) AS CNT
				FROM (
					SELECT category_id
					FROM Category
					START WITH category_id = ?
					CONNECT BY PRIOR category_id = parent_id
				) t
				WHERE category_id = ? 
				""";
		try (Connection connection = DatabaseManager.getConnection();
				PreparedStatement statement = connection.prepareStatement(sql)){

			statement.setInt(1, categoryId);
			statement.setInt(2, newParentId);

			ResultSet resultSet = statement.executeQuery();			
			
			if (resultSet.next()) {
				return resultSet.getInt("CNT") > 0;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
		return false;
	}

	public List<Category> selectChildCategory(int categoryId) {
		List<Category> categories = new ArrayList<>();
		
		String sql = """
				SELECT 
					category_id 	AS categoryId, 
					category_name 	AS categoryName,
					parent_id 		AS parentId, 
					level
				FROM category
				START WITH category_id = ?
				CONNECT BY PRIOR category_id = parent_id
				ORDER SIBLINGS BY category_id					
			""";
		
		try (Connection connection = DatabaseManager.getConnection();
				PreparedStatement statement = connection.prepareStatement(sql)) {
			statement.setInt(1, categoryId);
			
			ResultSet resultSet = statement.executeQuery();

			while (resultSet.next()) {
				Category category = new Category();
				
				category.setCategoryId(resultSet.getInt("categoryId"));
				category.setCategoryName(resultSet.getString("categoryName"));
				category.setParentId(resultSet.getObject("parentId", Integer.class));
				category.setLevel(resultSet.getInt("level"));
				
				categories.add(category);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
		return categories;
	}
	
	public Category selectCategoryById(int categoryId) {
		String sql = """
				SELECT 
					category_id 	AS categoryId,
					category_name 	AS categoryName,
					parent_id 		AS parentId
				FROM category
				WHERE category_id = ?
				""";
		try (Connection connection = DatabaseManager.getConnection();
			PreparedStatement statement = connection.prepareStatement(sql)){
			
			statement.setInt(1, categoryId);
			ResultSet resultSet = statement.executeQuery();

			if (resultSet.next()) {
				Category category = new Category();

				category.setCategoryId(resultSet.getInt("categoryId"));
				category.setCategoryName(resultSet.getString("categoryName"));
				category.setParentId(resultSet.getObject("parentID", Integer.class));

				return category;
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
		return null;
	}
	
	public int insertCategory(Category category) {
		String sql = """
				INSERT INTO category (
					category_id,
					category_name,
					category_name{0},
					parent_id
				) VALUES (
				    CATEGORY_SEQ.NEXTVAL, 
				    ?, 
					?,
				    (SELECT category_id 
				     FROM category 
				     WHERE category_id = ?)
				)
				""";		
        sql = MessageFormat.format(sql, locale);
		try (Connection connection = DatabaseManager.getConnection();
				PreparedStatement statement = connection.prepareStatement(sql)) {

			statement.setString(1, category.getCategoryName());
			statement.setString(2, category.getCategoryName());
			statement.setInt(3, category.getParentId());
			
			return statement.executeUpdate();
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
	}

	public boolean updateCategory(Category category, int updateType) {
		String sql = "UPDATE category SET ";
		sql += updateType == 0 ? "category_name = ?, category_name{0} = ? " : "parent_id = ?";
		sql += " WHERE category_id = ?";
		
        sql = MessageFormat.format(sql, locale);
		try (Connection connection = DatabaseManager.getConnection();
				PreparedStatement statement = connection.prepareStatement(sql)) {
			if (updateType == 0) {
				statement.setString(1, category.getCategoryName());				
				statement.setString(2, category.getCategoryName());
				statement.setInt(3, category.getCategoryId());				
			} else {
				if (category.getParentId() == 0) {
					statement.setNull(1, java.sql.Types.INTEGER);
				} else {
					statement.setInt(1, category.getParentId());
				}
				statement.setInt(2, category.getCategoryId());
			}
			
			return statement.executeUpdate() > 0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
	}

    public boolean deleteCategory(int categoryId) {
        String deleteMenuCategorySql = """
				DELETE FROM menu_category
				WHERE category_id IN (
				    SELECT category_id FROM category
				    START WITH category_id = ?
				    CONNECT BY PRIOR category_id = parent_id
				)
				""";
        String deleteCategorySql = """
				DELETE FROM category
				WHERE category_id IN (
				    SELECT category_id FROM category
				    START WITH category_id = ?
				    CONNECT BY PRIOR category_id = parent_id
				)
				""";

        try (Connection connection = DatabaseManager.getConnection()) {
            connection.setAutoCommit(false);

            try (PreparedStatement menuCategoryStatement = connection.prepareStatement(deleteMenuCategorySql);
                PreparedStatement categoryStatement = connection.prepareStatement(deleteCategorySql)) {

                menuCategoryStatement.setInt(1, categoryId);
                menuCategoryStatement.executeUpdate();

                categoryStatement.setInt(1, categoryId);
                int affectedRows = categoryStatement.executeUpdate();

                connection.commit();
                return affectedRows > 0;

            } catch (Exception e) {
    			System.out.println(e.getMessage());
    			throw new RuntimeException(e);
    		} finally {
                connection.setAutoCommit(true);
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
    }
}
