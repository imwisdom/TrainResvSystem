package com.test.daoclass;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;

import javax.swing.JOptionPane;
import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;

//import com.test.parsing.*;

public class Train {

	public int trainNum;
	public String trainType;
	public Time startTime;
	public Time endTime;
	public Time leadTime;
	public String startStation;
	public String endStation;
	public int price;
	public Date date;
	
	public Train(int trainNum, String trainType, Time startTime, Time endTime, 
			Time leadTime, String startStation, String endStation, int price, Date date) {
		this.trainNum = trainNum;
		this.trainType = trainType;
		this.startTime = startTime;
		this.endTime = endTime;
		this.leadTime = leadTime;
		this.startStation = startStation;
		this.endStation = endStation;
		this.price = price;
		this.date = date;
	}
//	public static void main(String[] args) throws IOException, SAXException, ParserConfigurationException, ParseException {
//		java.util.Date arrDate = new SimpleDateFormat("yyyyMMdd").parse("20191210");
//		Date date = new Date(arrDate.getTime());
//		
//		Time time = ParsingTrain.stringToTime("152000");
//		
//		ArrayList<Train> at = printSortedTrain("대전", "서울", date, time, 1);
//		System.out.println(at);
//	}
	 public static boolean recommendTrain(boolean on) {
	      if (on == false) return false;
	      return true;
	   }

	   public static ArrayList<Train> getRecommendedTrain(int[] time) {
	      int[] result = time; // == time
	      Time time1 = new Time(result[0], result[1], 0);
	      Time time2 = new Time(result[0]+1, result[1], 0);

	      ArrayList<Train> recoList = new ArrayList<Train>();
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      String str = "";

	      try {
	         String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false&useUnicode=true&characterEncoding=euc_kr";
	         String dbId = "root";
	         String dbPass = "1234";
	         Class.forName("com.mysql.cj.jdbc.Driver");
	         conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);

	         String sql = "select*from se_termp.train where start_time>=? and start_time<?";

	         pstmt = conn.prepareStatement(sql);
	         pstmt.setTime(1, (Time) time1);
	         pstmt.setTime(2, (Time) time2);
	         ResultSet rs = pstmt.executeQuery();

	         while (rs.next()) {
	            Train aTrain = new Train(rs.getInt("num"), rs.getString("t_type"), rs.getTime("start_time"),
	                  rs.getTime("end_time"), rs.getTime("lead_time"), rs.getString("start_station"),
	                  rs.getString("end_station"), rs.getInt("price"), rs.getDate("t_date"));
	            recoList.add(aTrain);
	         }

	         return recoList;

	      }catch(Exception e){
	            e.printStackTrace();
	         }finally{
	            if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
	            if(conn!=null) try{conn.close();}catch(SQLException sqle){}
	         }
	      return null;
	   }


	public static boolean selectTrainCondition(String startStation, String endStation, Date date, Time startTime) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String str = "";

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "select*from se_termp.train where start_time>=? and start_station=? and end_station=? and t_date=? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setTime(1, startTime);
			pstmt.setString(2, startStation);
			pstmt.setString(3, endStation);
			pstmt.setDate(4, date);
			System.out.println(startTime+", "+startStation+", "+endStation+", "+date);
			
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
	public static ArrayList<Train> printSortedTrain(String startStation, String endStation, Date date, Time startTime, int sortType) throws IOException, SAXException, ParserConfigurationException {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String str = "";

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "select*from se_termp.train where start_time>=? and start_station=? and end_station=? and t_date=? ";
			if(sortType == 0)
				sql = sql+"order by start_time";
			else
				sql = sql+"order by end_time";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setTime(1, startTime);
			pstmt.setString(2, startStation);
			pstmt.setString(3, endStation);
			pstmt.setDate(4, date);
			System.out.println(startTime+", "+startStation+", "+endStation+", "+date);
			
			ResultSet rs = pstmt.executeQuery();

			boolean hasNext = rs.next();
			
			if(!hasNext){
				return null;
			}
			else{
				ArrayList<Train> trainList = new ArrayList<Train>();
				while(hasNext) {
					int num = rs.getInt("num");
					String trainType = rs.getString("t_type");
					Time sTime = rs.getTime("start_time");
					Time eTime = rs.getTime("end_time");
					Time leadTime = rs.getTime("lead_time");
					String sStation = rs.getString("start_station");
					String eStation = rs.getString("end_station");
					int price = rs.getInt("price");
					Date tDate = rs.getDate("t_date");
					
					trainList.add(new Train(
							num, trainType, sTime, eTime, leadTime, sStation,
							eStation, price, tDate));
					
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
	public static ArrayList<Train> printTrainBeforeRide(){
		Connection conn = null;
		PreparedStatement pstmt = null;
		String str = "";

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "select*from train where t_date>curdate() or (t_date= curdate() and start_time>=now())";
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			boolean hasNext = rs.next();
			
			if(!hasNext){
				return null;
			}
			else{
				ArrayList<Train> trainList = new ArrayList<Train>();
				while(hasNext) {
					int num = rs.getInt("num");
					String trainType = rs.getString("t_type");
					Time sTime = rs.getTime("start_time");
					Time eTime = rs.getTime("end_time");
					Time leadTime = rs.getTime("lead_time");
					String sStation = rs.getString("start_station");
					String eStation = rs.getString("end_station");
					int price = rs.getInt("price");
					Date tDate = rs.getDate("t_date");
					
					trainList.add(new Train(
							num, trainType, sTime, eTime, leadTime, sStation,
							eStation, price, tDate));
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
	
}
