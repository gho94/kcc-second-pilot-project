package com.secondproject.cooook.common;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.apache.tomcat.jdbc.pool.DataSource;

public class DatabaseManager {
	static DataSource dataSource;

	static {
		try {
			Context context = new InitialContext();
			dataSource = (DataSource)context.lookup("java:comp/env/jdbc/Oracle");
		}catch(NamingException e) {
			e.printStackTrace();
		}
	}

	public static Connection getConnection() {
		Connection connection = null;
		try {
			connection = dataSource.getConnection();
		} catch (SQLException e) {
			System.out.println(e.getMessage());
			throw new RuntimeException(e);
		}
		return connection;
	}
	


    // 리소스 닫기 - 오버로딩
    public static void close(Connection con) {
        try {
            if (con != null) con.close();
        } catch (SQLException e) {
            // 무시
        }
    }

    public static void close(PreparedStatement ps) {
        try {
            if (ps != null) ps.close();
        } catch (SQLException e) {
            // 무시
        }
    }

    public static void close(ResultSet rs) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            // 무시
        }
    }

    // 한 번에 다 닫는 메서드
    public static void close(Connection con, PreparedStatement ps, ResultSet rs) {
        close(rs);
        close(ps);
        close(con);
    }
    
    public static void rollback(Connection con) {
        if (con != null) {
            try {
                con.rollback();
            } catch (SQLException e) {
                System.err.println("롤백 실패: " + e.getMessage());
            }
        }
    }

    
    public static void setAutoCommitTrue(Connection con) {
        if (con != null) {
            try {
                con.setAutoCommit(true);
            } catch (SQLException e) {
                System.err.println("AutoCommit 복원 실패: " + e.getMessage());
            }
        }
    }

}
