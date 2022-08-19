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
<script>
document.addEventListener('keydown', function(event) {
	  if (event.keyCode === 13) {
	    event.preventDefault();
	  };
	}, true);
	
let idCheck = false;
let emailCheck = false;

let checkCode;

	$(function(){
		
		/* id 중복 체크하기 */
		$("#idCheck").on("click", function(){
			let id = $("#inputId").val();
			
			if(id == ""){
				alert("id를 입력해주세요");
				return;
			}
			
			$.ajax({
				url : '/career/register/ajaxIdCheck',
				data : {
					"${_csrf.parameterName}" : "${_csrf.token}",
					"id" : id
				},
				type : "post",
				success : function(data){
					if(data == 0){
						$("#idResult").html("사용할 수 있는 ID입니다.");
						$("#idResult").css("margin-bottom", "16px").css("color", "green").css("display", "inline-block").css("font-size", "13px").css("font-weight","bold");
						idCheck = true;
					} else {
						$("#idResult").html("이미 사용중인 ID입니다.");
						$("#idResult").css("margin-bottom", "16px").css("color", "red").css("display", "inline-block").css("font-size", "13px").css("font-weight","bold");
						idCheck = false;
					}
				}
			});
		});
		
		$("#inputPwComfirm").on("keyup", function(){
			if($("#inputPw").val() == $("#inputPwComfirm").val()){
				$("#passwordCheck").text("비밀번호가 일치합니다.");
				$("#passwordCheck").css("margin-bottom", "16px").css("color", "green").css("display", "inline-block").css("font-size", "13px").css("font-weight","bold");
			}else {
				$("#passwordCheck").text("비밀번호를 확인해주세요");
				$("#passwordCheck").css("margin-bottom", "16px").css("color", "red").css("display", "inline-block").css("font-size", "13px").css("font-weight","bold");
			}
		});

		/* email 전송하기 */
		$("#emailCheck").on("click", function(){
			
			let email = $("#inputEmail").val();
			var pattern = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
			
			if(email == "" || !pattern.test(email)) {
				alert("올바른 메일주소를 입력해주세요")
				return;
			}
			
			$.ajax({
				url : '/career/register/ajaxEmailCheck',
				data : {
					"${_csrf.parameterName}" : "${_csrf.token}",
					"email" : email
				},
				type : "post",
				success : function(data){
					checkCode = data;
				}
			});
			
			$("#comfirmCheck").show();
		});
		
		/* 인증번호 체크하기 */
		$("#comfirm").on("click", function(){
			let code = $("#inputComfirm").val();
			
			if(code == checkCode){
				$("#emailResult").text("인증이 성공하였습니다.");
				$("#emailResult").css("margin-bottom", "16px").css("color", "green").css("display", "inline-block").css("font-size", "13px").css("font-weight","bold");
				emailCheck = true;
			} else {
				$("#emailResult").text("인증이 실패하였습니다.");
				$("#emailResult").css("margin-bottom", "16px").css("color", "green").css("display", "inline-block").css("font-size", "13px").css("font-weight","bold");
				emailCheck = false;
			}
			
		});
		
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
			if(!idCheck){
				alert("ID 중복체크를 확인해주세요");
				return;
			} else if($("#inputPw").val() == "" || $("#inputPw").val() != $("#inputPwComfirm").val()) {
				alert("Password를 확인해주세요");
				return;
			} else if($("#inputCompany").val() == ""){
				alert("회사를 선택해주세요");
				return;
			} else if(!emailCheck){
				console.log(emailCheck);
				alert("이메일 인증을 진행해주세요");
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
	              <a href="/career/main"><img src="/img/careerlogo.png" alt="" width="250px" height="150px"/></a>
	            </div>
	            <form action="/career/register" method="post">
	              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	              <div class="form-group first">
	                <label for="username">ID</label>
	                <input type="text" class="form-control" name="username" id="inputId">
	              </div>
                  <input class="btn btn-block btn-primary" type="button" id="idCheck" value="중복 체크" />
	              <span id="idResult"></span>
	              <div class="form-group last mb-3" style="margin-top: 5px;">
	                <label for="password">Password</label>
	                <input type="password" class="form-control" name="password" id="inputPw">
	              </div>
	              <div class="form-group last mb-3" style="margin-top: 5px;">
	                <label for="inputPwComfirm">Password-Check</label>
	                <input type="password" class="form-control" id="inputPwComfirm">
	              </div>
	              <span id="passwordCheck"></span>
	              <div class="form-group first">
	                <label for="inputEmail">E-mail</label>
	                <input type="text" class="form-control" id="inputEmail" name="email">
	              </div>
				  <input class="btn btn-block btn-primary" type="button" id="emailCheck" value="메일 인증" />
				  <div id="comfirmCheck" style="display: none;">
					  <div class="form-group first">
		                <label for="inputEmail">인증번호</label>
		                <input type="text" class="form-control" id="inputComfirm" name="EmailCheck">
		              </div>
		              <input class="btn btn-block btn-primary" type="button" id="comfirm" value="인증확인" />
	              </div>
	              <span id="emailResult"></span>
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