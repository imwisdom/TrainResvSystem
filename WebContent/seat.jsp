<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="com.test.daoclass.*"%>
<%@ page import="java.util.ArrayList" %>

<%
Seat seat = (Seat)session.getAttribute("seat");

int trainNum = seat.getTrainNum();
int roomNum =  Integer.parseInt(request.getParameter("roomNum"));
ArrayList<Seat> seatList = Seat.printSeatForTrainRoomNum(trainNum, roomNum); 
ArrayList<String> r =  new ArrayList<String>();

for(Seat s : seatList){ 
	if(s.getSeatState().equals("T")){
		r.add(s.getSeatNum());
	}
}

session.setAttribute("seatList", r);
%>
<%= session.getAttribute("seatList")%>