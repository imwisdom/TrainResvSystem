<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.test.daoclass.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Cancel Payment</title>
<script>
<%
Connection conn = null;
PreparedStatement pstmt = null;
String str = "";
Member member = (Member)session.getAttribute("member");
out.print(member.id);

try{
	String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
	String dbId = "root";
	String dbPass = "1234";
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
	
	String sql = "select*from se_termp.resv where user_id='"+member.id+"'order by num desc";
	pstmt = conn.prepareStatement(sql);
	ResultSet rs = pstmt.executeQuery();

	boolean hasNext = rs.next();
	
	if(hasNext){
		int trainNum =  rs.getInt("train_num");
		int trainRoomNum = rs.getInt("train_room_num");
		String seatNum = rs.getString("seat_num");
		
		sql = "delete from se_termp.resv where num="+rs.getInt("num");
		pstmt = conn.prepareStatement(sql);
		int r = pstmt.executeUpdate();
		
		sql = "UPDATE `se_termp`.`seat` SET `state` = 'F' WHERE (`num` = '"+seatNum+"')"
				+"and (`train_room_num` = '"+trainRoomNum+"') and (`train_num` = '"+trainNum+"')";
		
		pstmt = conn.prepareStatement(sql);
		r = pstmt.executeUpdate();	
	}

}catch(Exception e){
	e.printStackTrace();
}finally{
	if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
	if(conn!=null) try{conn.close();}catch(SQLException sqle){}
}

%>
</script>
</head>
<body onload="location.href='SeatList.jsp'">
	
</body>
</html>