<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Career</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2"
	crossorigin="anonymous"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<link rel="stylesheet" href="/css/main.css" />
<link rel="stylesheet" type="text/css" href="/css/reviewWrite.css" />
<link rel="stylesheet" href="/css/creditjobMain.css" />

<script>

let local;
let name = '서울특별시';

var checkedArray = new Array();

function selectCode(t){
	let choice = name + " > " + $(t).parent().text();
	
	var confirm = checkedArray.includes(choice);
	
	if(!confirm){
		checkedArray.push(choice);
		$(t).parent().css("font-weight","bold");
	} else {
		for(var i = 0; i < checkedArray.length; i++){ 
		  if (checkedArray[i] === choice) { 
			  checkedArray.splice(i, 1); 
		    i--; 
		  }
		}
		$(t).parent().css("font-weight","normal");
	}
	
	$("#selectVal").empty();
	
	for(var i=0; i<checkedArray.length; i++){
		let text = "<span class='checkLocal'>"+checkedArray[i]+"</span>";
		$("#selectVal").append(text + " ");
	}
	
	$(".checkLocal").css("border","1px solid #cccccc").css("border-radius", "25px")
		.css("font-size", "12px").css("padding", "10px").css("display","inline-block").css("margin-right","10px");
	
	
}

function code(sido, sidoname){
	
	name = sidoname;
	
	$.ajax({
		url : '/career/main/ajax',
		data : {
			"${_csrf.parameterName}" : "${_csrf.token}",
			"sido" : sido
		},
		type : "post",
		success : function(data){
			
			$("#localResult > div").hide();
			
			let result = JSON.parse(data);
			
			let className = '#localResult .checkboxSigungu-'+sido;
			let flag = document.querySelector(className) != null;
			
			if(flag){
				$(className).show();
			} else {
				let value = `<div class="checkboxSigungu-\${sido}">
								<ul class="sigungubox">
								</ul>
							 </div>`;
				
				$("#localResult").append(value);
				if(sidoname != '세종특별자치시'){
					let all = `<li class="value"><input type="checkbox" onchange="selectCode(this);" name="checkCode" value="\${sido}000"/>전체</li>`;
					
					$(className+"> .sigungubox").append(all);
				}
				
				for(var i=0; i<result.length; i++){
					let li = `<li class="value"><input type="checkbox" onchange="selectCode(this);" name="checkCode" value="\${sido}\${result[i].sigungu}"/>\${result[i].sigunguname}</li>`;
					
					$(className+"> .sigungubox").append(li);
				}
			}
		}
	});
}

function onDisplay(){ 	
    var loc = document.getElementById("noneDiv"); 	
    if(loc.style.display=='none'){ 		
    	loc.style.display = 'block'; 	
    }else{ 		
    	loc.style.display = 'none'; 	
    } 
}

$(function(){
	$("#rankHits").on('click', function(){
		if($("#rankHits").hasClass("dsKyrd")){
			$("#rankHits").toggleClass("dsKyrd");
			$("#rankHits").toggleClass("HPryr");
			$("#rankSals").toggleClass("dsKyrd");
			$("#rankSals").toggleClass("HPryr");

			$("#v-pills-profile").toggleClass("show");
			$("#v-pills-profile").toggleClass("active");
			$("#v-pills-home").toggleClass("show");
			$("#v-pills-home").toggleClass("active");
			
			
		}
	});
	
	$("#rankSals").on('click', function(){
		if($("#rankSals").hasClass("dsKyrd")){
			$("#rankHits").toggleClass("dsKyrd");
			$("#rankHits").toggleClass("HPryr");
			$("#rankSals").toggleClass("dsKyrd");
			$("#rankSals").toggleClass("HPryr");
			
			$("#v-pills-profile").toggleClass("show");
			$("#v-pills-profile").toggleClass("active");
			$("#v-pills-home").toggleClass("show");
			$("#v-pills-home").toggleClass("active");
		}
	});
});

</script>
<script type="text/javascript"> 
        var bDisplay = true; function onDisplay(){ 	
            var con = document.getElementById("noneDiv"); 	
            if(con.style.display=='none'){ 		
                con.style.display = 'flex'; 	
            }else{ 		
                con.style.display = 'none'; 	
            } 
        } 
