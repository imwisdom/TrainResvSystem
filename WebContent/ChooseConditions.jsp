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
   		System.out.println("hi Choose");
   
		if(session.getAttribute("startSsession")!=null){
			
			session.removeAttribute("startSsession");
			session.removeAttribute("arrSsession");
			session.removeAttribute("startDsession");
			session.removeAttribute("hoursession");
			session.removeAttribute("minutesession");
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
       padding-top:80px; padding-bottom:20px;
       text-align:center;
       
    }
    select{
    	width:120px;
    	height:24px;
    	border: 1px solid black;

    }
    #leftDiv, #rightDiv{
    	float:left;
    	text-align: left;
    	padding-top:180px; padding-bottom:20px;
		padding-left:20px; padding-right:20px; 

    }
    b{
    	width:30px;
    	border: 1px solid black;
    	background-color: #F6CEEC;
    	font-size : 20px;
    }
    #valueDiv{
    	align : center;
    	text-align : center;
    	position:absolute;
  		left:50%;
  		padding-top:80px;
  		transform:translate(-50%, -50%);

    }
   
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script>
function sendFormData(){

	var startS = document.getElementsByName("startS")[0].value;
	var arrS = document.getElementsByName("arrS")[0].value;
	var date = document.getElementsByName("startD")[0].value;
	var hour = document.getElementsByName("hour")[0].value;
	var minute = document.getElementsByName("minute")[0].value;
	
	if(!(startS=="" || arrS=="" || date=="" || hour=="" || minute=="")){
		
		$.ajax({
	           method : 'POST',
	           url : './CheckTrainConditions.jsp',
	           data : {
	        	   startS : startS,
	        	   arrS : arrS,
	        	   date : date,
	        	   hour : hour,
	        	   minute : minute
	           },
	           success: function(data){
					if(data.indexOf("false")>0)
						alert("조건에 만족하는 기차가 존재하지 않습니다.");
						
					else
						document.getElementsByName("trainForm")[0].submit();
	           }	
	         });
		
		//document.getElementsByName("trainForm")[0].submit();
	}
}
</script>
</head>
<body>
   <div id='top'>
   <span> 
   <%
       Member member = (Member)session.getAttribute("member");
       out.print(member.id);
       session.setAttribute("member", member);

       Set<String> stationSet = ParsingTrain.getTrainCodeArray().keySet();
       List<String> stationList = new ArrayList<String>(stationSet);
       Collections.sort(stationList);
    %>
   </span>님<span><input type='button' value='기차예매' name='resvBtn' onclick="location.href='ChooseConditions.jsp'">
      <input type='button' value='개인정보' name='infoBtn' onclick="location.href='InfoManagement.jsp'">
      <input type='button' value='승차권확인' name='ticketBtn' onclick="location.href='ResvAndPaymentRecord.jsp'"></span>
   </div>
   
   <div id='main'>
   <h1>기차 조건 선택</h1>
   <form name="trainForm" method="post" action="TrainList.jsp">
   	<div id="valueDiv">
   	<div id="leftDiv">
   		<b>출발역</b>
		<select name="startS">
		<option></option>
		<% 
		for(int i=0;i<stationList.size();i++){
   			%><option><%=stationList.get(i)%></option><%
   		}
   		%>
		</select><br><br>
   		<b>날짜</b>
   		<input type="date" name="startD" style="width:140px; border:1px solid black" ><br><br>
   	</div>
   	<div id="rightDiv">
   		<b>도착역</b>
		<select name="arrS">
		<option></option>
		<% 
		for(int i=0;i<stationList.size();i++){
   			%><option><%=stationList.get(i)%></option><%
   		}
   		%>
		</select><br><br>
		<b>시간</b><br>

		<div style="float:left">
		<b>시</b>
   		<select name="hour" style="width:65px" >
   		<option></option>
   		<% 
   		for(int i=0;i<=23;i++){
   			%><option><%=i%></option><%
   		}
   		%>
   		</select><br><br>
		</div>
		<div style="float:left; padding-left:10px">
		<b>분</b>
   		<select name="minute" style="width:65px" >
   		<option></option>
   		<% 
   		for(int i=0;i<=59;i++){
   			%><option><%=i%></option><%
   		}
   		%>
   		</select>
   		</div>
   	</div>
   	<br><br><br><input type="button" onclick="sendFormData()" style="border:2px solid black;background-color:#CEF6D8;font-size:20px"value="조회하기">
   	</div>
   	</form>
   </div>

</body>
</html>