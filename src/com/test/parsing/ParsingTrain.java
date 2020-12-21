package com.test.parsing;

import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLEncoder;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.test.daoclass.Train;

public class ParsingTrain {

	private static String serviceKey = "477QRGhLZqWr08H4z73EqFRfSzfJp3uiNkgf2Ys1B%2BHZwfpCfulVe4CvGDw%2FcxxnNvPy3PDyDASF52K1rgGA9A%3D%3D";

	public static void main(String args[]) throws IOException, SAXException, ParserConfigurationException {
		
		HashMap<String, String> hash = getTrainCodeArray();
		ArrayList<String> code = new ArrayList<String>();
		
		code.add(hash.get("서울"));
		code.add(hash.get("대전"));
		code.add(hash.get("부산"));
		
		for(int i=0;i<3;i++) {
			for(int j=0;j<3;j++) {	
				if(i==j) continue;
				for(int h=14;h<=16;h++) {
					System.out.println(code.get(i)+", "+code.get(j)+", 201912"+h+", 00");
					makeTrainDB(code.get(i), code.get(j), "201912"+h, "KTX");
					makeTrainDB(code.get(i), code.get(j), "201912"+h, "무궁화");
				}
				
			}
		}
		updatePrimaryKeyInTrainDB();
		
	}
	private static void updatePrimaryKeyInTrainDB() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String str = "";

		try{
			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
			String dbId = "root";
			String dbPass = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
			
			String sql = "select*from se_termp.train";
			
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			boolean hasNext = rs.next();
			
			if(!hasNext){
		
			}
			else{
				int i = 0;
				while(hasNext) {
					String num = rs.getString("num");
					System.out.println(num+" -> "+i);
				
					String sq2l = "update se_termp.train set num='"+i+"' where num='"+num+"'";
					PreparedStatement pstmt2 = conn.prepareStatement(sq2l);
					int r2s = pstmt2.executeUpdate();
					
					hasNext = rs.next();
					i++;
					
				}

			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
			if(conn!=null) try{conn.close();}catch(SQLException sqle){}
		}
		
		//이거 다 돌리고 alter table train modify num int(10);실행

	}

