package com.secondproject.cooook.model;

import java.sql.Date;
import java.util.List;

import lombok.Data;

@Data
public class Dashboard {			 
	private Date today;
	private int orderCount;
	private int recipeCount;
	private int menuCount;
	private int categoryCount;
	private List<Menu> menus;
	private String totalEarnings;
}
