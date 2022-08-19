<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>career</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2"
	crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/writeForm.css">
<link rel="stylesheet" type="text/css" href="/css/main.css" />
<link rel="stylesheet" type="text/css" href="/css/talk.css" />
<script src="/ckeditor/ckeditor.js"></script>
<link rel="stylesheet" type="text/css" href="/css/nav.css" />
<script type="text/javascript">
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
});

//팝업 띄우기
function openWrite() {

 if(!${isLogin}){
	location.href="/career/login";
	return;
}

document.getElementById("writeForm").style.display = "block";
}

//팝업 닫기
function closeWrite() {
$("select[name='category'] option:eq(0)").prop("selected", true); //첫번째 option 선택
$("#btitleSubmit").val("");
CKEDITOR.instances.editor.setData("");
document.getElementById("writeForm").style.display = "none";
}  
</script>
</head>
<body>

	<%-- <jsp:include page="/comp/review" /> --%>

	<jsp:include page="/career/nav" />
	<section class="container">
		<div class="wrapped">
			<h1 class="blind">홈</h1>
			<div role="main" class="contentsTalk">
				<section role="search" class="wrap-srch-home">
					<h1 class="blind">검색</h1>
					<span> <!---->
					</span>
					<form action="/talk/listSearch">
						<input name="btitle" type="search" autocomplete="off" value=""
							class="inp-srch">
						<button type="submit" class="btn-srch">검색</button>
					</form>
				</section>
				<div class="mt-4" style="text-align: -webkit-right;">
					<a href="javascript:openWrite();">
						<button id="wirtePost">글쓰기</button>
					</a>
				</div>
				<div class="home-list">
					<div class="topic-list best">
						<h2>
							<i class="ico"><img
								src="https://d2u3dcdbebyaiu.cloudfront.net/img/web/ico-best.png"
								alt="icon" width="32" height="32"></i> 실시간 베스트
						</h2>
						<c:forEach items="${topicBest }" var="item" end="9">
							<div class="article">
								<span class="topic" style="display:;"><a
									href="/talk/talkDetail?bno=${item.bno}" class="">${item.category }</a></span>
								<a href="/talk/talkDetail?bno=${item.bno}" class="tit ico-img">${item.btitle }</a>
								<div class="wrap-info">
									<!---->
									<a href="/talk/talkDetail?bno=${item.bno}" class="pv"><i
										class="blind">조회수</i>${item.bhits}</a>
									<!---->
								</div>
							</div>
						</c:forEach>
						<a href="/talk/list?category=best" class="btn-more">더보기</a>
						<!---->
					</div>

					<div class="topic-list topic">
						<h2>
							<i class="ico"><img
								src="https://d2u3dcdbebyaiu.cloudfront.net/img/web/topic_logo_kr_1587367050.png"
								alt="icon" width="32" height="32"></i> 잡담
						</h2>
						<c:forEach items="${blahblah }" var="item" end="4">
							<div class="article">
								<span class="topic" style="display: none;"><a
									href="/talk/talkDetail?bno=${item.bno}" class=""></a></span> <a
									href="/talk/talkDetail?bno=${item.bno}" class="tit ">${item.btitle }</a>
								<div class="wrap-info">
									<!---->
									<a href="/talk/talkDetail?bno=${item.bno}" class="pv"><i
										class="blind">조회수</i>${item.bhits }</a>
									<!---->
								</div>
							</div>
						</c:forEach>
						<a href="/talk/list?category=잡담" class="btn-more">더보기</a>
						<!---->
						<!---->
					</div>

					<div class="topic-list topic">
						<h2>
							<i class="ico"><img
								src="https://d2u3dcdbebyaiu.cloudfront.net/img/web/topic_logo_kr_1587367724.png"
								alt="icon" width="32" height="32"></i> 투자
						</h2>
						<c:forEach items="${investmentblah}" var="item" end="4">
							<div class="article">
								<span class="topic" style="display: none;"><a
									href="/talk/talkDetail?bno=${item.bno}" class=""></a></span> <a
									href="/talk/talkDetail?bno=${item.bno}" class="tit ico-file">${item.btitle }</a>
								<div class="wrap-info">
									<!---->
									<a href="/talk/talkDetail?bno=${item.bno}" class="pv"><i
										class="blind">조회수</i>${item.bhits }</a>
									<!---->
								</div>
							</div>
						</c:forEach>
						<a href="/talk/list?category=투자" class="btn-more">더보기</a>
						<!---->
						<!---->
					</div>
					<div class="topic-list topic">
						<h2>
							<i class="ico"><img
								src="https://d2u3dcdbebyaiu.cloudfront.net/img/web/topic_logo_kr_1587367606.png"
								alt="icon" width="32" height="32"></i> 이직·커리어
						</h2>
						<c:forEach items="${careerblah }" var="item" end="4">
							<div class="article">
								<span class="topic" style="display: none;"><a
									href="/talk/talkDetail?bno=${item.bno}" class=""></a></span> <a
									href="/talk/talkDetail?bno=${item.bno}" class="tit ">${item.btitle }</a>
								<div class="wrap-info">
									<!---->
									<a href="/talk/talkDetail?bno=${item.bno}" class="pv"><i
										class="blind">조회수</i>${item.bhits }</a>
									<!---->
								</div>
							</div>
						</c:forEach>
						<a href="/talk/list?category=이직커리어" class="btn-more">더보기</a>
						<!---->
						<!---->
					</div>
					<div class="topic-list topic">
						<h2>
							<i class="ico"><img
								src="https://d2u3dcdbebyaiu.cloudfront.net/img/web/topic_logo_kr_1587367530.png"
								alt="icon" width="32" height="32"></i> 회사생활
						</h2>
						<c:forEach items="${compblah }" var="item" end="4">
							<div class="article">
								<span class="topic" style="display: none;"><a
									href="/talk/talkDetail?bno=${item.bno}" class=""></a></span> <a
									href="/talk/talkDetail?bno=${item.bno}" class="tit ">${item.btitle }</a>
								<div class="wrap-info">
									<!---->
									<a href="/talk/talkDetail?bno=${item.bno}" class="pv"><i
										class="blind">조회수</i>${item.bhits }</a>
									<!---->
								</div>
							</div>
						</c:forEach>
						<a href="/talk/list?category=회사생활" class="btn-more">더보기</a>
						<!---->
						<!---->
					</div>
				</div>
			</div>
			<aside class="aside">
				<div class="lst-ranking">
					<h1>실시간 인기글</h1>
					<div class="inner">
						<c:forEach items="${topicBest }" var="item" end="9"
							varStatus="num">
							<p class="rank">
								<em>${num.count}</em> <a href="/talk/talkDetail?bno=${item.bno}"
									class="">${item.btitle }</a>
							</p>
						</c:forEach>
					</div>
				</div>
			</aside>
		</div>
		<div class="popup_layer" id="writeForm" style="display: none;">
			<div class="popup_box">
				<div style="height: 10px; float: top; position: relative;">
					<a href="javascript:closeWrite();"> <img
						src="/img/ic_close.svg" class="m_header-banner-close" width="50px"
						height="50px" style="position: absolute; right: 15px"></a>
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
					<form action="/user/talk/write" method="post" id="write">
						<input type="hidden" name="${_csrf.parameterName}"
							value="${_csrf.token}" /> <select class="form-select"
							aria-label="Default select example" name="category">
							<option value="">게시판을 선택해주세요</option>
							<option value="잡담">잡담</option>
							<option value="회사생활">회사생활</option>
							<option value="이직커리어">이직커리어</option>
							<option value="투자">투자</option>
						</select> <br>
						<div class="input-group mb-3">
							<input type="text" class="form-control" placeholder="제목을 입력해주세요"
								aria-label="Username" aria-describedby="basic-addon1"
								name="btitle" id="btitleSubmit">
						</div>
						<textarea name="bcontents" id="editor"></textarea>
					</form>
				</div>
				<!--팝업 버튼 영역-->
				<div class="popup_btn"
					style="text-align: center; margin-bottom: 40px;">
					<a href="javascript:closeWrite();"> <input class="pop"
						type="button" value="취소" />
					</a> <input class="pop" type="button" id="btnSubmit" value="작성" />
				</div>
			</div>
		</div>
	</section>
	<jsp:include page="/career/footer"></jsp:include>


</body>
</html>