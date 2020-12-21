<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="EUC-KR">
	<%request.setCharacterEncoding("euc-kr");%>
	<link href="MainCss.css" rel='stylesheet' type="text/css">
	<title>Train Reservation System</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script>
        function openmodal() {
        	document.getElementsByClassName('myModal')[0].style.display = "block";
        }
        function exit() {
        	document.getElementsByClassName('myModal')[0].style.display = "none";
        }

        function init(){
        	document.getElementsByName("id")[0] = "";
        	document.getElementsByName("pw")[0] = "";
        }

        
</script>
<body>
	
	<div>
	<h1 id='title' style="font-size:40px">Train Reservation System</h1>
	<br><br>
	<div>
		<input type='button' id='login_btn' value='Login' onclick="openmodal()"> 
		<input type='button' id='join_btn' value='Join' onclick="location.href='Join.jsp'">
	</div>
	</div>
	<br>
	<!-- The Modal -->
    <div class="myModal">
 
      <!-- Modal content -->
      <div class="modal-content">
      	<form method="post" name="loginform" action="LoginCheck.jsp">
      		<div id="tablediv">
      			<h3>로그인</h3>
      			<table>
      				<tr><td style="background-color:#F8E0E0;border:1px solid black">아이디 </td>
      				<td><input type="text" name="id" style="border:1px solid black"></td></tr>
      				<tr><td style="background-color:#F8E0E0;border:1px solid black">비밀번호 </td>
      				<td><input type="password" name="pw" style="border:1px solid black"></td></tr>	
      			</table>
      		</div>
      		<br>
			<div id="buttons">
				<input type=submit value="확인" style="background-color:#F2F5A9;border:1px solid black">  
				<input type=button onclick="exit()" value="취소" style="background-color:#F2F5A9;border:1px solid black">
			</div>
		</form>
      </div>
 
    </div>

</body>
</html>