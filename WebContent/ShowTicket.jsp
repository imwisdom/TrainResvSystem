<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.test.daoclass.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
	<%
		request.setCharacterEncoding("euc-kr");
	%>
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">


<title>BookManagement</title>
<style>
	span:nth-child(2){ 
		position:absolute;
		right:50px;
	 }
	 span:nth-child(2)>input { width: 100px; margin:3px;}
	 span:nth-child(2)>input:nth-child(3) {background-color: rgb(255,231,154);}
	 h1{ text-align:center; font-weight: bold; }
    #top{ padding:50px; }
    #main{ 
    	background-color: rgb(255,231,154); 
    	height:600px;
    	padding-top:80px; padding-bottom:20px;
    	text-align:center;
    }
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>

</head>
<body>
	<div id='top'>
	<span> 
	<%
 		Object id = session.getAttribute("id");
 		out.print((String) id);
	 %>
	</span>님<span><input type='button' value='기차예매' name='resvBtn' onclick="location.href='ChooseConditions.jsp'">
		<input type='button' value='개인정보' name='infoBtn' onclick="location.href='InfoMangement.jsp'">
		<input type='button' value='승차권확인' name='ticketBtn' onclick="location.href='ShowTicket.jsp'"></span>
	</div>
	
	<div id='main'>
	<div><h1>결제 내역</h1></div>
	<div><h1>탑승 전 승차권 내역</h1></div>	
	</div>

	
</body>
</html>