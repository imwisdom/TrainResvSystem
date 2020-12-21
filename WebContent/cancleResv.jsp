<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="com.test.daoclass.*"%>

<%
Seat resvSeat = (Seat)session.getAttribute("seat");
Resv lastestResv = Resv.getLatestResv();

boolean successCancle = false;

if(Seat.cancleResvSeat(resvSeat) && Resv.cancleResvList(lastestResv)){
	
	Seat newSeat = new Seat(resvSeat.getTrainNum());
	session.setAttribute("seat", newSeat); 
	successCancle = true;
}
%>
<%= successCancle%>