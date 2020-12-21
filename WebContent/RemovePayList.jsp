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
		String payNumStr = request.getParameter("payNumArr");
		
		if(payNumStr!=null && !payNumStr.equals("")){
			String[] payNumArr = payNumStr.split("check");
			ArrayList<Integer> payNumList = new ArrayList<Integer>();
			for(int i=0;i<payNumArr.length;i++){
				payNumList.add(Integer.parseInt(payNumArr[i]));
			}
		
			session.setAttribute("payNumList", payNumList);
		}
		
	%>
	
</script>
</head>
<body>

</body>
</html>