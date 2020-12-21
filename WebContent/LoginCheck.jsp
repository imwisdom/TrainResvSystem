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
<title>login check</title>
<script>
<%
String id = request.getParameter("id");
String pw = request.getParameter("pw");

if(Member.login(id, pw)){

	session.setAttribute("member", new Member(id));
	%>
	location.href="ChooseConditions.jsp";
	<%
}
else{
%>
location.href="Main.jsp";
<%
}
%>
</script>
</head>
<body>
</body>
</html>