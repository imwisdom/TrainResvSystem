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
<title>management check</title>
<script>

<%
Member m = (Member)session.getAttribute("member");

if(m.removeInfo()){
%>
	alert("정상적으로 회원 탈퇴되었습니다.")
<%	session.removeAttribute("members");
	session.removeAttribute("id"); %>
	location.href="Main.jsp";
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