	public static Time stringToTime(String str) throws ParseException {

		Date date = new SimpleDateFormat("HHmmss").parse(str);
		Time t = new Time(date.getTime());
		return t;
	}
	public static void makeTrainDB(String startID, String endID, String date, String type) throws IOException, SAXException, ParserConfigurationException{
		
		if(startID.equals(endID)) return;
		String typeCode = "00";
		if(type.equals("무궁화")) typeCode ="02";
			
		StringBuilder urlBuilder = new StringBuilder("http://openapi.tago.go.kr/openapi/service/TrainInfoService/getStrtpntAlocFndTrainInfo"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+serviceKey); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("80", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지 번호*/
        urlBuilder.append("&" + URLEncoder.encode("depPlaceId","UTF-8") + "=" + URLEncoder.encode(startID, "UTF-8")); /*출발기차역ID*/
        urlBuilder.append("&" + URLEncoder.encode("arrPlaceId","UTF-8") + "=" + URLEncoder.encode(endID, "UTF-8")); /*도착기차역ID*/
        urlBuilder.append("&" + URLEncoder.encode("depPlandTime","UTF-8") + "=" + URLEncoder.encode(date, "UTF-8")); /*출발일*/
        urlBuilder.append("&" + URLEncoder.encode("trainGradeCode","UTF-8") + "=" + URLEncoder.encode(typeCode, "UTF-8")); /*차량종류(KTX,무궁화)*/
        URL url = new URL(urlBuilder.toString());
        System.out.println(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();

        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
     	DocumentBuilder documentBuilder = factory.newDocumentBuilder();
     	Document document = documentBuilder.parse(new InputSource(new StringReader(sb.toString())));
        System.out.println(sb);
     	if(!sb.toString().contains("charge"))
     		return;
     	Element root = document.getDocumentElement();

     	NodeList item = root.getElementsByTagName("item");
     	
     	for(int j=0;j<item.getLength();j++) {
     		
     		NodeList anItemList = item.item(j).getChildNodes();
     		
     		String charge = anItemList.item(0).getTextContent();
     		if(charge.equals("0")) continue;
     		String arr = anItemList.item(1).getTextContent();
     		String arrDataAndTime = anItemList.item(2).getTextContent();
     		String dep = anItemList.item(3).getTextContent();
     		String depDataAndTime = anItemList.item(4).getTextContent();
     		String trainType = anItemList.item(5).getTextContent();
     		
     		Connection sqlconn = null;
    		PreparedStatement pstmt = null;

    		try{
    			String jdbcUrl = "jdbc:mysql://localhost:3307/se_termp?serverTimezone=Asia/Seoul&useSSL=false";
    			String dbId = "root";
    			String dbPass = "1234";
    			Class.forName("com.mysql.cj.jdbc.Driver");
    			sqlconn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
    			
    			String sql = "insert into se_termp.train (t_type, start_time, end_time, lead_time, start_station, end_station, price, t_date) values(?,?,?,?,?,?,?,?)";
    			pstmt = sqlconn.prepareStatement(sql);
    			
    			pstmt.setString(1, trainType);
    			
    			Time startT = stringToTime(depDataAndTime.substring(8));
    			Time endT = stringToTime(arrDataAndTime.substring(8));
    			
    			if(startT.getTime()>endT.getTime()) continue;
    			
    			pstmt.setTime(2, startT);
    			pstmt.setTime(3, endT);
    			
    			Date startDate = new SimpleDateFormat("yyyyMMddHHmmss").parse(depDataAndTime);
    			Date endDate = new SimpleDateFormat("yyyyMMddHHmmss").parse(arrDataAndTime);

    			int leadTime = (int) ((endDate.getTime()-startDate.getTime()))/60000;
    			String leadTimeString = String.format("%02d", leadTime/60)+String.format("%02d", leadTime%60)+"00";

    			pstmt.setTime(4, stringToTime(leadTimeString));
    			pstmt.setString(5, dep);
    			pstmt.setString(6, arr);
    			pstmt.setInt(7, Integer.parseInt(charge));
    			
    			Date arrDate = new SimpleDateFormat("yyyyMMdd").parse(date);
    			System.out.println(arrDate);
    			pstmt.setDate(8, new java.sql.Date(arrDate.getTime()));
    			
    			int r = pstmt.executeUpdate();
    			System.out.println("good");
  
    		}catch(Exception e){
    			e.printStackTrace();
    		}finally{
    			if(pstmt!=null) try{pstmt.close();}catch(SQLException sqle){}
    			if(sqlconn!=null) try{sqlconn.close();}catch(SQLException sqle){}
    		}
     		
     		//이 정보들을 mysql에 집어넣자 이제!
     		System.out.println(charge+", "+arr+", "+arrDataAndTime+", "+dep+", "+depDataAndTime+", "+trainType);
     	}
		
	}
	public static HashMap<String, String> getTrainCodeArray() throws IOException, SAXException, ParserConfigurationException{
		HashMap<String, String> map = new HashMap<String, String>();
		int[] codelist = {11, 12, 21, 22, 23, 24, 25, 26, 31, 32, 33, 34, 35, 36, 37, 38};
		
		for(int i=0;i<codelist.length;i++) {
			StringBuilder urlBuilder = new StringBuilder("http://openapi.tago.go.kr/openapi/service/TrainInfoService/getCtyAcctoTrainSttnList"); /*URL*/
	        urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "="+serviceKey); /*Service Key*/
	        urlBuilder.append("&" + URLEncoder.encode("cityCode","UTF-8") + "=" + URLEncoder.encode(Integer.toString(codelist[i]), "UTF-8")); 
	        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("50", "UTF-8")); 
	        
	        URL url = new URL(urlBuilder.toString());
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        BufferedReader rd;
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        System.out.println(sb);
	        rd.close();
	        conn.disconnect();
	        
	        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	     	DocumentBuilder documentBuilder = factory.newDocumentBuilder();
	     	Document document = documentBuilder.parse(new InputSource(new StringReader(sb.toString())));
	     		
	     	Element root = document.getDocumentElement();

	     	NodeList nodeNames = root.getElementsByTagName("nodename");
	     	NodeList nodeIDs = root.getElementsByTagName("nodeid");
	     	
	     	for(int j=0;j<nodeNames.getLength();j++) {
	     		
	     		map.put(nodeNames.item(j).getTextContent(), nodeIDs.item(j).getTextContent());
	     	}
		}
		System.out.println("끝");
     	return map;
	}
	


}
