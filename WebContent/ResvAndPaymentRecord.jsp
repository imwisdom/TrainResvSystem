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
  	Member member = (Member)session.getAttribute("member");
   
   	ArrayList<Integer> payNumList = (ArrayList<Integer>)session.getAttribute("payNumList");
   	String payTableStr = "";
   	String resvTableStr = "";
   	if (payNumList!=null && payNumList.size()!=0){
   		payTableStr = getPayTableValue(Payment.removePayList(payNumList), member.id);
   		session.removeAttribute("payNumList");
   	}
   	else {
   		payTableStr = getPayTableValue(Payment.showPayList(), member.id);
   	}
   	ArrayList<Payment> a = Payment.showTicketList();

   	resvTableStr = getResvTableValue(a, member.id);

   %>
   <%!
   	public static String getResvTableValue(ArrayList<Payment> resvList, String userid){
	   	ArrayList<Payment> resvRecord = resvList;
		
		if(resvRecord == null)
			return "탑승 전 승차권이 없습니다.";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String str = "";

		//resv table에 들어갈 내용 저장
		String resvTableStr = "<thead><tr><th>기차번호</th><th>기차종류</th><th>출발시간</th>"
			+"<th>도착시간</th><th>출발역</th><th>도착역</th><th>날짜</th>"
			+"<th>호실</th><th>좌석번호</th></tr></thead><tbody id='resvTableBody'>";

		Object[] resvTableValue = new Object[9];

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			//resv table에 들어갈 내용 저장
			
			for(int i=0;i<resvRecord.size();i++){
				
				String sql = "select*from se_termp.resv where num="+resvRecord.get(i).resvNum+" and user_id='"+userid+"'";

				pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery();
				
				boolean hasNext = rs.next();
				
				if(!hasNext){
					continue;
				}
				else{
					int trainNum = rs.getInt("train_num");
					int trainRoomNum = rs.getInt("train_room_num");
					String seatNum = rs.getString("seat_num");
					resvTableValue[7] = trainRoomNum;
					resvTableValue[8] = seatNum;
					
					sql = "select*from se_termp.train where num="+trainNum;
					
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					
					hasNext = rs.next();
					
					if(!hasNext){
						continue;
					}
					else{
						int trainNum2 = rs.getInt("num");
						String trainType = rs.getString("t_type");
						Time startTime = rs.getTime("start_time");
						Time endTime = rs.getTime("end_time");
						String startStation = rs.getString("start_station");
						String arrStation = rs.getString("end_station");
						java.sql.Date startDate = rs.getDate("t_date");
						
						resvTableValue[0] = trainNum2;
						resvTableValue[1] = trainType;
						resvTableValue[2] = startTime;
						resvTableValue[3] = endTime;
						resvTableValue[4] = startStation;
						resvTableValue[5] = arrStation;
						resvTableValue[6] = startDate;
						
						resvTableStr = resvTableStr+"<tr>";
						for(int j=0;j<resvTableValue.length;j++){
							resvTableStr = resvTableStr+"<td>"+resvTableValue[j]+"</td>";
						}
						resvTableStr = resvTableStr+"<td><input type=button value='취소' style='background-color:#f5d87f;border: 1px solid black' onclick=removeResvList('"+resvRecord.get(i).payNum+"')></td></tr>";
					}
				}
			}
			if(!resvTableStr.contains("<td>"))
				return "탑승 전 승차권이 없습니다.";
			return resvTableStr+"</tbody>";
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		return "탑승 전 승차권이 없습니다.";
	
   }
   %>
   <%!
    public static String getPayTableValue(ArrayList<Payment> paymentList, String userid){

		ArrayList<Payment> payRecord = paymentList;	
		if(payRecord==null)
			return "결제 내역이 존재하지 않습니다.";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String str = "";
		
		//pay table에 들어갈 내용 저장
		String payTableStr = "<thead><tr>"
					+"<th>결제일자</th><th>기차번호</th><th>기차종류</th><th>출발시간</th>"
					+"<th>도착시간</th><th>호실</th><th>좌석</th><th>결제수단</th>"
					+"<th>가격</th><th>취소</th></tr></thead><tbody id='payTableBody'>";
		Object[] payTableValue = new Object[9];

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			//pay table에 들어갈 내용 저장
			for(int i=0;i<payRecord.size();i++){
				payTableValue[0] = payRecord.get(i).payDate;
				if(payRecord.get(i).payMethod==1)
					payTableValue[7] = "신용카드";
				else payTableValue[7] = "무통장입금";
				
				String sql = "select*from se_termp.resv where num="+payRecord.get(i).resvNum+" and user_id='"+userid+"'";
				
				pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery();
				
				boolean hasNext = rs.next();
				
				if(!hasNext){
					continue;
				}
				else{
					int trainNum = rs.getInt("train_num");
					int trainRoomNum = rs.getInt("train_room_num");
					String seatNum = rs.getString("seat_num");
					payTableValue[1] = trainNum;
					payTableValue[5] = trainRoomNum;
					payTableValue[6] = seatNum;
					
					sql = "select*from se_termp.train where num="+trainNum;
					
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					
					hasNext = rs.next();
					
					if(!hasNext){
						continue;
					}
					else{
						String trainType = rs.getString("t_type");
						Time startTime = rs.getTime("start_time");
						Time endTime = rs.getTime("end_time");
						int price = rs.getInt("price");
						payTableValue[2] = trainType;
						payTableValue[3] = startTime;
						payTableValue[4] = endTime;
						payTableValue[8] = price;
						
						payTableStr = payTableStr+"<tr>";
						for(int j=0;j<payTableValue.length;j++){
							payTableStr = payTableStr+"<td>"+payTableValue[j]+"</td>";
						}
						payTableStr = payTableStr+"<td><input type=checkbox id="+payRecord.get(i).payNum+"check></td></tr>";
					}
					
				}
			}
			if(!payTableStr.contains("<td>"))
				return "결제 내역이 존재하지 않습니다.";
			return payTableStr+"</tbody>";
	
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		return "결제 내역이 존재하지 않습니다.";
    }
    %>
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

