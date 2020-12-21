package com.test.daoclass;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Payment {
	
	public int payNum;
	public int payMethod;
	public Date payDate;
	public int resvNum;
	
	public Payment() {
		
	}
	public Payment(int payNum, int payMethod, Date payDate, int resvNum) {
		this.payNum = payNum;
		this.payMethod = payMethod;
		this.payDate = payDate;
		this.resvNum = resvNum;
	}
	public static void main(String[] args) {
		Payment p = new Payment();
		p.payMethod=1;
		p.buyTicket();
		System.out.println("exit");
	}
	public static ArrayList<Payment> showTicketList(){
		Connection conn = null;
		PreparedStatement pstmt = null;
		String str = "";

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			ArrayList<Train> trainList = Train.printTrainBeforeRide();
			
			for(int i=0;i<trainList.size();i++) {
				System.out.println("번호:"+i);
				String sql = "select p.num, p.method, p.pay_date, p.resv_num, "
						+ "p.user_id from se_termp.payment p, se_termp.resv r where r.train_num="+trainList.get(i).trainNum;
						
				pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery();

				boolean hasNext = rs.next();
				
				if(!hasNext){
					continue;
				}
				else{
					ArrayList<Payment> payList = new ArrayList<Payment>();
					while(hasNext) {
						int curNum = rs.getInt("num");
						int curMethod = rs.getInt("method");
						Date curPayDate = rs.getDate("pay_date");
						int curResvNum = rs.getInt("resv_num");
						
						payList.add(new Payment(curNum, curMethod, curPayDate, curResvNum));
						hasNext = rs.next();
						
					}
					return payList;
				}
			}
			

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		return null;
	}
	public static boolean cancelTicket(int payNum) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String str = "";

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "delete from se_termp.payment where num="+payNum;
			pstmt = conn.prepareStatement(sql);
			int rs = pstmt.executeUpdate();
			
			if(rs==1){
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
	public static ArrayList<Payment> removePayList(ArrayList<Integer> payNumList){
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String str = "";

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			for(int i=0;i<payNumList.size();i++) {
				String sql = "delete from se_termp.payment where num="+payNumList.get(i);
				pstmt = conn.prepareStatement(sql);
				int rs = pstmt.executeUpdate();
			}
			return showPayList();

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		return null;
	}
	public static ArrayList<Payment> showPayList(){
		Connection conn = null;
		PreparedStatement pstmt = null;
		String str = "";

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "select*from se_termp.payment";
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			boolean hasNext = rs.next();
			
			if(!hasNext){
				return null;
			}
			else{
				ArrayList<Payment> trainList = new ArrayList<Payment>();
				while(hasNext) {
					int curNum = rs.getInt("num");
					int curMethod = rs.getInt("method");
					Date curPayDate = rs.getDate("pay_date");
					int curResvNum = rs.getInt("resv_num");
					
					trainList.add(new Payment(curNum, curMethod, curPayDate, curResvNum));
					hasNext = rs.next();
					
				}
				return trainList;
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		return null;
	}
	public boolean buyTicket() {
		//getLatestResv 필요
		Resv curResv = Resv.getLatestResv();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String str = "";
		
		String userId="";

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false&useUnicode=true& useUnicode=true&characterEncoding=euc_kr";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "select*from se_termp.resv where num="+curResv.getResvNum();
			pstmt = conn.prepareStatement(sql);
			
			ResultSet rs = pstmt.executeQuery();
			boolean hasNext = rs.next();
			
			if(hasNext){
				userId =  rs.getString("user_id");
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		
		Connection sqlconn = null;
		pstmt = null;

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			sqlconn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "insert into se_termp.payment (method, pay_date, resv_num, user_id) values("+this.payMethod+",curdate(),"+curResv.getResvNum()+",'"+userId+"')";
			pstmt = sqlconn.prepareStatement(sql);
			int r = pstmt.executeUpdate();
			
			return true;

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(sqlconn!=null) try{sqlconn.close();}catch(SQLException sqle){}
		}
		return false;
	}
	public static int[] calculateRecommendTrain() {
		//추천기능 구현할때 구현할 것
	      int result[] = { 0, 0 ,};
	      ArrayList<int[]> timeArr = new ArrayList<int[]>();
	      HashMap<Integer, Integer> frequency = new HashMap<>();
	      int max = 0;
	      Connection conn = null;
	      PreparedStatement pstmt = null;

	      try {
	         String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false&useUnicode=true&characterEncoding=euc_kr";
	         String dbId = "root";
	         String dbPass = "1234";
	         Class.forName("com.mysql.cj.jdbc.Driver");
	         conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);

	         String sql = "SELECT * FROM se_termp.tmpDB";
	         pstmt = conn.prepareStatement(sql);

	         ResultSet rs = pstmt.executeQuery();

	         while (rs.next()) {
	            int[] arr = {rs.getTime("start_time").getHours(),rs.getTime("start_time").getMinutes()};
	            timeArr.add(arr);
	         }

	      }catch(Exception e){
	            e.printStackTrace();
	         }finally{
	            if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
	            if(conn!=null) try{conn.close();}catch(SQLException sqle){}
	         }
	      // 시간에 대해서 빈도수 체크
	      for (int i = 0; i < timeArr.size(); i++) {
	         if (frequency.containsKey(timeArr.get(i)[0])) {
	            frequency.put(timeArr.get(i)[0], frequency.get(timeArr.get(i)[0]) + 1);
	         } else {
	            frequency.put(timeArr.get(i)[0], 1);
	         }
	      }
	      
	      for (Map.Entry<Integer, Integer> entry : frequency.entrySet()) {
	         if (entry.getValue().compareTo(max) >= 0) {
	            max = entry.getValue();
	            result[0] = entry.getKey();
	         }
	      }
	      return result;
	}

}
