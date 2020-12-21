<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.test.daoclass.*"%>
<%@ page import="com.test.parsing.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Check Train Conditions</title>
<script>
<%
	String startS = request.getParameter("startS");
	String arrS = request.getParameter("arrS");
	String date = request.getParameter("date");
	String hour = request.getParameter("hour");
	String minute = request.getParameter("minute");
	
	if(hour.length()==1)
		hour = "0"+hour;
	if(minute.length()==1)
		minute = "0"+minute;

	Time time = ParsingTrain.stringToTime(hour+minute+"00");
	
	java.util.Date curDate = new SimpleDateFormat("yyyy-MM-dd").parse(date);
	java.sql.Date realDate = new java.sql.Date(curDate.getTime());
	
	boolean trainExist = Train.selectTrainCondition(startS, arrS, realDate, time);
%>
<%=trainExist%>
</script>
</head>
<body>

</body>
</html>