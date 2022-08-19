<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<link rel="stylesheet" href="/css/main.css" />
<link rel="stylesheet" type="text/css" href="/css/reviewWrite.css" />
<link rel="stylesheet" href="/css/result.css" />

<script>

let local;
let name = '서울특별시';

var checkedArray = new Array();

<c:forEach var="item" items="${local }">
	checkedArray.push("${item}");
</c:forEach>

$(function(){
	for(var i=0; i<checkedArray.length; i++){
		let text = "<span class='checkLocal'>"+checkedArray[i]+"</span>";
		$("#selectVal").append(text + " ");
	}
	
	$(".checkLocal").css("border","1px solid #cccccc").css("border-radius", "25px")
		.css("font-size", "12px").css("padding", "10px").css("display","inline-block").css("margin-right","10px");
});
function selectCode(t){
	let choice = name + " > " + $(t).parent().text().trim();
	
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
	
	console.log(sido +" : " + sidoname);
	
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

function getPage(cp){
	$("input[name='page']").val(cp);
	
	$("form").submit();
}

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
	
	<%-- 	<h2>${searchWord }</h2> --%>
	<%-- 	${ResultCount } --%>
	<jsp:include page="/career/nav" />
	<!-- Banner -->
	<div class="banner-image"
		style="padding: 10px; width: 100%; height: 400px; position: relative;">
		<div class="search" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);">
			<form action="/career/result">
				<input type="hidden" name="page" />
				<input id="searchtext" type="text" name="searchText"
					placeholder="관심있는 회사명을 검색하세요" value="${searchWord}">
				<div class="btn-group" role="group" style="display: none;"
					id="noneDiv">
					<div id="selectVal"></div>
					<div id="selectSido">
						<ul>
							<c:forEach items="${sidoList}" var="sido">
								<li><a class="dropdown-item" data-value="${sido.sido}"
									href="javascript:code(${sido.sido}, '${sido.sidoname}')">
										${sido.sidoname } </a></li>
							</c:forEach>
						</ul>
					</div>
					<div id="localResult">
						<div class="checkboxSigungu-11">
							<ul class="sigungubox" id="resultBox">
								<li class="value">
								<c:set var="loop_flag" value="false" />
								<c:forEach items="${code }" var="c">
									<c:choose>
									<c:when test="${fn:contains(c, 11000)}">
										<input id="checkbox" type="checkbox" name="checkCode" checked="checked" onchange="selectCode(this);" value="11000" />전체</li>
										<c:set var="loop_flag" value="true" />
									</c:when>
									</c:choose>
								</c:forEach>
								<c:if test="${!loop_flag}">
									<input id="checkbox" type="checkbox" name="checkCode" onchange="selectCode(this);" value="11000" />전체</li>
								</c:if>
								<c:forEach items="${sigunguList11 }" var="sigungu">
									
									<c:set var="loop_flag" value="false" />
									<c:set var="checked" value="11${sigungu.sigungu }" />
										<c:forEach items="${code }" var="c">
											<c:choose>
											<c:when test="${fn:contains(c, checked)}">
												<li class="value">
													<input id="checkbox" type="checkbox" name="checkCode" checked="checked" 
													onchange="selectCode(this);" value="11${sigungu.sigungu}" />${sigungu.sigunguname }
												</li>
												<c:set var="loop_flag" value="true" />
											</c:when>
											</c:choose>
										</c:forEach>
										<c:if test="${!loop_flag}">
											<li class="value">
													<input id="checkbox" type="checkbox" name="checkCode" 
													onchange="selectCode(this);" value="11${sigungu.sigungu}" />${sigungu.sigunguname }
											</li>
										</c:if>
								</c:forEach>
							</ul>
						</div>
						<c:forEach var="map" items="${sigunguListAll}">
							<div class="checkboxSigungu-${map.key}" style="display: none;">
								<ul class="sigungubox" id="resultBox">
									<li class="value">
									<c:set var="loop_flag" value="false" />
									<c:set var="checkedAll" value="${map.key }000" />
									<c:forEach items="${code }" var="c">
										<c:choose>
										<c:when test="${fn:contains(c, checkedAll)}">
											<input id="checkbox" type="checkbox" name="checkCode" checked="checked" onchange="selectCode(this);" value="${map.key}000" />전체</li>
											<c:set var="loop_flag" value="true" />
										</c:when>
										</c:choose>
									</c:forEach>
									<c:if test="${!loop_flag}">
										<input id="checkbox" type="checkbox" name="checkCode" onchange="selectCode(this);" value="${map.key}000" />전체</li>
									</c:if>
									<c:forEach items="${map.value }" var="sigungu">
										<c:set var="loop_flag" value="false" />
										<c:set var="checked" value="${map.key }${sigungu.sigungu}"/>
										<c:forEach items="${code }" var="code">
									        <c:if test="${code eq checked}">
									        	<li class="value">
													<input type="checkbox" checked="checked" name="checkCode" onchange="selectCode(this);" value="${map.key}${sigungu.sigungu}" />
													${sigungu.sigunguname }
												</li>
									            <c:set var="loop_flag" value="true" />
									        </c:if>
										</c:forEach>
										<c:if test="${!loop_flag}">
											<li class="value">
													<input id="checkbox" type="checkbox" name="checkCode" 
													onchange="selectCode(this);" value="${map.key}${sigungu.sigungu}" />${sigungu.sigunguname }
											</li>
										</c:if>
									</c:forEach>
								</ul>
							</div>
						</c:forEach>
					</div>
				</div>
				<a href="javascript:searchComp();"><img
					src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"
					class="searchIcon"></a> <a href="javascript:onDisplay();"><img
					src="https://cdn-icons-png.flaticon.com/512/67/67347.png" alt=""
					class="locFilter" /></a>
			</form>
		</div>
	</div>
	<div class="container">
		<h2>"${searchWord }"에 대한 검색결과 (${ResultCount })건</h2>
		<%-- <table class="table">
			<tr>
				<th>로고</th>
				<th>이름</th>
				<th>사업자등록번호</th>
			</tr>

			<c:forEach items="${Result }" var="list">
				<tr>
					<td><img src="${list.cphoto }" alt="" /></td>
					<td><a href="/comp/compDetail?cno=${list.cno}">${list.cname }</a></td>
					<td>${list.cnum }</td>
				</tr>
			</c:forEach>
		</table> --%>

		<div class="sc-iJKOTD klJDBn">
			<c:forEach items="${Result }" var="list">
				<article class="sc-kfPuZi edErFA">
					<a data-attribute-id="company__click"
						data-company-name="${list.cname }" data-theme="검색결과"
						href="/comp/compDetail?cno=${list.cno}">
						<div class="sc-ieecCq dWbDCl">
							<c:if test="${list.cphoto eq null}">
								<img src="/img/nologo.png" class="noLogo">
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
			</c:forEach>

		</div>
	</div>
	<div id="page" style="margin-top: 30px;">
		<nav aria-label="Page navigation example" >
			<ul class="pagination">
				<li class="page-item"><c:if test="${prev}">
						<a class="page-link" href="/career/result?page=${cp - 10}"
							aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
						</a>
					</c:if></li>
				<c:forEach begin="${startNum}" end="${endNum}" step="1" var="i">
					<c:if test="${cp eq i }">
						<li class="page-item active" aria-current="page"><span
							class="page-link">${i }</span></li>
					</c:if>
					<c:if test="${cp ne i }">
						<li class="page-item"><a class="page-link" href="#"
							onclick="getPage(${i});">${i}</a></li>
					</c:if>
				</c:forEach>
				<li class="page-item"><c:if test="${next}">
						<a class="page-link" href="#"
							onclick="getPage(${cp+10});" aria-label="Next"> <span aria-hidden="true">&raquo;</span>
						</a>
					</c:if></li>
			</ul>
		</nav>
	</div>
	<jsp:include page="/career/footer"></jsp:include>


</body>
</html>