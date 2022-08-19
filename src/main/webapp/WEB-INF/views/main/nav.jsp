<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- Logined Navigation-->
<link rel="stylesheet" type="text/css"
	href="/css/nav.css" />
<c:if test="${isLogin}">
	<jsp:include page="/comp/review" />
	<nav class="navbar navbar-expand-lg navbar-light"
		style="border-bottom: 1px solid rgb(229, 229, 229);">
		<div class="container px-4 px-lg-5">

			<a class="navbar-brand" href="/career/main"><img
				src="/img/career_logo.png" alt="" width="200px" /></a>

			<ul class="navbar-nav mb-2 mb-lg-0 mainnav" id="mainnav">
				<li class="nav-item"><a class="nav-link active menu"
					href="/talk/main">잡담</a></li>
				<li class="nav-item"><a class="nav-link active menu"
					href="/career/employlist">채용공고</a></li>
				<li class="nav-item dropdown sbtn"><a
					class="nav-link dropdown-toggle" id="navbarDropdown" href="#"
					role="button" data-bs-toggle="dropdown" aria-expanded="false" style="line-height: 36px; margin-left: 20px">
						${nickname}님 환영합니다 </a>
					<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
						<c:if test="${isAdmin}">
							<li><a class="dropdown-item" href="/career/adminPage">회원관리</a></li>
						</c:if>
						<c:if test="${!isAdmin}">
							<li><a class="dropdown-item" href="/user/career/mypage">마이페이지</a></li>
						</c:if>
						<li><a class="dropdown-item" href="javascript:openPop()">내 기업 리뷰작성</a></li>
						<li><hr class="dropdown-divider" /></li>
						<li><a class="dropdown-item" href="/career/logout">로그아웃</a></li>
					</ul>
			</ul>
		</div>
	</nav>
</c:if>

<!-- Not Logined Navigation-->
<c:if test="${!isLogin}">
	<nav class="navbar navbar-expand-lg navbar-light"
		style="border-bottom: 1px solid rgb(229, 229, 229); font-family: 'godo';">

		<div class="container px-4 px-lg-5">
			<a class="navbar-brand" href="/career/main"><img
				src="/img/career_logo.png" alt="" width="200px" /></a>

			<ul class="navbar-nav mb-2 mb-lg-0 mainnav" id="mainnav">
				<li class="nav-item"><a class="nav-link active menu"
					href="/talk/main">잡담</a></li>
				<li class="nav-item"><a class="nav-link active menu"
					href="/career/employlist">채용공고</a></li>
				<li style="line-height: 36px; margin-left: 20px"><a class="nav-link sbtn" style="color: #737373;" href="/career/login">로그인</a></li>
			</ul>
		</div>
	</nav>
</c:if>
