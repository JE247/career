<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css?family=Roboto:300,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/loginForm/fonts/icomoon/style.css">
<link rel="stylesheet" href="/loginForm/css/owl.carousel.min.css">
<link rel="stylesheet" href="/css/forgotPass.css">

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="/loginForm/css/bootstrap.min.css">
<!-- Style -->
<link rel="stylesheet" href="/loginForm/css/style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>	
	$(document).ready(function(){
		// 저장된 쿠키값을 가져와서 ID 칸에 넣어준다. 없으면 공백으로 들어감.
	    var key = getCookie("key");
	    $("#username").val(key); 
	    
	    if(key != ""){
	    	$(".first").addClass("field--not-empty");
	    }
	     
	    // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
	    if($("#username").val() != ""){ 
	        $("#remeberCheck").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
	    }
	     
	    $("#remeberCheck").change(function(){ // 체크박스에 변화가 있다면,
	        if($("#remeberCheck").is(":checked")){ // ID 저장하기 체크했을 때,
	            setCookie("key", $("#username").val(), 7); // 7일 동안 쿠키 보관
	        }else{ // ID 저장하기 체크 해제 시,
	            deleteCookie("key");
	        }
	    });
	     
	    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
	    $("#username").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
	        if($("#remeberCheck").is(":checked")){ // ID 저장하기를 체크한 상태라면,
	            setCookie("key", $("#username").val(), 7); // 7일 동안 쿠키 보관
	        }
	    });
	    
	    
	    $("#btnSearch").on("click", function(){
	    	
	    	let username = $("#inputID").val();
	    	let email = $("#inputEmail").val();
	    	
	    	$.ajax({
				url : '/career/forgotPass',
				data : {
					"${_csrf.parameterName}" : "${_csrf.token}",
					"username" : username,
					"email" : email
				},
				type : "post",
				success : function(data){
					if(data == 1){
						alert("임시 비밀번호를 이메일로 발송하였습니다.");
						$("#forgotPass").hide();
					} else if(data == 0){
						alert("아이디 또는 이메일을 정확히 입력해주세요");
						$("#inputID").val("");
						$("#inputEmail").val("");
					}
				}
	    	});
	    });
	});

	// 쿠키 저장하기 
	// setCookie => saveid함수에서 넘겨준 시간이 현재시간과 비교해서 쿠키를 생성하고 지워주는 역할
	function setCookie(cookieName, value, exdays) {
		var exdate = new Date();
		exdate.setDate(exdate.getDate() + exdays);
		var cookieValue = escape(value)
				+ ((exdays == null) ? "" : "; expires=" + exdate.toGMTString());
		document.cookie = cookieName + "=" + cookieValue;
	}

	// 쿠키 삭제
	function deleteCookie(cookieName) {
		var expireDate = new Date();
		expireDate.setDate(expireDate.getDate() - 1);
		document.cookie = cookieName + "= " + "; expires="
				+ expireDate.toGMTString();
	}
     
	// 쿠키 가져오기
	function getCookie(cookieName) {
		cookieName = cookieName + '=';
		var cookieData = document.cookie;
		var start = cookieData.indexOf(cookieName);
		var cookieValue = '';
		if (start != -1) { // 쿠키가 존재하면
			start += cookieName.length;
			var end = cookieData.indexOf(';', start);
			if (end == -1) // 쿠키 값의 마지막 위치 인덱스 번호 설정 
				end = cookieData.length;
			cookieValue = cookieData.substring(start, end);
		}
		return unescape(cookieValue);
	}
	
	// 패스워드 창 열기
	function openPassword(){
		$("#forgotPass").show();
	}
	// 패스워드 창 닫기
	function closePass(){
		$("#forgotPass").hide();
	}
