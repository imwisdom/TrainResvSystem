<%@page import="java.text.SimpleDateFormat"%>
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
   <%
		request.setCharacterEncoding("euc-kr");
   
   		String startStation = "";
		String arrStation = "";
		String date = "";
		String hour = "";
		String minute = "";
	
		if(request.getParameter("startS")!=null){
   			
   			startStation = request.getParameter("startS");
   			arrStation = request.getParameter("arrS");
   			date = request.getParameter("startD");
   			hour = request.getParameter("hour");
   			minute = request.getParameter("minute");
   			
   			System.out.println(startStation+" "+arrStation+" "+date+" "+hour+" "+minute);
   			session.setAttribute("startSsession", startStation);
   			session.setAttribute("arrSsession", arrStation);
   			session.setAttribute("startDsession", date);
   			session.setAttribute("hoursession", hour);
   			session.setAttribute("minutesession", minute);

   		}
   		else{
   			startStation = (String)session.getAttribute("startSsession");
   			arrStation = (String)session.getAttribute("arrSsession");
   			date = (String)session.getAttribute("startDsession");
   			hour = (String)session.getAttribute("hoursession");
   			minute = (String)session.getAttribute("minutesession");
   		}
   			
  
		HashMap<String, String> hash = ParsingTrain.getTrainCodeArray();
		String startID = hash.get(startStation);
		String endID = hash.get(arrStation);
		if(hour.length()==1) hour = "0"+hour;
		if(minute.length()==1) minute = "0"+minute;
		Time startTime = ParsingTrain.stringToTime(hour+minute+"00");
		java.util.Date arrDate = new SimpleDateFormat("yyyy-MM-dd").parse(date);
		java.sql.Date trainDate = new java.sql.Date(arrDate.getTime());

		String bodyStringStart = "";
		String bodyStringEnd = "";
		
		
	
		ArrayList<Train> trainListOrderByStart = Train.printSortedTrain(startStation, arrStation, trainDate, startTime, 0);
		ArrayList<Train> trainListOrderByEnd = Train.printSortedTrain(startStation, arrStation, trainDate, startTime, 1); 
			
		for(int i=0;i<trainListOrderByStart.size();i++){
			Train curTrainOrderByStart = trainListOrderByStart.get(i);
			bodyStringStart = bodyStringStart+"<tr class="+curTrainOrderByStart.trainNum+">";
			bodyStringStart = bodyStringStart+"<td>"+curTrainOrderByStart.trainType+"</td>";
			bodyStringStart = bodyStringStart+"<td>"+curTrainOrderByStart.startTime+"</td>";
			bodyStringStart = bodyStringStart+"<td>"+curTrainOrderByStart.endTime+"</td>";
			bodyStringStart = bodyStringStart+"<td>"+curTrainOrderByStart.leadTime+"</td>";
			bodyStringStart = bodyStringStart+"<td>"+curTrainOrderByStart.price+"</td>";
			bodyStringStart = bodyStringStart+"<td style='border:1px solid rgb(255,231,154);background-color:rgb(255,231,154)'><input type=button onclick=moveSeatList('"+curTrainOrderByStart.trainNum+"') style='border:1px solid black;background-color:#FFBF00;font-size:20px' value='좌석 조회'></td></tr>";
			
			Train curTrainOrderByEnd = trainListOrderByEnd.get(i);
			
			bodyStringEnd = bodyStringEnd+"<tr class="+curTrainOrderByStart.trainNum+">";
			bodyStringEnd = bodyStringEnd+"<td>"+curTrainOrderByEnd.trainType+"</td>";
			bodyStringEnd = bodyStringEnd+"<td>"+curTrainOrderByEnd.startTime+"</td>";
			bodyStringEnd = bodyStringEnd+"<td>"+curTrainOrderByEnd.endTime+"</td>";
			bodyStringEnd = bodyStringEnd+"<td>"+curTrainOrderByEnd.leadTime+"</td>";
			bodyStringEnd = bodyStringEnd+"<td>"+curTrainOrderByEnd.price+"</td>";
			bodyStringEnd = bodyStringEnd+"<td style='border:1px solid rgb(255,231,154);background-color:rgb(255,231,154)'><input type=button onclick=moveSeatList('"+curTrainOrderByStart.trainNum+"') style='border:1px solid black;background-color:#FFBF00;font-size:20px' value='좌석 조회'></td></tr>";
			
			
			
		}
		
	
   %>
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">


