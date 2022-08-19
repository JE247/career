<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Jua&family=Nanum+Gothic+Coding&family=Noto+Sans+KR:wght@500&display=swap" rel="stylesheet">

<script>
$(function(){
	$(".table tr").click(function(){
		var tr = $(this); 
		var td = tr.children();
		
		var cname = td.eq(1).text();
		
		if(cname == "회사명"){
			return;
		}
		
		opener.setChildValue(cname);
		window.close();
	});
});
</script>
<style>
    * {
        margin: 0px;
        padding: 0px;
    }
    .container {
        margin: 10px auto;
    }
    .contents {
        margin: 40px 10px;
        text-align: center;
    }
    .search lable{
    	font-family: 'Do Hyeon', sans-serif;
    	font-size: 20px;
    	margin-right: 10px;
    }
    #keyword { 
    	border-radius: 7px;
    	border : 1px solid gray;
    	font-size: 20px;
    }
    .table{
    	font-size:13px;
    	vertical-align: middle;
    }
    .table th{
    	font-family: 'Jua', sans-serif;
    }
    .table td{
    	font-family: 'Noto Sans KR', sans-serif;
    }
    .formbutton{
        border: 0;
        outline: 0;
        background: #007bff;
        filter: drop-shadow(0px 4px 4px rgba(0, 0, 0, 0.25));
        border-radius: 7px;
        color: #FFFFFF;
        margin-left: 20px;
        width: 80px;
        height: 35px;
        font-size: 14px;
    }
</style>
<title>Career</title>
</head>
<body>
<div class="container">
	<div class="contents">
		<div class="search">
			<form action="">
				<lable>회사명 : </lable>
				<input type="text" name="keyword" id="keyword" />
				<input type="button" class="formbutton" value="검색" />
			</form>
		</div>
		<br>
		<table class="table table-hover">
			<tr>
				<th width="20%">사업자 <br> 등록번호</th>
				<th width="80%">회사명</th>
			</tr>
			<c:forEach var="vo" items="${cList}">
				<tr>
					<td>${vo.cnum}</td>
					<td style="text-align: left">${vo.cname}</td>
				</tr>
			</c:forEach>
		</table>
	</div>
</div>
</body>
</html>