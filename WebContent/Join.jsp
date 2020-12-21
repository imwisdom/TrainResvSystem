<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="com.test.daoclass.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="EUC-KR">
	
	<title>Join</title>
	<style>
		body{ margin-top:200px;}
		h1, #submitBtn{ text-align: center; }
		span{ color: red; }
		td:nth-child(1){ text-align: right; }
		#id, #pw{ width:200px; }
		#rrNum1, #rrNum2{ width:89px; }
		#submitBtn{ text-align: center;}
		#input{
		padding : 20px;
  		width : 420px;
  		height: auto;
  		overflow: hidden;
  		margin :auto;

		}
		#button_div{
		text-align:center;
		}

	</style>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
	<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
	<script>
	checked = false;
	exist = true;
	function checkExistId(){
		
		var cid = document.getElementById("id").value;
		if(cid=="")
			alert("아이디를 입력하지 않았습니다.");
		else{
			$.ajax({
		           method : 'POST',
		           url : './IdExistCheck.jsp',
		           data : {
		        	   id : cid
		           },
		           success: function(data){
						if(data.indexOf("true")>=0){
							exist = true;
							document.getElementById("duplicationResultTxt").innerHTML = "중복";
						}
						else{
							exist = false;
							document.getElementById("duplicationResultTxt").innerHTML = "사용가능";
						}
		           }
		         });
			checked = true;

		}	
	}
	function join(){
		
		if(!checked)
			alert("아이디 중복확인을 하지 않으셨습니다.");
		else{
			if(exist)
				alert("아이디가 중복되었습니다.");
			else{
				var id = document.getElementById("id").value;
				var pw = document.getElementById("pw").value;
				var rrNum1 = document.getElementById("rrNum1").value;
				var rrNum2 = document.getElementById("rrNum2").value;
				var phone1 = document.getElementsByName("phNum_front")[0].value;
				var phone2 = document.getElementsByName("phNum_mid")[0].value;
				var phone3 = document.getElementsByName("phNum_last")[0].value;
				
				if(id=="" || pw=="" || rrNum1=="" || rrNum2=="" || phone1=="" || phone2=="" || phone3=="")
					alert("입력하지 않은 정보가 있습니다.");
				else{
					document.getElementsByName("formN")[0].submit();
				}
			}
		}
	}
	
	
	</script>
</head>
<body>
	<h1>Join</h1>
	<div id='form'>
	<form name="formN" action="JoinCheck.jsp" method="post">
		<div id='input'>
		<table>
			<tbody>
				<tr>
					<td>ID</td>
					<td><input type="text" name="id" id='id' required>
					<input type='button' name='checkID' value='중복확인' onclick="checkExistId()"></td>
					<td><span id='duplicationResultTxt' style="font-size:10px"></span></td>
				</tr>
				<tr>
					<td>PW</td>
					<td><input type="password" name="pw" id='pw' required></td>
					<td></td>
				</tr>
				<tr>
					<td>주민번호</td>
					<td><input type="tel" name="rrNum_front" maxlength='6' size='6' id='rrNum1' pattern="[0-9]{6}" required> -
					<input type="tel" name="rrNum_last" maxlength='7' size='7' id='rrNum2' pattern="[0-9]{7}" required>
					</td>
					<td></td>
				</tr>
				<tr>
					<td>PHONE</td>
					<td><input type="tel" name="phNum_front" maxlength='3' size='3' pattern="[0-9]{3}" id='ph1' required> -
					<input type="tel" name="phNum_mid" maxlength='4' size='4' pattern="[0-9]{4}" id='ph2' required> - 
					<input type="tel" name="phNum_last" maxlength='4' size='4' pattern="[0-9]{4}" id='ph3' required>
					</td>
					<td></td>
				</tr>
			</tbody>
		</table>
		</div>
		<div id="button_div"><input type=button id='submitBtn' value='Submit' onclick="join()"></div>
	</form>
	</div>
</body>
</html>