</script>
</head>
<body>
	<jsp:include page="/career/nav" />
	
		<!-- Banner -->
		<div class="banner-image"
			style="padding: 10px; width: 100%; height: 400px; position: relative;">
			<div class="search"
				style="position: absolute; top: 50%; left: 50%;">
				<form action="/career/result">

					<input id="searchtext" type="text" name="searchText"
						placeholder="회사명을 검색하세요">
					<div class="btn-group" role="group" style="display: none;" id="noneDiv">
					<div id="selectVal"></div>
						<div id="selectSido">
							<ul>
								<c:forEach items="${sidoList}" var="sido">
								<li><a class="dropdown-item" data-value="${sido.sido}"
									href="javascript:code(${sido.sido}, '${sido.sidoname}')">
										${sido.sidoname }
										</a>
									</li>
							</c:forEach>
							</ul>
						</div>
<%-- 						<button id="btnGroupDrop1" type="button"
							class="btn btn-light dropdown-toggle" data-bs-toggle="dropdown"
							aria-expanded="false" >지역을 선택하세요</button>
						<ul class="dropdown-menu" aria-labelledby="btnGroupDrop1">
							<c:forEach items="${sidoList}" var="sido">
								<li><a class="dropdown-item" data-value="${sido.sido}"
									href="javascript:code(${sido.sido}, '${sido.sidoname}')">${sido.sidoname }</a></li>
							</c:forEach>
						</ul> --%>
						<div id="localResult">
							<div class="checkboxSigungu-11">
								<ul class="sigungubox" id="resultBox">
									<li class="value"><input id="checkbox" type="checkbox"
										name="checkCode" onchange="selectCode(this);" value="11000" />전체</li>
									<c:forEach items="${sigunguList }" var="sigungu">
										<li class="value"><input type="checkbox" name="checkCode"
											onchange="selectCode(this);" value="11${sigungu.sigungu}" />${sigungu.sigunguname }</li>
									</c:forEach>
								</ul>
							</div>
						</div>
						
					</div>
					<!-- 					<a href="javascript:searchComp();"><img
						src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"
						class="searchIcon"></a> <a href="javascript:onDisplay();"
						onclick="onDisplay()"> <img
						src="https://cdn-icons-png.flaticon.com/512/67/67347.png" alt=""
						class="locFilter" /></a> -->
					<a href="javascript:searchComp();"><img
						src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"
						class="searchIcon"></a> <a href="javascript:onDisplay();"><img
						src="https://cdn-icons-png.flaticon.com/512/67/67347.png" alt=""
						class="locFilter" /></a>
				</form>

			</div>
		</div>
		<div class="container">
		<div class="d-flex align-items-start" style="width: 1200px; margin: 30px auto; min-height: 300px;">
			<div class="nav flex-column nav-pills me-3" id="v-pills-tab"
				role="tablist" aria-orientation="vertical" style="width: 150px;">
			
			<ul class="sc-iCfMLu HPryr" id="rankHits">
				<div id="outer">
					<div id="inner"></div>
				</div>
				<div id="lower">
					<span data-value="WEEKLY_VIEW_RANK">주간 조회수 TOP</span>
				</div>
			</ul>
			
			<ul class="sc-iCfMLu dsKyrd" id="rankSals">
				<div id="outer">
					<div id="inner"></div>
				</div>
				<div id="lower">
					<span data-value="WEEKLY_VIEW_RANK">연봉순위 TOP</span>
				</div>
			</ul>
				<!-- <button class="nav-link active" id="v-pills-home-tab"
					data-bs-toggle="pill" data-bs-target="#v-pills-home" type="button"
					role="tab" aria-controls="v-pills-home" aria-selected="true">
				
				<div class="mainNav">
					<div class="navInfo">
					조회수 TOP 20
					</div>
					<div class="outer">
						<div class="inner">
						</div>
					</div>
				</div>
				
				</button>
				<button class="nav-link" id="v-pills-profile-tab"
					data-bs-toggle="pill" data-bs-target="#v-pills-profile"
					type="button" role="tab" aria-controls="v-pills-profile"
					aria-selected="false">연봉순위<br>TOP 20</button> -->
					
					
			</div>
			<div class="tab-content" id="v-pills-tabContent">
				<div class="tab-pane fade show active" id="v-pills-home"
					role="tabpanel" aria-labelledby="v-pills-home-tab" tabindex="0">
					<div class="sc-iJKOTD klJDBn">
						<c:set var="rank" value="1" />
						<c:forEach items="${popularList }" var="list">
							<article class="sc-kfPuZi edErFA">
								<a data-attribute-id="company__click"
									data-company-name="${list.cname }" data-rank="1"
									data-theme="주간 조회수 TOP" href="/comp/compDetail?cno=${list.cno}">
									<div class="sc-bkkeKt kRdruU">${rank }</div>
									<div class="sc-ieecCq dWbDCl">
										<c:if test="${list.cphoto eq null}">
											<img alt="${list.cname } logo" src="/img/nologo.png"
												class="logo">
										</c:if>
										<c:if test="${list.cphoto ne null }">
											<img alt="${list.cname } logo" src="${list.cphoto }"
												class="logo">
										</c:if>
									</div>
									<div class="sc-hGPBjI biULBL">
										<p>${list.cname }</p>
										<p>${list.caddrs }<span class="sc-dJjYzT iqtcDe"></span>
										</p>
									</div> <span class="sc-dlVxhl hQTqZU">조회수 : ${list.chits }</span>
								</a>
							</article>
							<c:set var="rank" value="${rank+1}"></c:set>
						</c:forEach>
					</div>
				</div>
				<div class="tab-pane fade" id="v-pills-profile" role="tabpanel"
					aria-labelledby="v-pills-profile-tab" tabindex="0">
					<div class="sc-iJKOTD klJDBn">
						<c:set var="rank" value="1" />
						<c:forEach items="${selectAnnual }" var="list">
							<article class="sc-kfPuZi edErFA">
								<a data-attribute-id="company__click"
									data-company-name="${list.cname }" data-rank="1"
									data-theme="주간 조회수 TOP" href="/comp/compDetail?cno=${list.cno}">
									<div class="sc-bkkeKt kRdruU">${rank }</div>
									<div class="sc-ieecCq dWbDCl">
										<c:if test="${list.cphoto eq null}">
											<img alt="${list.cname } logo" src="/img/nologo.png"
												class="logo">
										</c:if>
										<c:if test="${list.cphoto ne null }">
											<img alt="${list.cname } logo" src="${list.cphoto }"
												class="logo">
										</c:if>
									</div>
									<div class="sc-hGPBjI biULBL">
										<p>${list.cname }</p>
										<p>${list.caddrs }<span class="sc-dJjYzT iqtcDe"></span>
										</p>
									</div> <span class="sc-dlVxhl hQTqZU">평균연봉 : 약 ${list.csal }만원</span>
								</a>
							</article>
							<c:set var="rank" value="${rank+1}"></c:set>
						</c:forEach>
					</div>
				</div>
			</div>
				<div class="sc-jlsrNB eesXGR">
					<h1 class="sc-hUpaCq jbsmCd">스크랩한 기업목록</h1>
					<div class="sc-hKTqa kqvjvC">
						<c:forEach items="${scrapList}" var="scrap" end="4">
							<a
								href="http://localhost:8080/comp/compDetail?cno=${scrap.cno}"
								class="sc-TBWPX gGyLOM"><div class="sc-jIkXHa iVLUBG">
									<div class="sc-ZOtfp fccwNJ">
										<img src="${scrap.cphoto }" alt="" class="sc-jOxtWs jwsFuC">
									</div>
									<div class="sc-bTfYFJ dNBHes">
										<div class="sc-hmjpVf kYnuMv">${scrap.cname }</div>
										<div class="sc-eLwHnm cheqLp">${scrap.caddrs }</div>
									</div>
								</div></a>
						</c:forEach>
						<div class="sc-gHjyzD eTrFyJ">
							<a target="_blank" href="/user/career/mypage"
								class="sc-fXEqDS nRcWr"> <span class="sc-bQtKYq SjeMR">
									<div class="sc-hYQoXb fLJsav">
										<svg width="12" height="15" fill="white"
											viewBox="0 0 12 16" xmlns="http://www.w3.org/2000/svg">
						<path
												d="M0.777279 2.16704V2.16667C0.777279 1.57745 1.25422 1.1 1.83561 1.1H10.1689C10.7542 1.1 11.2356 1.58137 11.2356 2.16667V14.5901L6.23863 12.4485L6.00228 12.3472L5.76593 12.4485L0.769514 14.5898L0.777279 2.16704Z"
												fill="white" stroke="currentColor" stroke-width="1.2"></path></svg>
									</div>스크랩 더보기
							</span>
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	<jsp:include page="/career/footer"></jsp:include>
</body>
</html>