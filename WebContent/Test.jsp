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
<title>BookManagement</title>
<script>
<%
String id = request.getParameter("id");
String pw = request.getParameter("pw");
System.out.println("과연? "+id+", "+pw);

Member m = new Member("jihye");
%>

</script>
</head>
<body>
</body>
</html>