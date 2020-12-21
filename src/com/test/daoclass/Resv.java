package com.test.daoclass;
import java.sql.*;
import java.util.ArrayList;
public class Resv {

   private int resvNum;
   private int trainNum;
   private int trainRoomNum;
   private String seatNum;
   
   public Resv() {
      this.resvNum = 0;
      this.trainNum = 0;
      this.trainRoomNum = 0;
      this.seatNum = null;
   }
   public Resv(int resvNum, int trainNum, int trainRoomNum, String seatNum) {
      this.resvNum = resvNum;
      this.trainNum = trainNum;
      this.trainRoomNum = trainRoomNum;
      this.seatNum = seatNum;
   }
   
   public static ArrayList<Resv> showResvList(int p_trainNUm) {
      ArrayList<Resv> resvList = new ArrayList<Resv>();
      return resvList;
   }
   @SuppressWarnings({ "null" })
   public static boolean reservation(int trainNum, int trainRoomNum, String seatNUm) {
      Connection conn = null;
      PreparedStatement pstmt = null;
      
      int count = 0;
      ResultSet rs = null;
      
      
      try {
         String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
         String dbId = "root";
         String dbPass = "1234";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
         Statement state = conn.createStatement();
         
         String selectSql = "select count(*) from se_termp.resv";
         rs = state.executeQuery(selectSql);
         if(rs.next()) {
            count = rs.getInt(1);
            System.out.println("## count = "+count);
         }
      } catch (SQLException e) {
         e.printStackTrace();
      } catch (ClassNotFoundException e) {
         e.printStackTrace();
      }
      
      try{
         String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
         String dbId = "root";
         String dbPass = "1234";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
      
         String sql = "insert into se_termp.resv (num, train_num, train_room_num, seat_num) values(?,?,?,?)";
         pstmt = conn.prepareStatement(sql);
         System.out.println("cur count?"+count);
         pstmt.setInt(1, count+1);
         pstmt.setInt(2, trainNum);
         pstmt.setInt(3, trainRoomNum);
         pstmt.setString(4, seatNUm);
         
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
   public static boolean cancleResvList(Resv p_resv) {
      Connection conn = null;
      PreparedStatement pstmt = null;
      
      try{
         String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
         String dbId = "root";
         String dbPass = "1234";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
         
         String sql = "delete from se_termp.resv where num=?";
         pstmt = conn.prepareStatement(sql);
         pstmt.setInt(1, p_resv.getResvNum());
         
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
   public static Resv getLatestResv() {
      Resv resv = new Resv();
      
      Connection conn = null;
      PreparedStatement pstmt = null;

      try{
         String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
         String dbId = "root";
         String dbPass = "1234";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
         
         String sql = "SELECT * FROM se_termp.resv WHERE num=(SELECT MAX(num) FROM se_termp.resv)";
         pstmt = conn.prepareStatement(sql);
         
         ResultSet rs = pstmt.executeQuery();
         boolean hasNext = rs.next();
         
         if(hasNext){
            resv.setResvNum(rs.getInt("num"));
            resv.setTrainNum(rs.getInt("train_num"));
            resv.setTrainRoomNum(rs.getInt("train_room_num"));
            resv.setSeatNum(rs.getString("seat_num"));
            
            return resv;
         }
         else{
            return null;
         }
   
      }catch(Exception e){
         e.printStackTrace();
      }finally{
         if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
         if(conn!=null) try{conn.close();}catch(SQLException sqle){}
      }
      
      return null;
   }
   
   public int getResvNum() {
      return resvNum;
   }

   public int getTrainNum() {
      return trainNum;
   }

   public int getTrainRoomNum() {
      return trainRoomNum;
   }

   public String getSeatNum() {
      return seatNum;
   }

   public void setResvNum(int resvNum) {
      this.resvNum = resvNum;
   }

   public void setTrainNum(int trainNum) {
      this.trainNum = trainNum;
   }

   public void setTrainRoomNum(int trainRoomNum) {
      this.trainRoomNum = trainRoomNum;
   }

   public void setSeatNum(String seatNum) {
      this.seatNum = seatNum;
   }
   
   
}