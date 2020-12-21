<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.test.daoclass.*"%>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
	<%
		request.setCharacterEncoding("euc-kr");
		
		String trainNum = request.getParameter("trainNum");
		if(trainNum!=null)
			session.setAttribute("trainNumSession", trainNum);
		else{
			trainNum = (String)session.getAttribute("trainNumSession");
		}
			
		System.out.println("train num: "+trainNum);
		
	%>

<title>Seat list</title>

<link href="c_SeatList.css" rel='stylesheet' type="text/css">
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script>
window.onpageshow = function (event) {
    if (event.persisted || (window.performance && window.performance.navigation.type == 2)) {

        $.ajax({
             method : 'POST',
             url : './goBackPayment.jsp',
             data : {
             },
             success : function(data) {

                showSeatState();
             }
          }); 
    }
}

window.onload = function() {
    var select = document.getElementsByTagName('select')[0];
    var seatTable1 = document.getElementsByTagName('tbody')[0];
    var seatTable2 = document.getElementsByTagName('tbody')[1];
    
    for (var i = 0; i < 15; i++) {
       var opt = document.createElement('option');
       opt.value = i + 1;
       opt.innerHTML = (i + 1) + " 호실";
       opt.style.textAlign = "center";
       select.appendChild(opt);
    }
    
    for(var i=0;i<2;i++){
       tr = seatTable1.getElementsByTagName('tr')[i];
       
       for(var j=0;j<9;j++){
          td = tr.childNodes[j];
          td.innerHTML = (j+1) + String.fromCharCode(65+i);
          td.id = (j+1) + String.fromCharCode(65+i);
          td.onclick = function(event){ clickSeat(event)};
       }
    }
    for(var i=0;i<2;i++){
       tr = seatTable2.getElementsByTagName('tr')[i];
       
       for(var j=0;j<9;j++){
          td = tr.childNodes[j];
          td.innerHTML = (j+1) + String.fromCharCode(67+i);
          td.id = (j+1) + String.fromCharCode(67+i);
          td.onclick = function(event){ clickSeat(event)};
       }
    }
    
    <% 
    Seat seat = new Seat(Integer.parseInt((String)session.getAttribute("trainNumSession")));
    session.setAttribute("seat", seat); 
    %>
    showSeatState();
     
 }
 
 var v_roomNum = null; // 현재 호실번호
 var v_clickedSeat = new Array();
 
 function clickSeat(e){
    if(e.target.tagName != "TD") return;
    
    var prev = document.getElementsByClassName("clicked");
    
    if( !e.target.classList.contains('noClick')){
       if(e.target.classList.contains('clicked')){
          e.target.style.backgroundColor = "#ffffed";
          e.target.classList.remove('clicked');
          v_clickedSeat[0] = null;
          v_clickedSeat[1] = null;
       }
       else if(v_clickedSeat[0] == null){
          e.target.classList.add('clicked');
          e.target.style.backgroundColor = "#fd6868"; 
          v_clickedSeat[0] = v_roomNum;
          v_clickedSeat[1] = e.target.id;
       }
       console.log(e.target);
    }
 }
 

 function showSeatState(){
    var sel = document.getElementById("roomNumSelectBox");
    var tdAll = document.getElementsByTagName('td');
    var seatNumLst = null;
    v_roomNum = sel.options[sel.selectedIndex].value;
    
    for(var i=0; i<36; i++){
       tdAll[i].style.backgroundColor = "#ffffed"; 
       tdAll[i].classList.remove('noClick');
       tdAll[i].classList.remove('clicked');
    }
    
    if(v_roomNum == v_clickedSeat[0]){
       var aClickedSeat = document.getElementById(v_clickedSeat[1]);
       aClickedSeat.classList.add('clicked');
       aClickedSeat.style.backgroundColor = "#fd6868";
    }
    
    $.ajax({
       method : 'POST',
       url : './seat.jsp',
       data : {
          roomNum : v_roomNum
       },
       success : function(data) {
          seatNumLst = data.split('\n').pop().substr(1,data.split('\n').pop().length-2).split(',');
          for(var i in seatNumLst){
             if(seatNumLst[i] == '') break;
             var td = document.getElementById(seatNumLst[i].trim());
             td.style.backgroundColor = "#a4a4a4"; 
             td.classList.add('noClick');
          }
       }
    });
 
 }
 function goToResv() {
    // 예매 내역에 추가 
    var seat = document.getElementsByClassName("clicked");
    
    if(seat.length == 0){
       alert("좌석을 선택해주세요.");
    }else{
       var v_seatNum = seat[0].innerText;
       
       $.ajax({
          method : 'POST',
          url : './goResv.jsp',
          data : {
             seatNum : v_seatNum,
             roomNum : v_roomNum
          },
          success : function(data) {
             console.log("ajax goToResv(): "+ data.split('\n').pop());
             
             if(data.split('\n').pop() == "true"){
                
                // 해당 버튼 보이기 
                var bottom = document.getElementsByClassName('bottom')[0];
                bottom.getElementsByTagName('div')[0].style.display = "none";
                bottom.getElementsByTagName('div')[1].style.display = "block";
                
                document.getElementById("paper").style.display = "block";
                document.getElementById("roomNumSelectBox").disabled = true;
                
             }
          }
       });
    }
 }
 function cancelResv(){
    
    // 예매 내역에 삭제 
    $.ajax({
          method : 'POST',
          url : './cancleResv.jsp',
          data : {
          },
          success : function(data) {
             console.log("ajax : "+ data.split('\n').pop());
             
             if(data.split('\n').pop() == "true"){
                
                var bottom = document.getElementsByClassName('bottom')[0];
                bottom.getElementsByTagName('div')[0].style.display = "block";
                bottom.getElementsByTagName('div')[1].style.display = "none";
                
                document.getElementById("paper").style.display = "none";
                document.getElementById("roomNumSelectBox").disabled = false;
                
             }
          }
       });
 }
 function goToPay(){
    $.ajax({
         method : 'POST',
         url : './getTrainInfo.jsp',
         data : {
         },
         success : function(data) {
            console.log("ajax : "+ data.split('\n').pop());
         }
     });
    location.href='Payment.jsp';
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
	 %>
  </span>님<span><input type='button' value='기차예매' name='resvBtn' onclick="location.href='ChooseConditions.html'">
      <input type='button' value='개인정보' name='infoBtn' onclick="location.href='InfoManagement.jsp'">
      <input type='button' value='승차권확인' name='ticketBtn' onclick="location.href='ResvAndPaymentRecord.jsp'"></span>
   </div>
	
	<div id='main'>
	<div class='top'>
		<input type=button id='goPrevPageBtn' name='goPrevPageBtn' value='기차목록' onclick="location.href='TrainList.jsp'">
		<h1>좌석 목록</h1><div id='combo'>
		<span>호실  </span><select id="roomNumSelectBox" onchange="showSeatState()"></select></div>
	</div>
	<div class='mid'>
		<div class="door"></div>
		<div class="table">
		<table> <!-- Seat table 1 -->
			<tbody>
				<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
				<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
			</tbody>
		</table>
		<table> <!-- Seat table 2 -->
			<tbody>
				<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
				<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
			</tbody>
		</table>
		</div>
		<div class="door"></div>
	</div> 
		
	<div class='bottom' style="position:absolute;top:90%">
		<div><input type=button id='ResvBtn' name='ResvBtn' value='go Reservation' onclick="goToResv()"></div>
		<div><input type=button id='cancleBtn' name='cancleBtn' value='cancel Reservation' onclick="cancelResv()" >
		<input type=button id='goToPayBtn' name='goToPayBtn' value='go Payment' onclick="goToPay()"></div>
	</div>
	</div>

	<div id='paper'><span>* 좌석 선택 안됨</span></div>
</body>
</html>