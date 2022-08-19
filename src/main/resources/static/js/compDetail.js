//스크랩 데이터 전송
$(document).ready(function() {
	$(".bookmark").click(function() {
		$.ajax({
			url: "/comp/scrap",
			data: {
				mno: $("#mnoVal").html(),
				cno: $("#cnoVal").html(),
			}
		})
	})
})

//스크랩 이미지 변경
$(document).ready(function() {
	$(".bookmark").click(function() {
		if ($(this).hasClass("kFiblp")) {
			$(".bookmark").removeClass('kFiblp')
			$(this).addClass('dTwVkn')
		} else {
			$(".bookmark").removeClass('dTwVkn')
			$(this).addClass('kFiblp')
		}
	})
})

//nav var고정
$(document).ready(function() {
	var offset = $('.CGOmt').offset();
	$(window).scroll(function() {
		if ($(document).scrollTop() > offset.top) {
			$('.CGOmt').addClass('jQBdUM');
		}
		else {
			$('.CGOmt').removeClass('jQBdUM');
		}
	});
});

//nav var고정
$(document).ready(function() {
	var offset = $('.eYQTsN').offset();
	$(window).scroll(function() {
		if ($(document).scrollTop() > offset.top) {
			$('.eYQTsN').addClass('bZecJ');
		}
		else {
			$('.eYQTsN').removeClass('bZecJ');
		}
	});
});

function reviewDetail(t) {
	if ($(t).hasClass("comp-review-contents-detail")) {
		$(t).removeClass('comp-review-contents-detail')
	} else {
		$(t).addClass('comp-review-contents-detail')
	}
}

//공유하기
function copyLink() {
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