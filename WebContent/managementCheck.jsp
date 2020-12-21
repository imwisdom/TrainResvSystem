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
String pw = request.getParameter("pw");
String phoneNum = request.getParameter("phone1") + request.getParameter("phone2") + request.getParameter("phone3");

if(m.changeInfo(pw, phoneNum)){
%>
	alert("Complete Modification!");
	location.href="InfoManagement.jsp";
<%
}
else{
%>
	alert("Fail to Modification!");
	location.href="InfoMangement.jsp";
<%
}
%>
</script>
</head>
<body>
</body>
</html>