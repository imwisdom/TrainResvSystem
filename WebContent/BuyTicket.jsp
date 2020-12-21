<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="com.test.daoclass.*"%>
<%@ page import="java.sql.*" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Buy Ticket</title>
<script>
<%
	String paymethod = request.getParameter("paymethod");
	System.out.println("imim+"+paymethod);
	Payment p = new Payment();
	p.payMethod = Integer.parseInt(paymethod);
	
	p.buyTicket();
%>
</script>
</head>
<body>

</body>
</html>