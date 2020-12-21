<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.test.daoclass.*"%>
<!DOCTYPE html>
<html>
<head>
	<%
		request.setCharacterEncoding("euc-kr");
	%>
<meta charset="EUC-KR">
<title>Join Check</title>
<script>
<%
String id = request.getParameter("id");
String pw = request.getParameter("pw");
String rrNum = request.getParameter("rrNum_front")+request.getParameter("rrNum_last");
String phNum = request.getParameter("phNum_front")+request.getParameter("phNum_mid")+request.getParameter("phNum_last");

if(Member.join(id, pw, rrNum, phNum)){
	%>
	alert("성공적으로 가입되셨습니다.");
	location.href="Main.jsp";
	<%
}
else{
	%>
	alert("회원가입에 실패하였습니다.");
	<%
}
%>
</script>
</head>
<body>

</body>
</html>