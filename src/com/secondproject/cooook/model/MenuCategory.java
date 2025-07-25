package com.secondproject.cooook.model;

import lombok.Data;

@Data
public class MenuCategory {
    private int menuId;
    private int categoryId;
    private String name;
    private String type;
    private int level;    
}