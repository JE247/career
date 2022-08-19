<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://unpkg.com/swiper@8/swiper-bundle.min.css" />
<script src="https://unpkg.com/swiper@8/swiper-bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" type="text/css" href="/css/main.css" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
<link rel="stylesheet" type="text/css" href="/css/employList.css" />
<link rel="stylesheet" type="text/css" href="/css/employ.css" />
<script>
document.addEventListener('keydown', function(event) {
	  if (event.keyCode === 13) {
	    event.preventDefault();
	  };
	}, true);

$(function(){
	var swiper = new Swiper('.swiper', {
	    slidesPerView: 'auto',
	    spaceBetween: 30,
	    preventClicks: true,
	    preventClicksPropagation: false,
	    observer: true,
	    observeParents: true,
	    initialSlide: ${position}
	});
	
 	var $snbSwiperItem = $('.swiper .swiper-wrapper .swiper-slide a');
	$snbSwiperItem.click(function () {
	    var target = $(this).parent();
	    $snbSwiperItem.parent().removeClass('on')
	    target.addClass('on');
	    muCenter(target);
	})

	function muCenter(target) {
	    var snbwrap = $('.swiper .swiper-wrapper');
	    var targetPos = target.position();
	    var box = $('.swiper');
	    var boxHarf = box.width() / 2;
	    var pos;
	    var listWidth = 0;

	    snbwrap.find('.swiper-slide').each(function () { listWidth += ($(this).width()+30); });

	    var selectTargetPos = targetPos.left + target.outerWidth() / 2;
	    
	    if (selectTargetPos <= boxHarf) { // left 끝
	        pos = 0;
	    } else if ((listWidth - selectTargetPos) <= boxHarf) { //right 끝
	        pos = listWidth - box.width();
	    } else {
	        pos = selectTargetPos - boxHarf;
	    }

 	    setTimeout(function () {
	        snbwrap.css({
	            "transform": "translate3d(" + (pos * -1) + "px, 0, 0)",
	            "transition-duration": "500ms"
	        })
	    }, 200); 
	}
	
	$("#search").on("click", getSearch);
	
	$("#searchKeyword").on("keyup",function(key){         
		if(key.keyCode==13) {
			$("input[name='category']").val("0");
			$("input[name='page']").val("1");
			
			$("form").submit();         
		}     
	});
});

function getSearch(){
	
	$("input[name='category']").val("0");
	$("input[name='page']").val("1");
	
	$("form").submit();
}

function getFilter(jobcode){
	$("input[name='category']").val(jobcode);
	$("input[name='page']").val("1");
	
	$("form").submit();
}

function getPage(cp){
	$("input[name='page']").val(cp);
	
	$("form").submit();
}

// 채용공고 Scrap 추가하기
function bookmark(book, id){
	
	if(!${isLogin}){
		alert("로그인 후 이용해주세요");
		return;
	}
	
	let text = $(book).children("span").html().trim();
	
	$.ajax({
		url : "/career/employee/ajax",
		data : {
			"id" : id,
			"${_csrf.parameterName}" : "${_csrf.token}"
		},
		type : "POST",
		success : function(data){
			if(data == 'delete'){
				alert("채용공고 스크랩이 삭제되었습니다.");
				$(book).children("span").html('bookmark_border');
			} else if(data == 'insert'){
				alert("채용공고 스크랩이 추가되었습니다.");
				$(book).children("span").html('bookmark');
			} else {
				alert("에러가 발생하였습니다.");
			}
		}
		
	});
}


</script>

<title>Career</title>
</head>
<body>
	<jsp:include page="/career/nav"></jsp:include>
	<div class="container">
	<form action="">
		<input type="hidden" name="page" value="${cp}" />
		<input type="hidden" name="category" value="${category}" />
		<div class="menu">
				<!-- Swiper -->
			    <div class="swiper-container swiper">
			        <div class="swiper-wrapper">
			            <div class="swiper-slide">
			            	<c:if test="${category eq 0}">
					            <a href="#" onclick="getFilter(0);" style="font-weight: bold;">전체보기</a>
				            </c:if>
				            <c:if test="${category ne 0}">
					            <a href="#" onclick="getFilter(0);" style="color: #94969b;">전체보기</a>
				            </c:if>
			            </div>
			        	<c:forEach var="list" items="${map}">
				            <div class="swiper-slide">
				            
				            <c:if test="${category eq list.value}">
					            <a href="#" onclick="getFilter(${list.value});" style="font-weight: bold;">${list.key}</a>
				            </c:if>
				            <c:if test="${category ne list.value}">
				            <a href="#" onclick="getFilter(${list.value});" style="color: #94969b;">${list.key}</a>
				            </c:if>
				            
				            </div>
			        	</c:forEach>
			        </div>
			    </div>
			    <div class="search">
			    	<input type="text" name="keyword" id="searchKeyword" placeholder="키워드를 입력해주세요" value="${txt}" />
			    	<input type="button" value="검색" id="search" />
			    </div>
		</div>
    </form>
	
	<div id="employList">
		<div class="sc-lbhJGD fGChai">
		<div class="sc-fydGpi eOvOTo">
			<c:forEach items="${mapList.list}" var="item">
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
				                    	<c:if test="${!item.isBookmark}">
												bookmark_border	     
				                    	</c:if>
		                            </span>
				                </a>
				             </div>
						</div>
						<div class="sc-dkqQuH bCzrjV">
							<div class="sc-ksHpcM GUybE">
								<div class="sc-gXRojI cpwLnU">
									<div>${item.company} | ${item.location}</div>
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
	</div>
	<div id="page">
		<nav aria-label="Page navigation example" style="display: inline-block; margin: auto;">
		  <ul class="pagination">
		    <li class="page-item">
			    <c:if test="${prev}">
			      <a class="page-link" href="/career/employlist?page=${cp - 10}" aria-label="Previous">
			        <span aria-hidden="true">&laquo;</span>
			      </a>
			    </c:if>
		    </li>
		    <c:forEach begin="${startNum}" end="${endNum}" step="1" var="i">
		    	<c:if test="${cp eq i }">
					<li class="page-item active" aria-current="page">
					      <span class="page-link">${i }</span>
					</li>		    	
				</c:if>
		    	<c:if test="${cp ne i }">
		    		<li class="page-item"><a class="page-link" href="#" onclick="getPage(${i});">${i}</a></li>
		    	</c:if>
		    </c:forEach>
		    <li class="page-item">
		    	<c:if test="${next}">
			      <a class="page-link" href="#" onclick="getPage(${cp+10});" aria-label="Next">
			        <span aria-hidden="true">&raquo;</span>
			      </a>
		      </c:if>
		    </li>
		  </ul>
		</nav>
	</div>
	</div>
	<jsp:include page="/career/footer"></jsp:include>
</body>
</html>