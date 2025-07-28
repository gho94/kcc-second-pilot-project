package com.secondproject.cooook.model;

import java.sql.Date;

import lombok.Data;

@Data
public class Menu {
    private int menuId;
    private String menuName;
    private int price;
    private int categoryId;
    private String categoryName;
    private Date createdAt;
}
