package com.secondproject.cooook.model;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class Category {
	private int categoryId;
	private String categoryName;
	private Integer parentId;
	private List<Category> child = new ArrayList<>();
	private int level;
}
