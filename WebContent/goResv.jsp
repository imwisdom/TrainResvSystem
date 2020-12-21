<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="com.test.daoclass.*"%>
<%@ page import="java.sql.*" %>

<%
Member member = (Member)session.getAttribute("member");

Seat seat = (Seat)session.getAttribute("seat");

int roomNum = Integer.parseInt(request.getParameter("roomNum"));
String seatNum = request.getParameter("seatNum");
boolean successResv = false;

System.out.println("## goResv :: "+roomNum +" "+seatNum);

Seat aSeat = seat.selectSeat(roomNum, seatNum);
if(Seat.reservationSeat(aSeat)){
	System.out.println("room : "+roomNum+", seatNum: "+seatNum);
	session.setAttribute("seat", aSeat); 
	successResv = true;
	
	Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=UTC&useSSL=false";
        String dbId = "root";
        String dbPass = "1234";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
        Statement state = conn.createStatement();
        
        String selectSql = "select count(*) from se_termp.resv";
        ResultSet rs = state.executeQuery(selectSql);
        
        int count = 0;
        if(rs.next()) {
           count = rs.getInt(1);
           System.out.println("cout:"+count);
           
        }
        String sql = "update se_termp.resv set user_id=? where num=?";
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, member.id);
		pstmt.setInt(2, count);
        
        int r = pstmt.executeUpdate();
        conn.close();
        System.out.println("update user id");
        
        
     } catch (SQLException e) {
        e.printStackTrace();
     } catch (ClassNotFoundException e) {
        e.printStackTrace();
     }
}
%>
<%= successResv%>