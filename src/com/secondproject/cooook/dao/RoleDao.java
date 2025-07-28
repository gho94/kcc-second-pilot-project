package com.secondproject.cooook.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import com.secondproject.cooook.db.DatabaseManager;
import com.secondproject.cooook.model.Role;

public class RoleDao {

	private static final String tableName = "roles";
    private static final String subTableName = "role_feature";

    // 역할 전체 조회
    public List<Role> getAllRoles() {
        List<Role> roleList = new ArrayList<>();

        String sql = """
        			SELECT
        				r.role_id, r.role_name, r.description,
        				LISTAGG(f.feature_code, ''', ''') WITHIN GROUP (ORDER BY f.feature_code) AS features
        			FROM {0} r
        			LEFT OUTER JOIN role_feature f ON f.role_id = r.role_id
        			WHERE r.deleted_at IS NULL
        			GROUP BY r.role_id, r.role_name, r.description
        			ORDER BY r.role_id
        		""";
        
        sql = MessageFormat.format(sql, tableName);

        try (Connection connection = DatabaseManager.getConnection();
        	PreparedStatement stmt = connection.prepareStatement(sql)
        ) {
        	ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
                role.setFeatureCodes(rs.getString("features"));
                roleList.add(role);
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
        return roleList;
    }
    

    // 역할 전체 조회
    public Role getRoleByRoleId(int roleId) {
        Role role = new Role();

        String sql = """
        			SELECT
        				r.role_id, r.role_name, r.description,
        				LISTAGG(f.feature_code, ''', ''') WITHIN GROUP (ORDER BY f.feature_code) AS features
        			FROM {0} r
        			LEFT OUTER JOIN role_feature f ON f.role_id = r.role_id
        			WHERE r.deleted_at IS NULL
        			AND r.role_id = ?
        			GROUP BY r.role_id, r.role_name, r.description
        			ORDER BY r.role_id
        		""";
        
        sql = MessageFormat.format(sql, tableName);

        try (Connection connection = DatabaseManager.getConnection();
        	PreparedStatement stmt = connection.prepareStatement(sql)
        ) {
        	stmt.setInt(1, roleId);
        	
        	ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
                role.setFeatureCodes(rs.getString("features"));
                
                return role;
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
        return role;
    }
    
    
    // 역할 추가
    public void insertRole(Connection con, Role role) {
        PreparedStatement stmt = null;
        try {
            String sql = "INSERT INTO " + tableName + " (role_name, description) VALUES (?, ?)";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, role.getRoleName());
            stmt.setString(2, role.getDescription());
            stmt.executeUpdate();
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}  finally {
			DatabaseManager.close(stmt);
        }
    }
    
    public void insertRole(Role role, List<String> featureCodes) {
		String sql = """
					INSERT INTO {0} (
						role_id, role_name, description
					) VALUES (
						ROLE_SEQ.NEXTVAL, ?, ?
					)					
				""";
        sql = MessageFormat.format(sql, tableName);

		String sql2 = """
					INSERT INTO {0} (
						role_id, feature_code, display_order
					) VALUES (
						?, ?, ?
					)
				""";

        sql2 = MessageFormat.format(sql2, subTableName);
        
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet generatedKeys = null;
        
        try {
			connection = DatabaseManager.getConnection();
			connection.setAutoCommit(false);
			
			statement = connection.prepareStatement(sql, new String[] {"role_id"});
			statement.setString(1, role.getRoleName());
			statement.setString(2, role.getDescription());
			
			statement.executeUpdate();
			
	        generatedKeys = statement.getGeneratedKeys();
	        
	        int newRoleId = 0;
	        if (generatedKeys.next()) {
	        	newRoleId = generatedKeys.getInt(1);
	        }
	        
	        statement = connection.prepareStatement(sql2);
	        int index = 1;
	        for (String featureCode : featureCodes) {
	        	statement.setInt(1, newRoleId);
	        	statement.setString(2, featureCode);
	        	statement.setInt(3, index++);
	        	statement.addBatch();
			}
	        
	        statement.executeBatch();
	        connection.commit();
		} catch (Exception e) {
			try {
				connection.rollback();
			} catch (SQLException e1) {
				System.out.println(e.getMessage());
				throw new RuntimeException(e);
			}
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException e) {
				System.out.println(e.getMessage());
				throw new RuntimeException(e);
			}
			DatabaseManager.close(generatedKeys);
			DatabaseManager.close(statement);
			DatabaseManager.close(connection);			
		}
	}

