package com.secondproject.cooook.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.secondproject.cooook.db.DatabaseManager;
import com.secondproject.cooook.model.Staff;
import com.secondproject.cooook.util.PasswordUtil;

public class StaffDao {


	private static final String tableName = "staff";
	
	public void insertStaff(Staff staff) {
		Connection con = null;
		try {
			con = DatabaseManager.getConnection();
			String sql = 
					"insert"
					+ " into "+tableName
					+ " (first_name, last_name, email, password, phone, role_id)"
					+ " VALUES (?, ?, ?, ?, ?, ?)";
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, staff.getFirstName());
			stmt.setString(2, staff.getLastName());
			stmt.setString(3, staff.getEmail());
			stmt.setString(4, staff.getPassword());
			stmt.setString(5, staff.getPhone());
			stmt.setInt(6, staff.getRoleId());
			stmt.executeUpdate();
		}catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			DatabaseManager.close(con);
		}
				
	}
	
	public void updateStaff(Staff staff) {
		Connection con = null;
		PreparedStatement stmt = null;
		try {
			con = DatabaseManager.getConnection();
			
			 
			List<String> setClauses = new ArrayList<>();
			List<Object> params = new ArrayList<>();
			
			String firstName = staff.getFirstName();
			String lastName = staff.getLastName();
			String email = staff.getEmail();
			String password = staff.getPassword();
			String phone = staff.getPhone();
			int roleId = staff.getRoleId();
			
			
			if(firstName != null) {
				setClauses.add("first_name = ?");
				params.add(firstName);
			}
		
			
			if(lastName != null) {
				setClauses.add("last_name = ?");
				params.add(lastName);
			}
			
			if(email != null) {
				setClauses.add("email = ?");
				params.add(email);
			}
			
			if (password != null) {
			    setClauses.add("password = ?");
			    params.add(password);
			}
			
			if (phone != null) {
			    setClauses.add("phone = ?");
			    params.add(phone);
			}
			
			if (roleId != 0) {
			    setClauses.add("role_id = ?");
			    params.add(roleId);
			}
			
			if (setClauses.isEmpty()) {
	            System.out.println("❗ 수정할 항목이 없습니다.");
	            return;
	        }
			
			String sql = "UPDATE " + tableName + " SET " + String.join(", ", setClauses) + " WHERE staff_id = ?";
		    params.add(staff.getStaffId());

		    stmt = con.prepareStatement(sql);

		        
		    for (int i = 0; i < params.size(); i++) {
		        stmt.setObject(i + 1, params.get(i));
		    }

			stmt.executeUpdate();
		}catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			DatabaseManager.close(con);
		}
	}
	
	
	public int softDeleteStaff(int staffId) {
		Connection con = null;
		PreparedStatement stmt = null;
		try {
			con = DatabaseManager.getConnection();
			String sql = "UPDATE "+tableName+" SET deleted_at = sysdate WHERE staff_id = ?";
			stmt = con.prepareStatement(sql);
			stmt.setInt(1, staffId);
		    return stmt.executeUpdate();
		}catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			DatabaseManager.close(con);
		}
	}
	
	public List<Staff> getStaffAll() {
		List<Staff> staffList = new ArrayList<>();
		Connection con = null;
		try {
			con = DatabaseManager.getConnection();
			String sql = "SELECT s.staff_id 		AS staffId,"
					   + "       s.first_name 	AS firstName,"
					   + "       s.last_name 		AS lastName,"
					   + "       s.email 			AS email,"
					   + "       s.phone 			AS phone,"
					   + "       s.role_id 		AS roleId,"
					   + "       r.role_name 		AS roleName,"
					   + "       s.created_at 	AS createdAt "
					   + " from "+tableName+" s left join roles r on r.role_id = s.role_id "
					   + " where s.deleted_at is null order by s.staff_id";
			PreparedStatement stmt = con.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while(rs.next()) {
				Staff staff = new Staff();
				staff.setStaffId(rs.getInt("staffId"));
				staff.setFirstName(rs.getString("firstName"));
				staff.setLastName(rs.getString("lastName"));
				staff.setEmail(rs.getString("email"));
				staff.setPhone(rs.getString("phone"));
				staff.setRoleId(rs.getInt("roleId"));
				staff.setRoleName(rs.getString("roleName"));
				staff.setCreatedAt(rs.getDate("createdAt"));
				staffList.add(staff);
			}
		}catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			DatabaseManager.close(con);
		}
		return staffList;
	}
	

	public Staff getStaffByStaffId(int staffId) {
		Staff staff = null;
		Connection con = null;
		try {
			con = DatabaseManager.getConnection();
			String sql = "SELECT s.staff_id 		AS staffId,"
					   + "       s.first_name 	AS firstName,"
					   + "       s.last_name 		AS lastName,"
					   + "       s.email 			AS email,"
					   + "       s.phone 			AS phone,"
					   + "       s.role_id 		AS roleId,"
					   + "       r.role_name 		AS roleName,"
					   + "       s.created_at 	AS createdAt "
					   + " from "+tableName+" s left join roles r on r.role_id = s.role_id "
					   + " where s.deleted_at is null"
					   + " AND s.staff_id = ? "
					   + " order by s.staff_id";
			PreparedStatement stmt = con.prepareStatement(sql);
			
            stmt.setInt(1, staffId);
            
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				staff = new Staff();
				staff.setStaffId(rs.getInt("staffId"));
				staff.setFirstName(rs.getString("firstName"));
				staff.setLastName(rs.getString("lastName"));
				staff.setEmail(rs.getString("email"));
				staff.setPhone(rs.getString("phone"));
				staff.setRoleId(rs.getInt("roleId"));
				staff.setRoleName(rs.getString("roleName"));
				staff.setCreatedAt(rs.getDate("createdAt"));
			}
		}catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			DatabaseManager.close(con);
		}
		return staff;
	}
	
	
	public Staff login(String email, String inputPw) {
	    Connection con = null;
	    PreparedStatement stmt = null;
	    ResultSet rs = null;
	    Staff staff = null;

	    try {
	        con = DatabaseManager.getConnection();
			String sql = "SELECT s.staff_id 		AS staffId,"
					   + "       s.first_name 	AS firstName,"
					   + "       s.last_name 		AS lastName,"
					   + "       s.email 			AS email,"
					   + "       s.phone 			AS phone,"
					   + "       s.role_id 		AS roleId,"
					   + "       r.role_name 		AS roleName,"
					   + "       s.created_at 	AS createdAt "
					   + " from "+tableName+" s left join roles r on r.role_id = s.role_id "
					   + " WHERE email = ? AND password = ? order by staff_id";
	        stmt = con.prepareStatement(sql);
	        stmt.setString(1, email);
	        stmt.setString(2, PasswordUtil.hashPassword(inputPw)); // 입력 비밀번호를 해시해서 비교

	        rs = stmt.executeQuery();

	        if (rs.next()) {
	            staff = new Staff();
	    		staff.setStaffId(rs.getInt("staffId"));
				staff.setFirstName(rs.getString("firstName"));
				staff.setLastName(rs.getString("lastName"));
				staff.setEmail(rs.getString("email"));
				staff.setPhone(rs.getString("phone"));
				staff.setRoleId(rs.getInt("roleId"));
				staff.setRoleName(rs.getString("roleName"));
				staff.setCreatedAt(rs.getDate("createdAt"));
	        }
	        
	    } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			DatabaseManager.close(rs);
			DatabaseManager.close(stmt);
			DatabaseManager.close(con);
	    }

	    return staff;
	}
	
	public int selectEmailCount(String email) {
	    Connection con = null;
	    PreparedStatement stmt = null;
	    ResultSet rs = null;
	    try {
	    		con = DatabaseManager.getConnection();
	    		String sql = "SELECT COUNT(*) FROM staff WHERE email = ?";
	    		stmt = con.prepareStatement(sql);

	    		stmt.setString(1, email);
	    		rs = stmt.executeQuery();
	    		rs.next();
	    		return rs.getInt(1);

	    } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} 
	}

}
