package com.test.daoclass;
import java.sql.*;
import java.util.ArrayList;
public class test {

	public static void main(String args[]) {
		table();
	}
	public static void table() {
		
		int train_num = 4;
		
		for(int o=69;o<1785;o++) {
			for(int i=0;i<15;i++) {
				for(int j=0;j<4;j++) {
					for(int k=1;k<10;k++) {
						
						int num = 65+j;
						String a = String.valueOf((char)num);
						String seatNum = k + a;
						System.out.println(seatNum);
						
						Connection conn = null;
						PreparedStatement pstmt = null;
						
						try{
							String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
							String dbId = "root";
							String dbPass = "1234";
							Class.forName("com.mysql.cj.jdbc.Driver");
							conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
							
							String sql = "insert into se_termp.seat values(?,?,?,?)";
							
							 pstmt = conn.prepareStatement(sql); 
							 pstmt.setString(1, seatNum);
							 pstmt.setInt(2, i+1); 
							 pstmt.setString(3, "F"); 
							 pstmt.setInt(4,o+1);
							 
							 pstmt.executeUpdate();
							 
							conn.close();
							
						}catch(Exception e){
							e.printStackTrace();
						}finally{
							if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
							if(conn!=null) try{conn.close();}catch(SQLException sqle){}
						}
						
					}
				}
			}
		}
		
		
		return;
	}


}
