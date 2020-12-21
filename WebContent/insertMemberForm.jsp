<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="../../mainClientHeader.jsp" flush="true"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
	<link rel="stylesheet" type="text/css" href="../CSS/ClientForm.css">
</head>
<body>
	<div class="client_form center">
		<div class="form_tag">
			<h1>회원가입폼</h1>
			<form method="post" action="./insertMemberPro.jsp">
				<table class="center">
					<tr><td>아이디:</td><td> <input type="text" name="id" maxlength="12" required></td></tr>
					<tr><td>비밀번호:</td><td> <input type="text" name="passwd" required></td></tr>
					<tr><td>이름:</td><td> <input type="text" name="name" maxlength="12" required></td></tr>
					<tr><td>생년월일:</td><td> <input type="number" name="birthday" placeholder="insert 6 number"></td></tr>
					<tr><td>주소:</td><td> <textarea rows="2" cols="10" name="address" maxlength="50" required></textarea></td></tr>
					<tr><td>전화번호:</td><td> <input type="text" name="phonenumber" maxlength="11" required></td></tr>
				</table>
				<input type="submit" value="입력완료">
				<input type="reset" value="다시입력">
			</form>
		</div>
	</div>
</body>
<%
	Object data = request.getParameter("isSucc");
	if(data != null && ((String)data).equals("0"))
		%><script>alert("회원가입이 처리되지 않았습니다.");</script><%
%>
</html>

