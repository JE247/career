<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>career</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2"
	crossorigin="anonymous"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">
<script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
<link rel="stylesheet" href="/css/writeForm.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="/ckeditor/ckeditor.js"></script>
<script>
	/* 게시판 작성 유효성 검사하기 */
	$(function() {
		var boardMno = '<c:out value="${board.mno}"/>';
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
		/* 취소버튼 */
		$("input[type='button'][value='취소']").on("click", function() {
			$(".reply-area").val("");
			$(this).blur();
		});

		/* 부모댓글 */
		$("#replySubmit").on("click", function(e) {
			e.preventDefault();
			if(!${isLogin}){
				location.href="/career/login";
				return;
			} 

			if ($(".reply-area").val() == "") {
				alert("내용을 입력해주세요");
				$(this).blur();
				return;
			}
			
			let comment = $(".reply-area").val();
			let bno = $("input[name='bno']").val();
			let mno = $("input[name='mno']").val();		
			let $cdiv = $(".commentDiv");
			let $reply = $(".reply");
			$.ajax({
				url : "./reply",
				data : {
					"bno" : bno,
					"mno" : mno,
					"comment" : comment,
					"status" : 0,
					"${_csrf.parameterName}" : "${_csrf.token}"
				},
				type : "POST",
				success : function(data) {		
					console.log(data);
					location.reload();
				}
			});
		});

		$(".closeReply").on('click', closeReply);
		
		$("#updateSubmit").on('click', updateSubmit);
		
		$("#modifyCancle").on('click', closeModifyReply);
		$("#replyChildCancle").on('click', closeReply);
	});

	/* CKEditor 관련 설정 */
	window.onload = function() {
		var ckeditor_config = {
			filebrowserUploadUrl : '${pageContext.request.contextPath}/talk/upload?${_csrf.parameterName}=${_csrf.token}',
			//filebrowserUploadMethod : 'form',
			height : 400
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

	function updateForm(bno) {
		console.log(bno);

		$.ajax({
			url : "/user/talk/select/ajax",
			data : {
				"bno" : bno,
				"${_csrf.parameterName}" : "${_csrf.token}"
			},
			type : "POST",
			success : function(data) {

				console.log(data);
				let result = JSON.parse(data);

				CKEDITOR.instances.editor.setData(result.contents);
				$("select[name='category']").val(result.category).prop(
						"selected", true);
				$("#btitleSubmit").val(result.title);
				$("input[name='bno']").val(bno);
				$("#updateWrite").show();
			}
		});
	}

	function updateSubmit() {
		let bno = $("input[name='bno']").val();
		let category = $("select[name='category']").val();
		let title = $("input[name='btitle']").val();
		let bcontents = CKEDITOR.instances.editor.getData();

		$.ajax({
			url : "/user/talk/update",
			data : {
				"bno" : bno,
				"category" : category,
				"btitle" : title,
				"bcontents" : bcontents,
				"${_csrf.parameterName}" : "${_csrf.token}"
			},
			type : "POST",
			success : function(data) {
				location.reload();
			}
		});
	}

	function closeWrite() {
		$("#updateWrite").hide();
	}
	function closeReply(){
		$(".replyChild-area").val("");
		$("#replyChild").hide();
	}
	function closeModifyReply(){
		$(".modifyReply-area").val("");
		$("#modifyReply").hide();
	}
	
	function replyDelete(replyNo){
		var boardBno = '<c:out value="${board.bno}"/>';
		console.log(replyNo);
		console.log(boardBno);
		if(confirm("댓글을 삭제하시겠습니까?")){
			$.ajax({
				url : "./deleteReplyOne",
				data : {
					"replyNo" : replyNo,
					"bno" : boardBno,
					"${_csrf.parameterName}" : "${_csrf.token}"
				},
				type : "POST",
				success : function(data) {		
					location.reload();
				}
			})
		}else{
			console.log("취소");
		}
		
	}
	
	function copyLink(){
		var copyurl = '';
		var textarea = document.createElement("textarea");
		document.body.appendChild(textarea);
		url = window.document.location.href;
		textarea.value = url;
		textarea.select();
		document.execCommand("copy");
		document.body.removeChild(textarea);
		alert("URL이 복사되었습니다.")
	}
	
	function childReply(cnt){		
		if(!${isLogin}){
			location.href="/career/login";
			return;
		} 
		$("#replyChild").show();
		
		$("#replyChildSubmit").on("click", function(e) {
			console.log("ㄷㅐ댓글제출")
			if ($(".replyChild-area").val() == "") {
				alert("내용을 입력해주세요");
				return;
			}
			
			e.preventDefault();
			
			let comment = $(".replyChild-area").val();
			let bno = $("input[name='bno']").val();
			let mno = $("input[name='mno']").val();		
			
		
 			$.ajax({
				url : "./replyChild",
				data : {
					"bno" : bno,
					"mno" : mno,
					"replyno" : cnt,
					"comment" : comment,
					"status" : 1,
					"${_csrf.parameterName}" : "${_csrf.token}"
				},
				type : "POST",
				success : function(data) {		
					console.log(data);
					location.reload();
				}
			}); 
		});			
	}
	
	function replyModify(reply, str){
		if(!${isLogin}){
			location.href="/career/login";
			return;
		} 
		$("#modifyReply").show();	
		
		$(".modifyReply-area").val(str);
		
		$("#replyModifySubmit").on("click", function(e) {
			console.log("수정 제출")
			if ($(".modifyReply-area").val() == "") {
				alert("내용을 입력해주세요");
				return;
			}
				e.preventDefault();
			let comment = $(".modifyReply-area").val();
			let bno = $("input[name='bno']").val();
			let mno = $("input[name='mno']").val();		
			

 			$.ajax({
				url : "./modifyReply",
				data : {
					"replyNo" : reply,
					"bno" : bno,
					"mno" : mno,
					"comment" : comment,
					"${_csrf.parameterName}" : "${_csrf.token}"
				},
				type : "POST",
				success : function(data) {		
					location.reload();
				}
			});  
		});		
	}

	
	function updateLike(){
		let bno = $("input[name='bno']").val();
		let mno = $("input[name='mno']").val();
		let gno = '<c:out value="${like.gno}"/>';
		$.ajax({
			url : "./updateGood",
			data : {			
				"gno" : gno,
				"bno" : bno,
				"mno" : mno,
				"like" : like==true?1:0,
				"disLike" : disLike==true?1:0,
				"${_csrf.parameterName}" : "${_csrf.token}"
			},
			type : "POST",
			success : function(data) {
				if(data.like == 1){
					like = true;
				}else if(data.like == 0){
					like = false;
				}
				if(data.disLike == 1){
					disLike = true;
				}else if(data.disLike == 0){
					disLike = false;
				}
				location.reload();
			}
		});
	}
	function updateDisLike(){
		let bno = $("input[name='bno']").val();
		let mno = $("input[name='mno']").val();
		let gno = '<c:out value="${like.gno}"/>';
		$.ajax({
			url : "./updateDisLike",
			data : {			
				"gno" : gno,
				"bno" : bno,
				"mno" : mno,
				"like" : like==true?1:0,
				"disLike" : disLike==true?1:0,
				"${_csrf.parameterName}" : "${_csrf.token}"
			},
			type : "POST",
			success : function(data) {
				if(data.like == 1){
					like = true;
				}else if(data.like == 0){
					like = false;
				}
				if(data.disLike == 1){
					disLike = true;
				}else if(data.disLike == 0){
					disLike = false;
				}
				location.reload();
			}
		});
		
	}
</script>
<style>
.reply {
	word-break: break-all;
}

.reply-btn {
	text-align: right;
	font-size: 20px;
	font-weight: 700;
	color: #C0C4C7;
}

.reply-area, .replyChild-area, .modifyReply-area{
	font-size: 14px;
	resize: none;
}

.bi-three-dots::before {
	font-size: 25px;
	background-size: 25px;
	margin-right: 10px;
}

.categoryLink {
	text-decoration: none;
	font-size: 13px;
	font-weight: 400;
	color: black;
}

.categoryLink:hover {
	color: black;
}

.detailTitle {
	margin-top: 7px;
}

.postInfo {
	font-size: 12px;
	line-height: 10px;
	color: #94969b;
}

.bi::before {
	font-size: 15px;
	cursor: pointer;
}

.bi-eye::before {
	font-size: 15px;
}

.container-sm {
	
}

.commenterInfo {
	font-size: 12px;
}

.company {
	color: #37acc9;
}

.comment {
	font-size: 14px;
}

.sameCommenter {
	font-size: 10px;
	color: #da3238;
}

.topicBestHeader {
	padding-bottom: 8px;
	padding-left: 10px;
	font-size: 15px;
	font-weight: 900;
}

.rankEm {
	display: inline-block;
	width: 20px;
	margin-right: 10px;
	font-weight: bold;
	color: #94969b;
	text-align: center;
	line-height: 20px;
	word-break: break-all;
}

.rank {
	margin-right: 5px;
}

.col-lg-8 {
	margin-right: 70px;
}
.popup_replybox {
	position: relative;
	top: 50%;
	left: 50%;
	overflow: auto;
	height: 500px;
	width: 730px;
	transform: translate(-50%, -50%);
	z-index: 1002;
	box-sizing: border-box;
	background: #fff;
	box-shadow: 2px 5px 10px 0px rgba(0, 0, 0, 0.35);
	-webkit-box-shadow: 2px 5px 10px 0px rgba(0, 0, 0, 0.35);
	-moz-box-shadow: 2px 5px 10px 0px rgba(0, 0, 0, 0.35);
}
.repypopup_cont{
	margin : 50px;
}
</style>
</head>
<body>
	<!-- Page content-->
	<jsp:include page="/career/nav" />
	<div class="container">
		<div class="container-sm mt-4">
			<div class="row">
				<div class="col-lg-8">
					<!-- Post content-->
					<article class="post-header">
						<!-- Post header-->
						<header class="mb-1">
							<a href="list?category=${board.category }" class="categoryLink">[${board.category }]</a>

							<!-- Post title-->
							<h3 class="fw-bolder mb-1 detailTitle">${board.btitle }</h3>
							<!-- Post categories-->
							<span class="postInfo me-2">${member.company }</span> <span
								class="postInfo"> ${member.nickName }</span>
							<!-- Post meta content-->
							<div>
								<span class="me-2 postInfo"> <i class="bi bi-clock fa-xs"></i>
									${board.bregdate }
								</span> <span class="postInfo"><i class="bi bi-eye fa-xs"></i>
									${board.bhits }</span>

								<div class="dropdown float-end">

									<i class="bi bi-three-dots" data-bs-toggle="dropdown"></i>
									<ul class="dropdown-menu float-none">
										<li><a class="dropdown-item" href="javascript:copyLink()">링크복사</a></li>
										<c:if test="${mno eq board.mno }">
											<li><a class="dropdown-item"
												href="javascript:updateForm(${board.bno})">글 수정</a></li>
											<li><a class="dropdown-item"
												href="./deleteBoard?bno=${board.bno }">삭제</a></li>
										</c:if>
									</ul>
								</div>


							</div>
						</header>
						<hr>
						<!-- Post content-->
						<section class="mb-5">${board.bcontents }</section>
						<section class="mb-1" id="likeApp">
							<c:if test="${empty mno}">
								<a href="/career/login" class="me-2"> <i
									class="bi bi-hand-thumbs-up"></i> 좋아요
								</a>
								<a href="/career/login" class="me-2"> <i
									class="bi bi-hand-thumbs-down"></i> 싫어요
								</a>
							</c:if>
							<c:if test="${not empty mno}">


								<a href="javascript:updateLike()" class="me-2"> <i
									v-if="!isLike" class="bi bi-hand-thumbs-up"></i> <i
									v-if="isLike" class="bi bi-hand-thumbs-up-fill"></i> <span>${likeCnt }좋아요</span>
								</a>

								<a href="javascript:updateDisLike()" class="me-2"> <i
									v-if="!isdisLike" class="bi bi-hand-thumbs-down"></i> <i
									v-if="isdisLike" class="bi bi-hand-thumbs-down-fill"></i> <span>${disLikeCnt }싫어요</span>
								</a>

							</c:if>

							<span> <i class="bi bi-wechat"></i> ${replycnt }
							</span>

						</section>
						<hr>

					</article>
					<!-- Comments section-->
					<section class="mb-5">
						<div class="card bg-light">
							<div class="card-body">
								<!-- Comment form-->
								<form class="mb-4">
									<input type="hidden" name="${_csrf.parameterName}"
										value="${_csrf.token}" /> <input type="hidden" name="bno"
										value="${board.bno }" /> <input type="hidden" name="bno"
										value="${member.mno }" />
									<textarea class="form-control mb-2 reply-area" rows="5"
										placeholder="댓글을 남겨주세요" name="reply"></textarea>


									<div class="reply-btn ">
										<input type="button" class="reply-btn bg-light me-1 btn"
											value="취소" /> 
										<input type="submit"
											class="reply-btn bg-light btn btn-outline" id="replySubmit" value="등록" />
									</div>
								</form>
								<!-- Comment with nested comments-->
								<div class="mb-4 reply" id="replyApp">
									<!-- Parent comment-->
									<div class="ms-3 commentDiv">
									<c:forEach var="i" items="${ reply}" varStatus="j">
									
									
										<c:if test="${i.status eq 2}">
											<div class="">
												<span class="commenterInfo me-2 company"> ${i.company} </span>
												<span class="commenterInfo me-2"> ${i.nickName} </span>
												<span class="commenterInfo"> ${i.rregdate } </span>
												<c:if test="${board.mno eq i.mno }">
													<span class="sameCommenter">작성자</span>
												</c:if>					
												<div class="dropdown float-end">
													<i class="bi bi-three-dots" data-bs-toggle="dropdown"></i>
													<ul class="dropdown-menu float-none">
														<li><a class="dropdown-item" href="javascript:childReply(${i.replyNo})">답글쓰기</a></li>
													</ul>
												</div>
												<br />
												<span class="comment" id="comment${j.count }"> ${i.comment }</span>		
												
													
											</div>
											<hr />										
										</c:if>
										
										<c:if test="${i.status eq 0}">
											<div class="">
												<span class="commenterInfo me-2 company"> ${i.company} </span>
												<span class="commenterInfo me-2"> ${i.nickName} </span>
												<span class="commenterInfo"> ${i.rregdate } </span>
												<c:if test="${board.mno eq i.mno }">
													<span class="sameCommenter">작성자</span>
												</c:if>					
												<div class="dropdown float-end">
													<i class="bi bi-three-dots" data-bs-toggle="dropdown"></i>
													<ul class="dropdown-menu float-none">
														<li><a class="dropdown-item" href="javascript:childReply(${i.replyNo})">답글쓰기</a></li>
														<c:if test="${mno eq i.mno }">
															<li><a class="dropdown-item"href="javascript:replyModify(${i.replyNo}, '${i.comment }')" v-on:Click="showReplyFrom">수정하기</a></li>
															<li><a class="dropdown-item"href="javascript:replyDelete(${i.replyNo })">삭제하기</a></li>
														</c:if>
													</ul>
												</div>
												<br />
												<span class="comment" id="comment${j.count }"> ${i.comment }</span>		
												
													
											</div>
											<hr />
										</c:if>
										<!-- 대댓글인경우 -->
										<c:if test="${i.status eq 1}">
											<div class="ms-3">			
												<span class="commenterInfo me-2 company"> ${i.company} </span>
												<span class="commenterInfo me-2"> ${i.nickName} </span>
												<span class="commenterInfo"> ${i.rregdate } </span>
												<c:if test="${board.mno eq i.mno }">	
													<span class="sameCommenter">작성자</span>
												</c:if>					
												<div class="dropdown float-end">
													<i class="bi bi-three-dots" data-bs-toggle="dropdown"></i>
													<ul class="dropdown-menu float-none">
														<li><a class="dropdown-item" href="javascript:childReply(${i.replyNo})">답글쓰기</a></li>
														<c:if test="${mno eq i.mno }">
															
															<li><a class="dropdown-item"href="javascript:replyModify(${i.replyNo }, '${i.comment }')">수정하기</a></li>
															<li><a class="dropdown-item"href="javascript:replyDelete(${i.replyNo })">삭제하기</a></li>
														</c:if>
													</ul>
												</div><br />	
												
												<span class="comment"> ${i.comment }</span>			
											</div>
											<hr />
										</c:if>
									</c:forEach>
									</div>
								</div>
							</div>
						</div>
					</section>
				</div>
				<!-- Side widgets-->
				<div class="col-lg-3">
					<!-- Side widget-->
					<div class="card mb-4">
						<p class="topicBestHeader ms-2 mt-2">실시간 인기글</p>
						<div class="inner ms-2">
							<c:forEach items="${topicBest }" var="item" end="9"
								varStatus="num">
								<p class="rank">
									<em class="rankEm">${num.count}</em> <a
										href="/talk/talkDetail?bno=${item.bno}" class="">${item.btitle }</a>
								</p>
							</c:forEach>
						</div>
					</div>


				</div>
			</div>
		</div>
		
		<div class="popup_layer" id="updateWrite" style="display: none;">
			<div class="popup_box">
				<div style="height: 10px; float: top; position: relative;">
					<a href="javascript:closeWrite();"> <img
						src="/img/ic_close.svg" class="m_header-banner-close" width="50px"
						height="50px" style="position: absolute; right: 15px"></a>
				</div>
				<!--팝업 컨텐츠 영역-->
				<div class="popup_cont">
					<!-- <div class="top">
						<h4
							style="font-family: 'Do Hyeon', sans-serif; color: #9AAEFA; font-size: 35px;">
							<img alt="" src="/img/careerlogo.png" width="80px" height="45px">
							글쓰기
						</h4>
						<br>
					</div> -->
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" /> <input type="hidden" name="bno" /> <select
						class="form-select" aria-label="Default select example"
						name="category">
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
				</div>
				<!--팝업 버튼 영역-->
				<div class="popup_btn"
					style="text-align: center; margin-bottom: 40px;">
					<a href="javascript:closeWrite();"> <input class="pop"
						type="button" value="취소" />
					</a> <input class="pop" type="button" id="updateSubmit" value="수정" />
				</div>
			</div>
		</div>
		
		
		<!-- 댓글팝업 -->
		<div class="popup_layer" id="replyChild" style="display: none;">
			<div class="popup_replybox" style="height: 425px;">
				<div class="popup_cont repypopup_cont">
				<div style="height: 10px; float: top; position: relative;">
					<a href="javascript:closeReply();"> <img
						src="/img/ic_close.svg" class="m_header-banner-close" width="50px"
						height="50px" style="position: absolute; right: 15px"></a>
				</div>
				<!--팝업 컨텐츠 영역-->
					<div class="top">
						<h4
							style="font-family: 'Do Hyeon', sans-serif; color: #9AAEFA; font-size: 35px;">
							<img alt="" src="/img/careerlogo.png" width="80px" height="45px">				
						</h4>
						<br>
					</div>
					<form class="mb-4">
						<input type="hidden" name="${_csrf.parameterName}"
							value="${_csrf.token}" /> 
						<input type="hidden" name="bno" value="${board.bno }"/> 
						<input type="hidden" name="bno" value="${member.mno }"/> 
						<textarea class="form-control mb-2 replyChild-area" rows="5"
							placeholder="답글을 남겨주세요" name="reply"></textarea>


						<div class="reply-btn ">
							<input type="button" class="reply-btn  me-1 btn" id="replyChildCancle" value="취소" /> 
							<input type="submit"
								class="reply-btn  btn btn-outline" id = "replyChildSubmit" value="등록" />
						</div>
					</form>
					
				</div>
			</div>
		</div>
		
		<!-- 수정팝업 -->

		<div class="popup_layer" id="modifyReply" style="display: none;">
			<div class="popup_replybox">
				<div class="popup_cont repypopup_cont">
				<div style="height: 10px; float: top; position: relative;">
					<a href="javascript:closeModifyReply();"> <img
						src="/img/ic_close.svg" class="m_header-banner-close" width="50px"
						height="50px" style="position: absolute; right: 0px;"></a>
				</div>
				<!--팝업 컨텐츠 영역-->
					<div class="top">
						<h4
							style="font-family: 'Do Hyeon', sans-serif; color: #9AAEFA; font-size: 35px;">
							<img alt="" src="/img/careerlogo.png" width="80px" height="45px">				
						</h4>
						<br>
					</div>
					<form class="mb-4">
						<input type="hidden" name="${_csrf.parameterName}"
							value="${_csrf.token}" /> 
						<input type="hidden" name="bno" value="${board.bno }"/> 
						<input type="hidden" name="bno" value="${member.mno }"/> 
						<textarea class="form-control mb-2 modifyReply-area" rows="5" class="modifyArea"
							placeholder="답글을 남겨주세요" name="reply"></textarea>


						<div class="reply-btn ">
							<input type="button" class="reply-btn  me-1 btn btn-outline" id="modifyCancle"
								value="취소" />
							<input type="submit"
								class="reply-btn  btn btn-outline " id = "replyModifySubmit" value="수정" />
						</div>
					</form>
					
				</div>
			</div>
		</div>
		
	</div>
	<jsp:include page="/career/footer"></jsp:include>

	<script>
	var like = '<c:out value="${like.like}"/>';
	var disLike = '<c:out value="${like.disLike}"/>';
	if (like == ""){
		like = 0;
	}
	if (disLike == ""){
		disLike = 0;
	}
	
	if(like == 1){
		like = true;
	}else{
		like = false;
	}
	if(disLike == 1){
		disLike = true;
	}else{
		disLike = false;
	}
	
	let app = new Vue({
		el : "#likeApp",
		data : {
			isLike : like,
			isdisLike : disLike	 			
		}
		
	});
	
	let replyApp = new Vue({
		el : "#replyApp",
		data : {
			showReply : false
		},
		methods : {
			showReplyFrom : function(){
				showReply : true
			}
		}
	});
</script>
</body>
</html>