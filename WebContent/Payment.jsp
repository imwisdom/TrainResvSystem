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
      System.out.println(session.getAttribute("trainType"));
   %>
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

<title>Payment Page</title>
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
       align: center;
       
    }
    h4{
       font-weight: 900;
    }
    #paymentDiv{
       width:1000px;
       height:400px;
       background-color: #FFFFFF;
       display: inline-block;
       border : 1px solid black;

    }
    #leftDiv, #rightDiv{
       margin:10px;   
       width: 470px;
       height: 380px;
    }
    #leftDiv{
       float: left;
       text-align: left;
       padding:10px;
       border: 1px solid black;
    }
    
    #rightDiv{
       float: right;
       text-align: left;
       padding:10px;
    }
    #paymentInfo{
       border: 1px solid black;
       width: 440px;
       height: 330px;
       margin: 3px;
    }
    #cardPayment{
       border: 1px solid black;
       width: 440px;
       height: 330px;
       margin: 3px;
       margin-top: 10px;
       padding: 30px;
    }
    #depositPayment{
       border: 1px solid black;
       width: 440px;
       height: 330px;
       margin: 3px;
       margin-top: 10px;
       padding: 30px;
       font-size: 14px;
    }
    .cardNum{
       width: 80px;
    }
    .bottomBtn{
       border: 1px solid black;
      background-color: #F7D358;
    }
    
    #cardBtn, #depoBtn{
       border: 1px solid black;
      background-color: #FFFFFF;
    }
   
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script>
window.onload = function() {
}

function showCardPayment(){
   document.getElementById("depositPayment").style.display="none";
   document.getElementById("cardPayment").style.display="block";
   
   document.getElementById("cardBtn").style.backgroundColor="#F5A9A9";
   document.getElementById("depoBtn").style.backgroundColor="#FFFFFF";
}
function showDepoPayment(){
   document.getElementById("cardPayment").style.display="none";
   document.getElementById("depositPayment").style.display="block";
   
   document.getElementById("depoBtn").style.backgroundColor="#F5A9A9";
   document.getElementById("cardBtn").style.backgroundColor="#FFFFFF";
}
function payment(){
	
	var paymethod = -1;
	if(document.getElementById("cardPayment").style.display=="block"){
		paymethod = 1;
		
		var cardNumList = document.getElementsByClassName("cardNum");
		if(cardNumList[0].value==""||cardNumList[1].value==""||cardNumList[2].value==""||cardNumList[3].value=="")
			alert("�Է�â�� ä�켼��.");
		else{
			$.ajax({
		        method : 'POST',
		        url : './BuyTicket.jsp',
		        data : {
		     	   paymethod : paymethod
		        },
		        success: function(data){
					alert("���� �Ϸ��Ͽ����ϴ�!");
		        }
		      });
		}
	}
	else{
		
		if(document.getElementById("depositPayment").style.display=="block")
			paymethod = 0;
		
		if(paymethod==-1)
			alert("�Է�â�� ä�켼��.");
		else{
			$.ajax({
		        method : 'POST',
		        url : './BuyTicket.jsp',
		        data : {
		     	   paymethod : paymethod
		        },
		        success: function(data){
					alert("������ �Ϸ��Ͽ����ϴ�");
					location.href="./ChooseConditions.jsp";
		        }
		      });
			
		}

	}
}
function cancel(){
   if(confirm("������ ����Ͻðڽ��ϱ�?")){
	   location.href="./CancelPayment.jsp";
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
      
      
      String trainNum = (String)session.getAttribute("trainNumSession");
      System.out.println("train num: "+trainNum);
      
    %>
   </span>��<span><input type='button' value='��������' name='resvBtn' onclick="location.href='ChooseConditions.jsp'">
      <input type='button' value='��������' name='infoBtn' onclick="location.href='InfoManagement.jsp'">
      <input type='button' value='������Ȯ��' name='ticketBtn' onclick="location.href='ResvAndPaymentRecord.jsp'"></span>
   </div>
   
   <div id='main'>
   <h4>������ ����</h4>
   <h4>[<%=(String)session.getAttribute("startSsession")%>�� �� <%=(String)session.getAttribute("arrSsession")%>��]</h4>
   <div id="paymentDiv">
      <div id="leftDiv">
         <span style="border:1px solid black;margin:13px">���� ���� ����</span>
         <div id="paymentInfo" style="font-size:20px;padding:10px">
         <%=session.getAttribute("trainType") %> <br>
         ��� <%=session.getAttribute("startTime") %> - ���� <%=session.getAttribute("endTime") %> <br>
         <%=session.getAttribute("roomNum") %>ȣ�� <%=session.getAttribute("seatNum") %> <br>
         ����<%=session.getAttribute("trainPrice") %> <br>
         </div>
      </div>
      <div id="rightDiv">
         <input type="button" value="�ſ�ī��" id="cardBtn" onclick="showCardPayment()"> 
         <input type="button" value="�������Ա�" id="depoBtn" onclick="showDepoPayment()">
         <div id="cardPayment" style="display:none">
            <br><br><br>
         <p>ī���ȣ</p>
         <input type="text" class="cardNum">
         - <input type="text" class="cardNum">
         - <input type="text" class="cardNum">
         - <input type="text" class="cardNum">
         </div>
         <div id="depositPayment"  style="display:none">
            ���� : NH����<br>
            ������ : ���ϴ�<br><br>
            ���� : 123456-78-123456
         </div>
      </div>
   </div>
   <br><br>
      <input type="button" class="bottomBtn" value="����" onclick="payment()">
      <input type="button" class="bottomBtn" value="���" onclick="cancel()">
   </div>

</body>
</html>