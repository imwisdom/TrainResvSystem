<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.test.daoclass.*"%>
<!DOCTYPE html>
<html>
<head>
<% request.setCharacterEncoding("euc-kr");%>
<meta charset="EUC-KR">
<link href="c_InfoManagement.css" rel='stylesheet' type="text/css">	
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

<title>Information Management</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script>
	window.onload = function() {
		openmodal(1);
	}
	
	var caseNumOfCheckPw = null;
	
	function openmodal(index) {
		caseNumOfCheckPw = index;
		var modal = document.getElementsByClassName('myModal')[0];
		
		if(caseNumOfCheckPw == 1){
			modal.getElementsByTagName('h3')[0].innerHTML  = "�������� ��ȸ�� ����<br/>��й�ȣ�� �Է����ּ���.";
		}
		else if(caseNumOfCheckPw == 2){
		}
		
		modal.style.display = "block";
    }

	function modifyInfo(){
		
		var pw = document.getElementById("pw").value;
		var phone1 = document.getElementById("phNum_front").value;
		var phone2 = document.getElementById("phNum_mid").value;
		var phone3 = document.getElementById("phNum_last").value;
		
		if(pw=="" || phone1=="" || phone2=="" || phone3=="")
			alert("�Է����� ���� ������ �ֽ��ϴ�.");
		else{
			document.getElementsByName("formN")[0].submit();
		}
	}
	
    function checkPw() {
    	
    	var v_pw = document.getElementById("modal_pw").value;
   		<%
    	Member m = (Member)session.getAttribute("member");
    	%> v_real = <%= m.getPw() %>; 

    	
		if(v_pw==""){
			alert("��й�ȣ�� �Է����� �ʾҽ��ϴ�.");
			document.getElementsByName("modal_pw")[0].focus();
		}
		else{
			$.ajax({
		           method : 'POST',
		           url : './pwCheck.jsp',
		           data : {
		        	   pw : v_pw,
		        	   info : v_real 
		           },
		           success: function(data){
						
		        	   if(caseNumOfCheckPw == 1){
		        		   	//alert("Success");
		        		   	showInfo(data);
		        	   }else if(caseNumOfCheckPw == 2){
		        			//alert("Success");
		        			removeInfo(data);
		        	   }
						
		           }
		         });
			document.getElementById("modal_pw").value = null;
		}	
		
    }
    function showInfo(pwCheck){
    	
    	if(pwCheck == "true"){
    		document.getElementsByClassName('myModal')[0].style.display = "none";
    		
     		var id = document.getElementById('id');
    		var pw = document.getElementById('pw');
    		var rrNum1 = document.getElementById("rrNum1");
    		var rrNum2 = document.getElementById("rrNum2"); 
			var phone1 = document.getElementById("phNum_front");
			var phone2 = document.getElementById("phNum_mid");
			var phone3 = document.getElementById("phNum_last");
    		
			var info_rrNum = "<%= m.getRrNum() %>";
    		var info_phone = "<%= m.getPhoneNum() %>";

    		id.value = "<%= m.getId() %>";
    		pw.value = "<%= m.getPw() %>";
    		rrNum1.value = info_rrNum.substr(0,6);
    		rrNum2.value = info_rrNum.substr(6,7);	
    		phone1.value = info_phone.substr(0,3);	
    		phone2.value = info_phone.substr(3,4);	
    		phone3.value = info_phone.substr(7,4);	 
    		
    		
    	}else{
    		alert("��й�ȣ�� Ʋ�Ƚ��ϴ�.");
    		document.getElementById("modal_pw").value = '';
    		document.getElementById("modal_pw").focus();
    	}
    	
    }
	function removeInfo(pwCheck){
		
		if(pwCheck!="false"){
			location.href="removeInfoCheck.jsp";
		}else{
			alert("��й�ȣ�� Ʋ�Ƚ��ϴ�.");
    		document.getElementById("modal_pw").value = '';
    		document.getElementById("modal_pw").focus();
		}
	}
	
	function exit(){
		if(caseNumOfCheckPw == 1){
			location.href="ChooseConditions.jsp";
	   }else if(caseNumOfCheckPw == 2){
		   location.href="InfoManagement.jsp";
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
	 %>
	</span>��<span><input type='button' value='��������' name='resvBtn' onclick="location.href='ChooseConditions.jsp'">
		<input type='button' value='��������' name='infoBtn' onclick="location.href='InfoManagement.jsp'">
		<input type='button' value='������Ȯ��' name='ticketBtn' onclick="location.href='ResvAndPaymentRecord.jsp'"></span>
	</div>
	
	<div id='main'>
	<h1>�������� ����</h1>
	<div id='form'>
	<form name="formN" action="managementCheck.jsp" method="post">
	<div id='input'>
		<table>
			<tbody>
				<tr>
					<td>ID</td>
					<td><input type="text" id='id' disabled></td>
				</tr>				
				<tr>
					<td>�ֹι�ȣ</td>
					<td><input type="tel" id='rrNum1' maxlength='6' size='6' pattern="[0-9]{6}"  disabled> - 
					<input type="passward" id='rrNum2' maxlength='7' size='7' pattern="[0-9]{7}" disabled></td>
				</tr>
				<tr>
					<td>PW</td>
					<td><input type="password" id="pw" name='pw'></td>
				</tr>
				<tr>
					<td>PHONE</td>
					<td><input type="text" id="phNum_front" name='phone1' maxlength='3' size='3' pattern="[0-9]{3}"> - 
					<input type="text" id="phNum_mid" name='phone2' maxlength='4' size='4' pattern="[0-9]{4}"> - 
					<input type="text" id="phNum_last" name='phone3' maxlength='4' size='4' pattern="[0-9]{4}"></td>
				</tr>
			</tbody>
		</table>
		</div>
	</form>
	<div id="button_div">
		<input type=button id='modifyInfoBtn' class="btn btn-warning" value='�����ϱ�(OK)' onclick="modifyInfo()">
		<input type=button id='removeInfoBtn' class="btn btn-warning" value='Ż��' onclick="openmodal(2)">
	</div>
	</div>
	</div>

	<!-- The Modal -->
    <div class="myModal">
 
      <!-- Modal content -->
      <div class="modal-content">
      	<form method="post" name="loginform">
      		<div id="tablediv">
      			<h3>��й�ȣ�� �Է����ּ���.</h3>
      			<table>
      				<tr><td style="background-color:#F8E0E0;border:1px solid black">��й�ȣ </td>
      				<td><input type="password" id="modal_pw" autofocus></td></tr>	
      			</table>
      		</div>
      		<br>
			<div id="modal-buttons">
				<!--<input type=submit value="Ȯ��"> -->
				<input type=button value="Ȯ��" onclick="checkPw()" >
				<input type=button value="���" onclick="exit()" >
			</div>
		</form>
      </div>
 
    </div>
	
</body>
</html>