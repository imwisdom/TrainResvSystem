package com.test.daoclass;
import javax.swing.JOptionPane;
import java.sql.*;
public class Member {

	public String id;
	public String pw;
	public String rrNum;
	public String phoneNum;
	
	public Member() {
		
	}
	public Member(String id, String pw, String rrNum, String phoneNum) {
		this.id = id;
		this.pw = pw;
		this.rrNum = rrNum;
		this.phoneNum = phoneNum;
	}
	public Member(String id) {
		this.id = id;
		
		Connection conn = null;
		PreparedStatement pstmt = null;

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "select*from se_termp.member where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, this.id);
			
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) { 
				this.pw = rs.getString("pw"); 
				this.rrNum = rs.getString("rr_Num"); 
				this.phoneNum = rs.getString("phone"); 	
			}

			conn.close();
	
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}

	}
	public static boolean idExist(String id) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "select*from se_termp.member where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			
			ResultSet rs = pstmt.executeQuery();

			boolean hasNext = rs.next();
			
			if(!hasNext){
				return false;
			}
			else{
					
				return true;
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		return false;
	}
	public static boolean join(String id, String pw, String rrNum, String phoneNum) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "insert into se_termp.member values(?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			pstmt.setString(3, rrNum);
			pstmt.setString(4, phoneNum);
			
			pstmt.executeUpdate();
			return true;
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		return false;
	}
	public boolean changeInfo(String p_pw, String p_phoneNum) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "update se_termp.member set pw=?, phone=? where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, p_pw);
			pstmt.setString(2, p_phoneNum);
			pstmt.setString(3, getId());
			
			pstmt.executeUpdate();
			conn.close();
			
			setPw(p_pw);
			setPhoneNum(p_phoneNum);
			
			return true;

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		return false;
	}
	public boolean removeInfo() {
		
		Connection conn = null;
		PreparedStatement pstmt = null;

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql =  "delete from se_termp.member where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, getId());
			
			pstmt.executeUpdate();
			conn.close();
			
			return true;

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		return false;
	}
	@SuppressWarnings("resource")
	public static boolean login(String id, String pw) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "select*from se_termp.member where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			
			ResultSet rs = pstmt.executeQuery();

			boolean hasNext = rs.next();
			if(id.equals("") || pw.equals("")){
				JOptionPane.showMessageDialog(null, "입력하지 않은 정보가 있습니다.");
			}
			else{
				if(!hasNext){
					JOptionPane.showMessageDialog(null, "아이디를 다시 입력하십시오.");
				}
				else{
					sql = "select*from se_termp.member where id=? and pw=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, id);
					pstmt.setString(2, pw);
					
					rs = pstmt.executeQuery();

					hasNext = rs.next();
					
					if(!hasNext){
						JOptionPane.showMessageDialog(null, "비밀번호를 다시 입력하십시오.");
						
						
					}
					else{
						return true;
					}
				}
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		return false;
	}
	
	public String getId() {
		return this.id;
	}
	public String getPw() {
		return this.pw;
	}
	public String getRrNum() {
		return this.rrNum;
	}
	public String getPhoneNum() {
		return this.phoneNum;
	}
	public void setId(String id) {
		this.id = id;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public void setRrNum(String rrNum) {
		this.rrNum = rrNum;
	}
	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}
	

}
