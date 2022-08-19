<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<title>Career</title>
<!-- 구글 아이콘 -->
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0" />
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">

<!-- 구글 웹폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Jua&family=Nanum+Gothic+Coding&family=Noto+Sans+KR:wght@500&display=swap" rel="stylesheet">

<!-- swiper -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css"/>
<script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>

<!-- css link -->
<link rel="stylesheet" type="text/css" href="/css/employList.css" />
<link rel="stylesheet" type="text/css" href="/css/myinfo.css" />
<link rel="stylesheet" href="/css/writeForm.css">

<!-- js link -->
<script type="text/javascript" src="/js/mypage.js"></script>
<script src="/ckeditor/ckeditor.js"></script>
<script>
let originpw = "${info.originpw}";
/* CKEditor 관련 설정 */
window.onload = function() {
	var ckeditor_config = {
		filebrowserUploadUrl: '${pageContext.request.contextPath}/talk/upload?${_csrf.parameterName}=${_csrf.token}',
		//filebrowserUploadMethod : 'form',
		height: 400
	};

	CKEDITOR.replace("editor", ckeditor_config);

	//업로드탭으로 시작 구현
	CKEDITOR.on('dialogDefinition', function(ev) {

		var dialogName = ev.data.name;
		var dialog = ev.data.definition.dialog;
		var dialogDefinition = ev.data.definition;

		if (dialogName == 'image') {
			dialog.on('show', function(obj) {
				this.selectPage('Upload');
			});
		}
	});
};

/* 게시판 작성 유효성 검사하기 */
$(function() {
	$("#btnSubmit").on('click', function() {
		if ($("select[name='category']").val() == "") {
			alert("카테고리를 선택해주세요");
			return;
		} else if ($("#btitleSubmit").val() == "") {
			alert("제목을 입력해주세요");
			$("input[name='title']").focus();
			return;
		}

		$("#write").submit();
		$("#popup_layer").css("display", none);
	});
	
	$("#updateSubmit").on('click', updateSubmit);
});
//채용공고 Scrap 추가하기
function bookmark(book, id) {

	let text = $(book).children("span").html().trim();

	$.ajax({
		url: "/career/employee/ajax",
		data: {
			"id": id,
			"${_csrf.parameterName}": "${_csrf.token}"
		},
		type: "POST",
		success: function(data) {
			if (data == 'delete') {
				alert("채용공고 스크랩이 삭제되었습니다.");
				$(book).children("span").html('bookmark_border');
				location.reload();
			} else if (data == 'insert') {
				alert("채용공고 스크랩이 추가되었습니다.");
				$(book).children("span").html('bookmark');
			} else {
				alert("에러가 발생하였습니다.");
			}
		}

	});
}

function updateForm(bno){
	$.ajax({
		url: "/user/talk/select/ajax",
		data: {
			"bno": bno,
			"${_csrf.parameterName}": "${_csrf.token}"
		},
		type: "POST",
		success: function(data) {
			let result = JSON.parse(data);
			
			CKEDITOR.instances.editor.setData(result.contents);
			$("select[name='category']").val(result.category).prop("selected", true);
			$("#btitleSubmit").val(result.title);
			$("input[name='bno']").val(bno);
			$("#updateWrite").show();
		}
	});
}

function updateSubmit(){
	
	let bno = $("input[name='bno']").val();
	let category = $("select[name='category']").val();
	let title = $("input[name='btitle']").val();
	let bcontents = CKEDITOR.instances.editor.getData();
	
	$.ajax({
		url: "/user/talk/update",
		data: {
			"bno": bno,
			"category" : category,
			"btitle" : title,
			"bcontents": bcontents,
			"${_csrf.parameterName}": "${_csrf.token}"
		},
		type: "POST",
		success: function(data) {
			location.reload();
		}
	});
}

function deleteForm(bno){
	$.ajax({
		url: "/user/talk/delete/ajax",
		data: {
			"bno": bno,
			"${_csrf.parameterName}": "${_csrf.token}"
		},
		type: "POST",
		success: function(data) {
			location.reload();
		}
	});
}

