//초기 별점 구성
$(document).ready(function() {
	score(Number($(".star").val()));
	$("#rate"+Number($(".star").val())).prop('checked', true)
})

$(function() {
	$(".scorestar").hover(function() {
		var flag = $("input[name='reviewStar']").is(':checked');
		var t = $(this).attr('for').substr(4);
		if (!flag) {
			$(this).prevAll().css("color", "gold");
			$(this).css("color", "gold");
		}
	}, function() {
		var flag = $("input[name='reviewStar']").is(':checked');
		if (!flag) {
			$(".scorestar").css("color", "#bbbbbb");
		}
	});

	$("#submitform").on('click', function() {
		
		if (!$("input[name='reviewStar']").is(':checked')) {
			alert("별점을 등록해주세요");
			return;
		}
		if ($("input[name='title']").val() == '') {
			alert("제목을 작성해주세요");
			$("input[name='title']").focus();
			return;
		}
		if ($("textarea").val() == '') {
			alert("리뷰를 작성해주세요");
			$("textarea").focus();
			return;
		}
		$("#myform").submit();
	})
});
function score(t) {
	var a = ".scorestar:nth-child(-n+" + t * 2 + ")";
	var b = ".scorestar:nth-child(n+" + (t + 1) * 2 + ")";
	$(a).css("color", "gold");
	$(b).css("color", "#bbbbbb");
}

//팝업 띄우기
function openPop() {
    document.getElementById("popup_layer").style.display = "block";
}

//팝업 닫기
function closePop() {
    document.getElementById("popup_layer").style.display = "none";
}