    // 역할 수정
    public void updateRole(Connection con, Role role) {
        PreparedStatement stmt = null;
        try {
            List<String> setClauses = new ArrayList<>();
			List<Object> params = new ArrayList<>();
			
			String roleName = role.getRoleName();
			String description = role.getDescription();
			
			if(roleName != null) {
				setClauses.add("role_name = ?");
				params.add(roleName);
			}
			
			if(description != null) {
				setClauses.add("description = ?");
				params.add(description);
			}
			
			if (setClauses.isEmpty()) {
	            System.out.println("❗ 수정할 항목이 없습니다.");
	            return;
            }
			
			String sql = "UPDATE " + tableName + " SET " + String.join(", ", setClauses) + " WHERE role_id = ?";
			params.add(role.getRoleId());
			
			stmt = con.prepareStatement(sql);
		    for (int i = 0; i < params.size(); i++) {
		        stmt.setObject(i + 1, params.get(i));
		    }

			stmt.executeUpdate();
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}  finally {
			DatabaseManager.close(stmt);
        }
    }
    
    public void updateRole(Role role, List<String> featureCodes) {
		String sql = """
					UPDATE {0} 
					SET role_name = ?,
						description = ?
					WHERE role_id = ?
				""";
		sql = MessageFormat.format(sql, tableName);
		
		String sql2 = """
					DELETE FROM {0}
					WHERE role_id = ?
				""";
		sql2 = MessageFormat.format(sql2, subTableName);

		String sql3 = """
					INSERT INTO {0} (
						role_id, feature_code, display_order
					) VALUES (
						?, ?, ?
					)
				""";

		sql3 = MessageFormat.format(sql3, subTableName);
        
        
        Connection connection = null;
        PreparedStatement statement = null;
        
        try {
			connection = DatabaseManager.getConnection();
			connection.setAutoCommit(false);
				
			statement = connection.prepareStatement(sql);
			statement.setString(1, role.getRoleName());
			statement.setString(2, role.getDescription());
			statement.setInt(3, role.getRoleId());
			
			statement.executeUpdate();
			
			statement = connection.prepareStatement(sql2);
			statement.setInt(1, role.getRoleId());
			
			statement.executeUpdate();

	        statement = connection.prepareStatement(sql3);
	        
	        int index = 1;
	        for (String featureCode : featureCodes) {
	        	statement.setInt(1, role.getRoleId());
	        	statement.setString(2, featureCode);
	        	statement.setInt(3, index);
	        	statement.addBatch();
			}
	        statement.executeBatch();
	        
	        connection.commit();			
		} catch (Exception e) {
			try {
				connection.rollback();
			} catch (SQLException e1) {
				System.out.println(e.getMessage());
				throw new RuntimeException(e);
			}
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException e) {
				System.out.println(e.getMessage());
				throw new RuntimeException(e);
			}
			DatabaseManager.close(statement);
			DatabaseManager.close(connection);			
		}
	}

    public int softDeleteRole(int roleId) {
        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = DatabaseManager.getConnection();
            String sql = "UPDATE "+tableName+" SET deleted_at = sysdate WHERE role_id = ?";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, roleId);
            return stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
        	DatabaseManager.close(stmt);
        	DatabaseManager.close(con);
        }
    }
    
    public int deleteRoleFeature(Connection con, int roleId) {
        PreparedStatement stmt = null;
        try {
            String sql = "DELETE FROM " + subTableName + " WHERE role_id = ?";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, roleId);
            return stmt.executeUpdate(); // 삭제된 행 수 반환
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}  finally {
			DatabaseManager.close(stmt);
        }
    }


    public Role getRoleById(int roleId) {
        Role role = null;
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            con = DatabaseManager.getConnection();
            String sql = "SELECT role_id, role_name, description FROM roles WHERE role_id = ? order by role_id";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, roleId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			DatabaseManager.close(rs);
			DatabaseManager.close(stmt);
			DatabaseManager.close(con);
        }
        return role;
    }
    
    
    public List<String> getFeaturesByRoleId(int roleId) {
        List<String> features = new ArrayList<>();
        String sql = "SELECT feature_code FROM "+subTableName+" WHERE role_id = ? order by display_order";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, roleId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    features.add(rs.getString("feature_code"));
                }
            }

        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} 

        return features;
    }
    
    public void insertRoleFeature(Connection con, int role_id, String feature_code, int display_order) {
        PreparedStatement stmt = null;
        try {
            String sql = "INSERT INTO " + subTableName + " (feature_code, display_order, role_id) VALUES (?, ?, ?)";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, feature_code);
            stmt.setInt(2, display_order);
            stmt.setInt(3, role_id);
            stmt.executeUpdate();
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		} finally {
			DatabaseManager.close(stmt);
        }
    }
    
    public int selectNextRoleSeq() {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            con = DatabaseManager.getConnection();
            String sql = "SELECT max(role_id)+1 FROM roles";
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                throw new RuntimeException("시퀀스 NEXTVAL을 가져오지 못했습니다.");
            }
        } catch (Exception e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}  finally {
			DatabaseManager.close(rs);
			DatabaseManager.close(stmt);
			DatabaseManager.close(con);
        }
    }


}
