<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    <%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.test.daoclass.*"%>
<%@ page import="com.test.parsing.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>RemovePayList</title>
<script>
	<%
		String payNum = request.getParameter("payNum");
		
		boolean isCanceled = Payment.cancelTicket(Integer.parseInt(payNum));
	%>
	canceled:<%=isCanceled%> 
</script>
</head>
<body>

</body>
</html>