function closeWrite(){
	$("#updateWrite").hide();
}
</script>
</head>
<body>
	<jsp:include page="/career/nav"></jsp:include>
	<div class="container">
		<div class="mycontents">
		<div class="myinfo">
			<div class="image">
				<img src="/img/profile.png" alt="" />
			</div>
			<a href="#" onclick="infoUpdate();">
				<p style="text-align: right; width: 85%;">
					<span class="material-symbols-outlined"> settings </span>
				</p>
			</a>
			<div class="profile">
				<form action="/user/myinfo/update" method="post">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					<input type="hidden" name="mno" value="${info.mno}" />
					<div id="infoTable">
						<div class="mb-3 row">
							<label for="staticNickName" class="col-sm-2 col-form-label title">닉네임 : </label>
							<div class="col-sm-10">
								<input type="text" readonly class="form-control-plaintext"
									 id="staticNickName" value="${info.nickname }">
							</div>
						</div>
						<div class="mb-3 row">
							<label for="staticCompany" class="col-sm-2 col-form-label title">회사 : </label>
							<div class="col-sm-10">
								<input type="text" readonly class="form-control-plaintext"
									id="staticCompany" value="${info.company }">
							</div>
						</div>
					</div>
					<div id="updateTable">
						<div class="mb-3 row">
						   <label for="inputNickname" class="col-sm-2 col-form-label title">닉네임</label>
						   <div class="col-sm-8">
						     <input type="text" class="form-control" name="nickname" id="inputNickname" value=${info.nickname } style="width: 48%;">
						  </div>
						</div>
						<div class="mb-3 row">
						   <label for="inputCompany" class="col-sm-2 col-form-label title">회사명</label>
						   <div class="col-sm-8" style="display: flex;">
						   	<input type="text" readonly class="form-control" name="company" value=${info.company } id="inputCompany" style="width: 48%;">
						   	<input type="button" value="회사찾기" class="btn btn-outline-info" id="searchCompany" />
						   </div>
						 </div>
						<c:if test="${!isSNS}">
						<div class="mb-3 row">
						   <label for="originpw" class="col-sm-2 col-form-label title">비밀번호</label>
						   <div class="col-sm-8" style="display: flex;">
						   	<input type="password" class="form-control" id="originpw">
						   	<input type="button" value="비밀번호 변경" class="btn btn-outline-info" id="updatePw" />
						   </div>
						 </div>
						<div class="mb-3 row">
						   <label for="originpw" class="col-sm-2 col-form-label title">변경 비밀번호</label>
						   <div class="col-sm-8" style="display: flex;">
						   	<input type="password" class="form-control" name="originpw" id="inputPw" disabled="disabled" style="width: 48%;">
						   </div>
						 </div>
						 </c:if>
						 <div class="mb-3 row" style="display: flex;">
							 <div class="col-sm-8" style="margin: 5px auto;">
							   <input type="button" id="cancleMyInfo" class="btn btn-outline-secondary inputBtn" value="취소하기" />
							   <input type="button" id="updateMyInfo" class="btn btn-outline-success inputBtn" value="수정하기" />
							 </div>
						</div>
					</div>
				</div>
				</form>
			</div>
			<div class="myactive">
				<div class="scrapInfo">
					<p class="activeTitle">기업정보 스크랩</p>
						<c:if test="${compListSize ne 0}">
						<div class="scrapContents">
						<!-- Slider main container -->
						<div class="swiper">
						  <!-- Additional required wrapper -->
					  	  <c:if test="${compListSize > 3}">
						  	<div class="swiper-button-prev"></div>
						  </c:if>
						  <div class="swiper-wrapper">
						    <!-- Slides -->
						    <c:forEach var="item" items="${compList}">
						    <div class="swiper-slide">
						    	<div class="compList">
						    	<a href="/comp/compDetail?cno=${item.cno }">
						    		<div class="compImg">
						    			<img src="${item.cphoto}" alt="" />
						    		</div>
						    	</a>
						    	<div class="compDetail">
						    		<p class="cname">${item.cname} | <span class="clocal">${item.caddrs}</span></p>
						    		
						    		<p class="ccodename">${item.ccodename}</p>
						    	</div>
						    	</div>
						    </div>
						    </c:forEach>
						  </div>
						<c:if test="${compListSize > 3}">
						  <div class="swiper-button-next"></div>
						</c:if>
						</div>
						</div>
						</c:if>
						<c:if test="${compListSize eq 0}">
							<div class="box">
							<p class="aram">등록된 위시리스트 기업이 없습니다.</p>
							</div>
						</c:if>
				</div>
				<br>
				<hr>
				<br>
				<div class="scrapInfo">
					<p class="activeTitle">채용공고 스크랩</p>
					<c:if test="${scrapListSize ne 0 }">
					<a href="#">
						<span class="moreinfo" id="load">
							더보기>
						</span>
					</a>
					<div class="sc-lbhJGD fGChai">
						<div class="sc-fydGpi eOvOTo">
							<c:forEach items="${scrapList}" var="item">
								<div class="sc-hJZKUC gKbwzP">
										<div class="sc-eicpiI cUTTJm">
										<a href="${item.url}" target="_blank" class="sc-ewSTlh kDCGyo">
											${item.title}
											<span class="span-tag-radius">${item.experience}</span>
											<span class="span-tag-radius">${item.education}</span>
										</a>
											<div class="bookmark">
								                <a href="#" onclick="bookmark(this, ${item.id})">
								                    <span class="material-icons" style="color: gold;">
								                    	<c:if test="${item.isBookmark}">
															bookmark	                    	
								                    	</c:if>
						                            </span>
								                </a>
								             </div>
										</div>
										<div class="sc-dkqQuH bCzrjV">
											<div class="sc-ksHpcM GUybE">
												<div class="sc-gXRojI cpwLnU">
													<div>${item.company} · ${item.location}</div>
												</div>
											</div>
											<div class="sc-ksHpcM buSdti">
												<div class="sc-gXRojI cpwLnU">~ ${item.expir}</div>
											</div>
										</div>
								</div>
							</c:forEach>
						</div>
					</div>
					</c:if>
					<c:if test="${scrapListSize eq 0 }">
						<div class="box">
							<p class="aram">스크랩한 채용공고가 존재하지 않습니다.</p>
						</div>
					</c:if>
			</div>
			<br>
			<hr>
			<br>
			<div class="scrapInfo">
				<p class="activeTitle">내가 쓴 기업리뷰</p>
				<c:if test="${reviewListSize ne 0 }">
					<c:forEach var="review" items="${reviewList}">
					<div class="reviewInfo">
				       <div class="reviewwrite">
				            <p class="reviewTitle">${review.title }</p>
				            <pre class="reviewContents"><br>${review.rcontents}</pre>
				       </div>
				       <div class="button">
				        <input type="button" onclick="openPop();" class="btn btn-outline-primary reviewbtn" value="수정"><br>
				        <a href="/user/deleteReview?rno=${review.reviewno }"><input type="button" class="btn btn-outline-primary reviewbtn" value="삭제"></a>
				        </div>
				    </div>
					</c:forEach>
				</c:if>
				<c:if test="${reviewListSize eq 0 }">
					<div class="box">
						<p class="aram">작성한 기업리뷰가 존재하지 않습니다.</p>
					</div>
				</c:if>
			</div>
			<br>
			<hr>
			<br>
			<div class="scrapInfo">
				<p class="activeTitle">내가 쓴 잡담글</p>
				<c:if test="${boardListSize ne 0 }">
					<br>
					<a href="#">
					<span class="moreinfo" id="moreList">
						더보기>
					</span>		
					</a>			
					<br><br>
					<table class="table">
						<tr>
							<th width="15%"></th>
							<th width="40%"></th>
							<th width="15%"></th>
							<th width="30%"></th>
						</tr>
						<c:forEach var="board" items="${boardList}">
						<tr class="boardList">
							<td style="text-align: center;">${board.category}</td>
							<td><a href="/talk/talkDetail?bno=${board.bno}"><span class="reviewTitle">${board.btitle }</span></a></td>
							<td>${board.bregdate}</td>
							<td>
								<div class="boardbutton">
						      	 <input type="button" class="btn btn-outline-primary boardbtn" onclick="updateForm(${board.bno})" value="수정">
						      	 <input type="button" class="btn btn-outline-primary boardbtn" onclick="deleteForm(${board.bno})" value="삭제">
						       </div>
							</td>
						</tr>
						</c:forEach>
					</table>
				</c:if>
				<c:if test="${boardListSize eq 0 }">
					<div class="box">
						<p class="aram">작성한 기업리뷰가 존재하지 않습니다.</p>
					</div>
				</c:if>
			</div>
		</div>
	</div>
	<div class="popup_layer" id="updateWrite" style="display: none;">
        <div class="popup_box">
            <div style="height: 10px; float: top; position: relative;">
                <a href="javascript:closeWrite();">
                <img src="/img/ic_close.svg" class="m_header-banner-close" width="50px" height="50px" style="position: absolute; right: 15px"></a>
            </div>
            <!--팝업 컨텐츠 영역-->
            <div class="popup_cont">
               <!-- <div class="top">
                	<h4 style="font-family: 'Do Hyeon', sans-serif; color: #9AAEFA; font-size: 35px;">
	                	<img alt="" src="/img/careerlogo.png" width="80px" height="45px">
	                	글쓰기
                	</h4>
                	<br>
                </div> -->
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					<input type="hidden" name="bno" />
                <select class="form-select" aria-label="Default select example" name="category">
					<option value="">게시판을 선택해주세요</option>
					<option value="잡담">잡담</option>
					<option value="회사생활">회사생활</option>
					<option value="이직커리어">이직커리어</option>
					<option value="투자">투자</option>
				</select>
				<br>
				<div class="input-group mb-3">
					<input type="text" class="form-control" placeholder="제목을 입력해주세요" aria-label="Username" aria-describedby="basic-addon1" name="btitle" id="btitleSubmit">
				</div>
				<textarea name="bcontents" id="editor"></textarea>
            </div>
            <!--팝업 버튼 영역-->
            <div class="popup_btn" style="text-align: center; margin-bottom: 40px;">
                <a href="javascript:closeWrite();">
                <input class="pop" type="button" value="취소" />
                </a>
                <input class="pop" type="button" id="updateSubmit" value="수정" /> 
            </div>
        </div>
    </div>
	</div>
    <jsp:include page="/career/footer"></jsp:include>
</body>
</html>