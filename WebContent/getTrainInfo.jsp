<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="com.test.daoclass.*"%>
<%@ page import="java.sql.*" %>
<%
	boolean success = false;
	int trainNum = Integer.parseInt((String)session.getAttribute("trainNumSession"));
	Seat seatInfo = (Seat)session.getAttribute("seat");
	session.setAttribute("roomNum", seatInfo.getTrainRoomNum());
	session.setAttribute("seatNum", seatInfo.getSeatNum());
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	String str = "";

	try{
		String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false&useUnicode=true& useUnicode=true&characterEncoding=euc_kr";
		String dbId = "root";
		String dbPass = "1234";
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
		
		String sql = "select*from se_termp.train where num=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, trainNum);
		
		ResultSet rs = pstmt.executeQuery();
		boolean hasNext = rs.next();
		
		if(hasNext){
			System.out.println("### SeatList Session "+rs.getString("t_type"));
			session.setAttribute("trainType", rs.getString("t_type"));
			session.setAttribute("startTime", rs.getTime("start_time").toString());
			session.setAttribute("endTime", rs.getTime("end_time"));
			session.setAttribute("trainPrice", rs.getInt("price"));
		}
		
		success = true;

	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
		if(conn!=null) try{conn.close();}catch(SQLException sqle){}
	}
%>
<%=success%>>