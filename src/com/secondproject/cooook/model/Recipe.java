package com.secondproject.cooook.model;

import lombok.Data;

@Data
public class Recipe {
	private int recipeId;
	private int menuId;
	private String categoryName;
	private int categoryId;
	private double quantity;
	private String menuName;
	private String unit;         // "g"
	private String description;  // "국산 돼지고기"
	private String ingredientName; // JOIN된 CATEGORY_NAME (출력용)
	private int ingredientId; // JOIN된 CATEGORY_NAME (출력용)

}
