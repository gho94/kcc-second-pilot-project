package com.secondproject.cooook.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.secondproject.cooook.db.DatabaseManager;
import com.secondproject.cooook.model.Order;

public class OrderDao {
    private static final String tableName = "orders";

    // 주문 추가
    public void insertOrder(Order order) {
        String sql = "INSERT INTO " + tableName +
                     " (staff_id, menu_id, quantity, total_price, created_at) " +
                     "VALUES (?, ?, ?, ?, sysdate)";
        
        try (Connection connection = DatabaseManager.getConnection();
        	PreparedStatement stmt = connection.prepareStatement(sql)	
        ) {
            stmt.setInt(1, order.getStaffId());
            stmt.setInt(2, order.getMenuId());
            stmt.setInt(3, order.getQuantity());
            stmt.setInt(4, order.getTotalPrice());

            stmt.executeUpdate();
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} 
    }

    // 주문 수정 (null 아닌 필드만)
    public void updateOrder(Order order) {
        Connection con = null;
        PreparedStatement stmt = null;

        try {
            con = DatabaseManager.getConnection();

            List<String> setClauses = new ArrayList<>();
            List<Object> params = new ArrayList<>();

            if (order.getStaffId() != 0) {
                setClauses.add("staff_id = ?");
                params.add(order.getStaffId());
            }
            if (order.getMenuId() != 0) {
                setClauses.add("menu_id = ?");
                params.add(order.getMenuId());
            }
            if (order.getQuantity() != 0) {
                setClauses.add("quantity = ?");
                params.add(order.getQuantity());
            }
            if (order.getTotalPrice() != 0) {
                setClauses.add("total_price = ?");
                params.add(order.getTotalPrice());
            }
            if (order.getCreatedAt() != null) {
                setClauses.add("created_at = ?");
                params.add(new java.sql.Date(order.getCreatedAt().getTime()));
            }

            if (setClauses.isEmpty()) {
                System.out.println("❗ 수정할 항목이 없습니다.");
                return;
            }

            String sql = "UPDATE " + tableName + " SET " + String.join(", ", setClauses) + " WHERE order_id = ?";
            params.add(order.getOrderId());

            stmt = con.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            stmt.executeUpdate();
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			DatabaseManager.close(stmt);
			DatabaseManager.close(con);
        }
    }

    // 논리 삭제
    public int softDeleteOrder(int orderId) {
        Connection con = null;
        PreparedStatement stmt = null;

        try {
            con = DatabaseManager.getConnection();
            String sql = "UPDATE " + tableName + " SET deleted_at = sysdate WHERE order_id = ?";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, orderId);
            return stmt.executeUpdate();
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			DatabaseManager.close(stmt);
			DatabaseManager.close(con);
        }
    }

    // 전체 주문 목록 조회 (deleted_at 제외)
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            con = DatabaseManager.getConnection();
            String sql = "SELECT o.*, s.first_name||s.last_name as staff_name,"
            		+ "	m.menu_name"
            		+ " FROM " + tableName + " o "
            		+ " left join staff s on s.staff_id = o.staff_id"
            		+ " left join menu m on m.menu_id = o.menu_id"
            		+ " WHERE o.deleted_at IS NULL order by o.order_id";
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setStaffId(rs.getInt("staff_id"));
                order.setStaffName(rs.getString("staff_name"));
                order.setMenuId(rs.getInt("menu_id"));
                order.setMenuName(rs.getString("menu_name"));
                order.setQuantity(rs.getInt("quantity"));
                order.setTotalPrice(rs.getInt("total_price"));
                order.setCreatedAt(rs.getDate("created_at"));
                order.setDeletedAt(rs.getDate("deleted_at"));
                list.add(order);
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			DatabaseManager.close(rs);
			DatabaseManager.close(stmt);
            DatabaseManager.close(con);
        }

        return list;
    }
    
    public Order getOrderById(int orderId) {
    	Order order = null;
        String sql = "SELECT * FROM "+tableName+" WHERE order_id = ? and deleted_at is null";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setMenuId(rs.getInt("menu_id"));
                    order.setQuantity(rs.getInt("quantity"));
                    order.setTotalPrice(rs.getInt("total_price"));
                }
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
        
        return order;
    }

}