<title>Resv And Payment Record Page</title>
<style>
   span:nth-child(2){ 
      position:absolute;
      right:50px;
    }
    span:nth-child(2)>input { width: 100px; margin:3px;}
    span:nth-child(2)>input:nth-child(3) {background-color: rgb(255,231,154);}
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
    #recordDiv{
    	text-align:center;
    }
    #leftDiv, #rightDiv{
    	display: inline-block;
    }
    #paymentRecord, #resvRecord{
    	width:700px;
    	height:500px;
    	border:1px solid black;
    	margin:10px;
    	background-color: #FFFFFF;
    	
    }
    #removeBtn{
    	float:right;
    	background-color:#F7D358;
    	border:1px solid black;
    	margin: 5px;
    }
    th{
    	background-color:#2E9AFE;
    }
    td{
    	background-color:#E0F8F1;
    }
    td, th{
    	border: 1px solid black;
    }
    table{
    	position: absolute;
    	padding: 20px;
    	top:250px;
    	font-size:17px;
    }
    #payTable{
    	left: 180px;
    }
    #resvTable{
    	left: 900px;
    }
    
   
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script>
function removePayList(){

	var checkboxs = $("[id$=check]");
	if(checkboxs.length==0)
		alert("삭제할 결제내역이 없습니다.");
	else{
		if(confirm("정말 삭제하시겠습니까?")){

			var payNumArr = "";
			for(var i=0;i<checkboxs.length;i++){
				if(!checkboxs[i].checked) continue;
				else{
					payNumArr = payNumArr + checkboxs[i].getAttribute('id');
				}
			}
			if(payNumArr=="")
				alert("삭제할 결제내역이 없습니다.");
			else{
				$.ajax({
			        method : 'POST',
			        url : './RemovePayList.jsp',
			        data : {
			     	   payNumArr : payNumArr
			        },
			        success: function(data){
			        	location.href="./ResvAndPaymentRecord.jsp";
			        }
			      });
			}
		}
	}
}
function removeResvList(payNum){

	if(confirm("결제를 취소하시겠습니까?")){
		$.ajax({
	        method : 'POST',
	        url : './RemoveResvList.jsp',
	        data : {
	     	   payNum : payNum
	        },
	        success: function(data){
	        	alert(data.substr(data.indexOf("canceled:")+8));
	        	location.href="./ResvAndPaymentRecord.jsp";
	        }
	      });
	}
	
}
</script>
</head>
<body>
   <div id='top'>
   <span> 
   <%
		out.print(member.id);
		session.setAttribute("member", member);

    %>
   </span>님<span><input type='button' value='기차예매' name='resvBtn' onclick="location.href='ChooseConditions.jsp'">
      <input type='button' value='개인정보' name='infoBtn' onclick="location.href='InfoManagement.jsp'">
      <input type='button' value='승차권확인' name='ticketBtn' onclick="location.href='ResvAndPaymentRecord.jsp'"></span>
   </div>
   
   <div id='main'>
   <div id="recordDiv">
   	<div id="leftDiv">
   		<h4>결제내역</h4>
   		<div id="paymentRecord">
   		<input type="button" id="removeBtn" value="삭제" onclick="removePayList()">
   		<table id="payTable">
   				<%=payTableStr%>
   		</table>
   		</div>
   	</div>
   	<div id="rightDiv">
   		<h4>탑승 전 결제 내역</h4>
   		<div id="resvRecord">
   		<table id="resvTable">
   				<%=resvTableStr%>
   		</table>
   		</div>
   	</div>
   </div>
   </div>

</body>
</html>