package com.secondproject.cooook.model;

import java.sql.Date;

import lombok.Data;

@Data
public class Order {
    private int orderId;
    private int staffId;
    private String staffName;
    private int menuId;
    private String menuName;
    private int quantity;
    private int totalPrice;
    private Date createdAt;
    private Date deletedAt;
}