</script>
<title>Career</title>
</head>
<body>
	<div class="container">
	  <div class="d-lg-flex half">
	    <div class="bg order-1 order-md-2" style="background-image: url('/img/loginImg.png');"></div>
	    <div class="contents order-2 order-md-1">
	
	      <div class="container">
	        <div class="row align-items-center justify-content-center">
	          <div class="col-md-7">
	            <div class="mb-4" style="text-align: center; margin-left: 20px;">
	              <a href="/career/main"><img src="/img/careerlogo.png" alt="" width="250px" height="150px"/></a>
	            </div>
	            <p id="mb-4" >${exception}</p>
	            <form action="/login" method="post" style="width:350px;">
	              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> 
	              <div class="form-group first">
	                <label for="username">ID</label>
	                <input type="text" class="form-control" name="username" id="username">
	              </div>
	              <div class="form-group last mb-3">
	                <label for="password">Password</label>
	                <input type="password" class="form-control" name="password" id="password">
	              </div>
	              
	              <div class="d-flex mb-5 align-items-center">
	                <label class="control control--checkbox mb-0"><span class="caption">Remember me</span>
	                  <input type="checkbox" id="remeberCheck" />
	                  <div class="control__indicator"></div>
	                </label>
	                <span class="ml-auto"><a href="/career/register" class="forgot-pass">Go to Register</a></span> 
	                <span class="ml-auto"><a href="javascript:openPassword();" class="forgot-pass">forgot-password</a></span> 
	              </div>
	
	              <input type="submit" value="Log In" class="btn btn-block btn-primary">
	
	              <span class="d-block text-center my-4 text-muted">&mdash; or &mdash;</span>
	              
	              <div class="social-login">
	                <a href="/oauth2/authorization/google" class="google btn d-flex justify-content-center align-items-center">
	                  <!-- <span class="icon-google mr-3"></span> Login with  Google -->
	                  <img class="loginIcon" src="/loginForm/images/googleIcon.png" alt="" /> Login with  Google
	                </a>
	                <a href="/oauth2/authorization/naver" class="naver btn d-flex justify-content-center align-items-center">
	                  <img class="loginIcon" src="/loginForm/images/naver.png" alt="" /> Login with Naver
	                </a>
	                <a href="/oauth2/authorization/kakao" class="kakao btn d-flex justify-content-center align-items-center">
	                  <img class="loginIcon" src="/loginForm/images/kakao.png" alt="" /> Login with  Kakao
	                </a>
	              </div>
	            </form>
	          </div>
	        </div>
	      </div>
	    </div>
	  </div>
	    <script src="/loginForm/js/jquery-3.3.1.min.js"></script>
	    <script src="/loginForm/js/popper.min.js"></script>
	    <script src="/loginForm/js/bootstrap.min.js"></script>
	    <script src="/loginForm/js/main.js"></script>
	    
	    <!-- 패스워드 찾기 -->
	    <div class="popup_layer" id="forgotPass" style="display: none;">
	        <div class="popup_box">
	            <div style="height: 10px; float: top; position: relative;">
	                <a href="javascript:closePass();">
	                <img src="/img/ic_close.svg" class="m_header-banner-close" width="50px" height="50px" style="position: absolute; right: 10px"></a>
	            </div>
	            <!--팝업 컨텐츠 영역-->
	            <div class="popup_cont">
	            	<div class="top">
	                	<h4 style="font-family: 'Do Hyeon', sans-serif; color: #9AAEFA; font-size: 35px;">
		                	<img alt="" src="/img/careerlogo.png" width="80px" height="45px">
		                	패스워드 찾기
	                	</h4>
	                	<br>
	                </div>
					<br>
					<div class="input-group mb-3">
						<input type="text" class="form-control" placeholder="아이디를 입력해주세요" id="inputID">
					</div>
					<div class="input-group mb-3">
						<input type="text" class="form-control" placeholder="이메일을 입력해주세요" id="inputEmail">
					</div>
					</form>	
	            </div>
	            <!--팝업 버튼 영역-->
	            <div class="popup_btn" style="text-align: center; margin-bottom: 40px;">
	                <a href="javascript:closePass();">
	                <input class="pop" type="button" value="취소" />
	                </a>
	                <input class="pop" type="button" id="btnSearch" value="찾기" /> 
	            </div>
	        </div>
	    </div>
	</div>	
</body>
</html>