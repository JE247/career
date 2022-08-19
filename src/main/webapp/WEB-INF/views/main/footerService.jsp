<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link
	href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Jua&family=Nanum+Gothic+Coding&family=Noto+Sans+KR:wght@500&display=swap"
	rel="stylesheet">
<script>
	function closePop(){
		window.close();
	}
</script>
<style type="text/css">
* {
	margin: 0px;
	padding:0px;
}
/* .header{
	position: relative;
	height: 50px;
	background: #BECFFA;
}
.header > p {
	position: absolute;
	top:15px;
	right: 30px;
	display: inline-block;
	
} */
body{
	text-align: center;
}
img{
	margin: 30px auto;
}
pre{
	font-family: "Noto Sans KR";
	font-size: 14px;
	text-align: left;
}
.dec{
	padding: 25px 50px;
}

button{
	width: 100px;
	height: 40px;
	position: absolute;
	bottom: 50px;
	right: 30px;
	filter: drop-shadow(0px 4px 4px rgba(0, 0, 0, 0.25));
	color: white;
	background: #84A4F6;
	border: none;
}

button:hover{
	background: #466AF6;
}
</style>
<meta charset="UTF-8">
<title>Career</title>
</head>
<body>
<!-- <div class="header">
<p>서비스 소개</p>
<img src="/img/logo.png" alt="" />
</div> -->
<br><br>
<img src="/img/careerlogo.png" alt="" />
<div class="dec">
<pre>
'Career'는 2022년 8월 설립된 스타트업으로, '여러 기업정보를 공유하자!'라는 목표아래 시작되었습니다.

누구나 접근할 수 있는 Career 웹 서비스는
익명으로 접근할 수 있는 사이트로 로그인을 하지 않아도 잡담 게시판이나 기업 정보서비스를 이용하실 수 있습니다.

재직중인 직장인이라면 인증 절차를 거쳐 재직 회사나 동정 업계/직군의 사람들끼리 소통할 수 있으며
관심사 기반의 토픽 채널에서 다양한 사람들과 자유롭게 대화할 수 있습니다.
또한, 기업 리뷰서비스를 통해 해당 기업의 다양한 리뷰를 열람하실 수 있습니다.
</pre>

<button onclick="closePop();">닫기</button>
</div>

</body>
</html>