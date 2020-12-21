<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="com.test.daoclass.*"%>

<%
	Resv latestResv = Resv.getLatestResv();
	Resv.cancleResvList(latestResv);
	Seat resvSeat = (Seat) session.getAttribute("seat");
	System.out.println("******************** " + resvSeat.getSeatNum());
	Seat.cancleResvSeat(resvSeat);
%>