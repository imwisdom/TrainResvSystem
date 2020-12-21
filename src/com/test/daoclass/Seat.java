package com.test.daoclass;
import java.sql.*;
import java.util.ArrayList;
public class Seat {

   private String seatNum;
   private int trainRoomNum;
   private String seatState;
   private int trainNum;
   
   public Seat() {
      
   }
   public Seat(String seatNum, int trainRoomNum, String seatState, int trainNum) {
      this.seatNum = seatNum;
      this.trainRoomNum = trainRoomNum;
      this.seatState = seatState;
      this.trainNum = trainNum;
   }
   public Seat(int trainNum) {
      this.seatNum = null;
      this.trainRoomNum = 0;
      this.seatState = null;
      this.trainNum = trainNum;
   }
   
   public static ArrayList<Seat> printSeatForTrainRoomNum(int p_trainNum, int p_trainRoomNum) {
      ArrayList<Seat> seatList = new ArrayList<Seat>();
      Connection conn = null;
      PreparedStatement pstmt = null;
      
      try{
         String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
         String dbId = "root";
         String dbPass = "1234";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
         
         String sql = "select*from se_termp.seat where train_num=? and train_room_num=?";
         pstmt = conn.prepareStatement(sql);
         pstmt.setInt(1, p_trainNum);
         pstmt.setInt(2, p_trainRoomNum);
         
         ResultSet rs = pstmt.executeQuery();

         while (rs.next()) { 
            Seat aSeat = new Seat(rs.getString("num"), rs.getInt("train_room_num"),rs.getString("state"),rs.getInt("train_num"));
            seatList.add(aSeat);    
         }
         
         conn.close();
   
      }catch(Exception e){
         e.printStackTrace();
      }finally{
         if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
         if(conn!=null) try{conn.close();}catch(SQLException sqle){}
      }
      
      return seatList;
   }

   public Seat selectSeat(int p_trainRoomNum, String p_seatNum) {
      Seat aSeat = new Seat(p_seatNum, p_trainRoomNum, "T", this.trainNum);
      Connection conn = null;
      PreparedStatement pstmt = null;
      
      try{
         String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
         String dbId = "root";
         String dbPass = "1234";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
         
         String sql = "update se_termp.seat set state=? where train_num=? and train_room_num=? and num=?";
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, "T");
         pstmt.setInt(2, this.trainNum);
         pstmt.setInt(3, p_trainRoomNum);
         pstmt.setString(4, p_seatNum);
         
         pstmt.executeUpdate();
         conn.close();
         
         return aSeat;
         
      }catch(Exception e){
         e.printStackTrace();
      }finally{
         if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
         if(conn!=null) try{conn.close();}catch(SQLException sqle){}
      }
      return null;
   }
   public static boolean reservationSeat(Seat aSeat) {
      Resv.reservation(aSeat.getTrainNum(), aSeat.getTrainRoomNum(), aSeat.getSeatNum());
      return true;
   }
   public static boolean cancleResvSeat(Seat aSeat) {
      Connection conn = null;
      PreparedStatement pstmt = null;
      
      try{
         String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
         String dbId = "root";
         String dbPass = "1234";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
         
         String sql = "update se_termp.seat set state=? where train_num=? and train_room_num=? and num=?";
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, "F");
         pstmt.setInt(2, aSeat.getTrainNum());
         pstmt.setInt(3, aSeat.getTrainRoomNum());
         pstmt.setString(4, aSeat.getSeatNum());
         
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
   public String getSeatNum() {
      return seatNum;
   }
   public int getTrainRoomNum() {
      return trainRoomNum;
   }
   public String getSeatState() {
      return seatState;
   }
   public int getTrainNum() {
      return trainNum;
   }
   public void setSeatNum(String seatNum) {
      this.seatNum = seatNum;
   }
   public void setTrainRoomNum(int trainRoomNum) {
      this.trainRoomNum = trainRoomNum;
   }
   public void setSeatState(String seatState) {
      this.seatState = seatState;
   }
   public void setTrainNum(int trainNum) {
      this.trainNum = trainNum;
   }
   
   


}