<title>Choose Train Condition</title>
<style>
   span:nth-child(2){ 
      position:absolute;
      right:50px;
    }
    span:nth-child(2)>input { width: 100px; margin:3px;}
    span:nth-child(2)>input:nth-child(1) {background-color: rgb(255,231,154);}
    h1{ text-align:center; font-weight: bold; }
    #top{ padding:50px; }
    #main{ 
       background-color: rgb(255,231,154); 
       height:600px;
       padding-top:40px; padding-bottom:20px;
       text-align:center;
       
    }
    h4{
    	padding: 10px;
    	border: 1px solid black;
    	background-color:#FFBF00;
    	width:120px;
    	align : center;
    	text-align : center;
    	position:absolute;
  		left:50%;
  		transform:translate(-50%, -50%);
    }
    #trainInfo{
    	border: 1px solid black;
    	background-color:#F6CECE;
    	align : right;
    	text-align : left;
    	position:absolute;
    	right:10%;
    	font-size:15px;
    	padding:20px;
    	width: 200px;
    	
    }
    #sort{
    	position:absolute;
    	left:10%;
    	font-size:15px;
    	padding:20px;
    	width: 200px;
    }
    #recommend{
    	position:absolute;
    	left:20%;
    	font-size:15px;
    	padding:20px;
    	width: 200px;
    }
    #tableDiv{
    	position:absolute;
    	top:47%;
    	left:20%;
    }
    td, th{
    	border:1px solid black;
    	width: 150px;
    	height: 30px;
    	font-size: 15px;
    }
   
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script>
function printTrains(){
	
	if(document.getElementsByName("order")[0]!=undefined && document.getElementsByName("order")[0].value=="도착시간"){
		
		document.getElementsByTagName("tbody")[0].innerHTML = "<%=bodyStringEnd%>";
	}
	else{
		document.getElementsByTagName("tbody")[0].innerHTML = "<%=bodyStringStart%>";
	}
	var btn = document.getElementById("recommendBtn");
	if(btn.value == "on"){
	      btn.value = "off";
	      var trRecom = document.getElementsByClassName("recommend");
	      var cnt = trRecom.length;
	       
	       for(var i=0; i<cnt; i++){
	          trRecom[0].style.backgroundColor = "#ffffff"; 
	          trRecom[0].classList.remove('recommend');
	       }
	   }
}
function moveSeatList(trainNum){
	
	document.getElementsByName("trainNum")[0].value = trainNum;
	document.getElementById("formId").submit();

	
}
function recommendation(){
	   var btn = document.getElementById("recommendBtn");
	   
	   if(btn.value == "on"){
	      btn.value = "off";
	      var trRecom = document.getElementsByClassName("recommend");
	      var cnt = trRecom.length;
	       
	       for(var i=0; i<cnt; i++){
	          trRecom[0].style.backgroundColor = "#ffffff"; 
	          trRecom[0].classList.remove('recommend');
	       }
	   }
	   else{
	      var index = document.getElementsByTagName('select')[0].selectedIndex;
	      btn.value = "on"; 
	      
	      $.ajax({
	             method : 'POST',
	             url : './recommendation.jsp',
	             data : {
	                value : btn.value
	             },
	             success : function(data) {
	                  if(data.split('\n').pop() == "false"){
	                     alert("최근 3개월 이내의 결제내역이 존재하지 않습니다.")
	                  }else{
	                     trainNumLst = data.split('\n').pop().substr(1,data.split('\n').pop().length-2).split(',');
	                      
	                       for(var i in trainNumLst){
	                          if(trainNumLst[i] == '') break;
	                          var tr = document.getElementsByClassName(trainNumLst[i].trim())[0];
	                          if(tr == null) continue;
	                        // 해당 행들에게 class 부여 
	                         tr.style.backgroundColor = "#ffcaa4"; 
	                         tr.classList.add('recommend');
	                    }
	                  }
	             }
	          });
	   }
	}
	</script>
	</head>
	<body onload = printTrains()>
	   <div id='top'>
	   <span> 
	   <%
	      Member member = (Member)session.getAttribute("member");
	      out.print(member.id);
	      session.setAttribute("member", member);
	    %>
	   </span>님<span><input type='button' value='기차예매' name='resvBtn' onclick="location.href='PAGENAME.html'">
	      <input type='button' value='개인정보' name='infoBtn' onclick="location.href='InfoManagement.jsp'">
	      <input type='button' value='승차권확인' name='ticketBtn' onclick="location.href='ShowTicket.jsp'"></span>
	   </div>
	   
	   <div id='main'>
	   <h4>기차 목록</h4>
	   <div id="trainInfo">
	         <%=startStation%>역 -> <%=arrStation%><br>
	         <%=date%><br>
	         <%=hour%>시 <%=minute%>분
	   </div>
	   <div id="sort">
	      정렬기준<br>
	      <select name="order" onchange="printTrains()" id="order">
	      <option>출발시간</option>
	      <option>도착시간</option>
	      </select>
	   </div>
	   <div id="recommend">
	      기차추천<br>
	      <input type=button value="off" id="recommendBtn" onClick="recommendation()">
	   </div>
	   <div id="tableDiv">
	   <table>
	      <thead>
	         <tr style="background-color:#D8D8D8">
	            <th>기차종류</th><th>출발시간</th><th>도착시간</th><th>소요시간</th><th>가격</th>
	         </tr>
	      </thead>
	      <tbody style="background-color:#FFFFFF">
	      </tbody>
	   </table>
	   </div>
	   <form method="post" action="./SeatList.jsp" id="formId">
	      <input type="hidden" name="trainNum" >
	   </form>
	   </div>

	</body>

</html>