<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="com.test.daoclass.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date" %>
<%
	ArrayList<Train> trainList = null;
	ArrayList<Integer> tmp = new ArrayList<Integer>();

	boolean isOn = ("on".equals(request.getParameter("value"))) ? true : false;
	int hour = Integer.parseInt((String) session.getAttribute("hoursession"));
	int minute = Integer.parseInt((String) session.getAttribute("minutesession"));
	//int hour = 20;
	//int minute = 45;
	Time time = new Time(hour, minute, 0); // 시간
	Member member = (Member) session.getAttribute("member");
	String user_id = member.id; // user id 
	//String user_id = "Hacker"; // user id 
	java.sql.Date today = new java.sql.Date(System.currentTimeMillis());  // 현재 날짜
	java.sql.Date targetDate = new java.sql.Date(today.getYear(),today.getMonth()-3,today.getDate()); 
	
	session.setAttribute("recoList", false);
	
	// 3 months condition
	Connection conn = null;
	PreparedStatement pstmt = null;

	try {
		String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false&useUnicode=true&characterEncoding=euc_kr";
		String dbId = "root";
		String dbPass = "1234";
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);

		String sql = "SELECT * FROM se_termp.payment where pay_date>?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setDate(1, targetDate);
		System.out.println("** 1 "+pstmt);

		ResultSet rs = pstmt.executeQuery();

		if(rs.next()){
			// Generate random table
			pstmt = null;
			Statement stmt = null;

			try {
				stmt = conn.createStatement();

				StringBuilder sb = new StringBuilder();
				String creatSql = sb.append("create table if not exists se_termp.tmpDB(").append("start_time time")
						.append(");").toString();
				stmt.execute(creatSql);

				// id -> rev_num
				String paymentSql = "SELECT * FROM se_termp.payment WHERE user_id=? and pay_date>?";
				pstmt = conn.prepareStatement(paymentSql);
				pstmt.setString(1, user_id);
				pstmt.setDate(2, targetDate);
				System.out.println("** 2 "+pstmt);

				ResultSet rs1 = pstmt.executeQuery();
				while (rs1.next()) {
					// resv_num -> start_time
					String selectql = "SELECT start_time FROM se_termp.train WHERE num=(SELECT train_num FROM se_termp.resv WHERE num=?)";
					pstmt = conn.prepareStatement(selectql);
					pstmt.setInt(1, rs1.getInt("resv_num"));
					System.out.println("** 3 "+pstmt);

					ResultSet rs2 = pstmt.executeQuery();

					if (rs2.next()) {
						String insertSql3 = "insert into se_termp.tmpDB (start_time) values(?)";
						pstmt = conn.prepareStatement(insertSql3);
						pstmt.setTime(1, rs2.getTime("start_time"));
						System.out.println("** 4 "+pstmt);

						pstmt.executeUpdate();
					}
				}
			}catch(Exception e){
		        e.printStackTrace();
		    }finally{
		        if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
		        if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		    }
			// recommendation
			if (Train.recommendTrain(isOn)) {
				trainList = Train.getRecommendedTrain(Payment.calculateRecommendTrain());
			}
			for (Train t : trainList) {
				tmp.add(t.trainNum);
			}
			session.setAttribute("recoList", tmp);
			

			// remove table 
			pstmt = null;

			try {
				String dropSql = "DROP TABLE  se_termp.tmpDB";
				pstmt = conn.prepareStatement(dropSql);
				pstmt.executeUpdate();

			}catch(Exception e){
		        e.printStackTrace();
		    }finally{
		       	if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
		        if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		    }
		}

	}catch(Exception e){
	        e.printStackTrace();
	}finally{
	       if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
	       if(conn!=null) try{conn.close();}catch(SQLException sqle){}
	}
%>
<%=session.getAttribute("recoList")%>