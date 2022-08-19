<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Career</title>
<link href="https://fonts.googleapis.com/css?family=Roboto:300,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/loginForm/fonts/icomoon/style.css">
<link rel="stylesheet" href="/loginForm/css/owl.carousel.min.css">

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="/loginForm/css/bootstrap.min.css">
<!-- Style -->
<link rel="stylesheet" href="/css/register_style.css">
<link rel="stylesheet" href="/css/register.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Jua&family=Nanum+Gothic+Coding&family=Noto+Sans+KR:wght@500&display=swap" rel="stylesheet">

<script>
document.addEventListener('keydown', function(event) {
	  if (event.keyCode === 13) {
	    event.preventDefault();
	  };
	}, true);
	
	$(function(){
		/* 회사 찾기 */
		$("#searchComp").on("click", function(){
			var popupWidth = 500;
	    	var popupHeight = 500;
	    	var popupX = (window.screen.width / 2) - (popupWidth / 2);
	    	var popupY= (window.screen.height / 2) - (popupHeight / 2);
	    	var url = "/career/register/searchComp";
	    	var name = "searchComp";
	    	var option = "width = 500px, height = 500px, top = "+popupY+", left = "+popupX+", resizable=no, location = no";
	    	
	    	window.open(url, name, option);
		});
		
		/* 가입 폼 전송하기 */
		$("#submitBtn").on("click", function(){
			if($("#inputCompany").val() == ""){
				alert("회사를 선택해주세요");
				return;
			} else if($("#inputNickname").val() == ""){
				alert("닉네임을 입력해주세요");
				return;
			}
			$("form").submit();
		});
	});
	
    function setChildValue(cname){
    	$("#inputCompany").val(cname);
    	$("label[for='inputCompany']").text("");
    }
</script>
<style>
	*{
		margin: 0px;
		padding: 0px;
	}
	form > p{
   	    font-size: 20px;
	   text-align: center;
	   margin: 20px;
	   color: black;
    }
</style>
</head>
<body>
    <div class="container">
	  <div class="d-lg-flex half">
	    <div class="bg order-1" style="background-image: url('/img/register1.png');"></div>
	    <div class="contents order-2 order-md-1">
	      <div class="container">
	        <div class="row align-items-center justify-content-center">
	          <div class="col-md-7" id="contentsWidth">
	            <div class="mb-4" style="text-align: center; margin-left: 20px;">
	              <a href="/career/main"><img src="/img/careerlogo.png" alt="" width="300px" height="150px"/></a>
	            </div>
	            <form action="/career/registerInfo/update" method="post">
	            <p>가입을 위해 추가정보를 입력해주세요</p>
	              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	              <div class="form-group first" style="background: #e9ecef;">
					<label for="inputCompany">회사이름</label> 
					<input type="text" class="form-control" id="inputCompany" name="company" readonly>
				  </div>
				  <input class="btn btn-block btn-primary" type="button" id="searchComp" value="회사찾기" />
				  <div class="form-group last mb-3" style="margin-top: 5px;">
	                <label for="inputNickname">닉네임</label>
	                <input type="text" class="form-control" name="nickname" id="inputNickname">
	              </div>
	              <input type="button" value="가입하기" id="submitBtn" class="btn btn-block btn-primary">
	            </form>
	          </div>
	        </div>
	      </div>
	    </div>
	  </div>
	    <script src="/loginForm/js/main.js"></script>
	</div>	
</body>
</html>