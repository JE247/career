/**
 * 
 */


let updatepw = false;



function infoUpdate() {
	$("#infoTable").hide();
	$("#updateTable").show();
}

function setChildValue(cname) {
	$("#inputCompany").val(cname);
}

$(function() {
	/* 회사 찾기 */
	$("#searchCompany").on("click", function() {
		var popupWidth = 500;
		var popupHeight = 500;
		var popupX = (window.screen.width / 2) - (popupWidth / 2);
		var popupY = (window.screen.height / 2) - (popupHeight / 2);
		var url = "/career/register/searchComp";
		var name = "searchComp";
		var option = "width = 500px, height = 500px, top = " + popupY + ", left = " + popupX + ", resizable=no, location = no";

		window.open(url, name, option);
	});

	$("#cancleMyInfo").on("click", function() {
		$("#infoTable").show();
		$("#updateTable").hide();
	});

	$("#updatePw").on("click", function() {
		if (originpw != $("#originpw").val()) {
			alert("현재 비밀번호를 정확하게 입력해주세요");
			return;
		}
		updatepw = true;
		$("#inputPw").attr("disabled", false);
	});

	$("#updateMyInfo").on("click", function() {
		if ($("#inputNickname").val() == "") {
			alert("닉네임을 입력해주세요");
			return;
		} else if ($("#inputCompany").val() == "") {
			alert("회사명을 선택해주세요");
			return;
		} else if (updatepw && $("#inputPw").val() == "") {
			alert("변경할 비밀번호를 입력해주세요");
			return;
		}

		$("form").submit();
	});

	/*swiper*/
	const swiper = new Swiper('.swiper', {
		// Optional parameters
		spaceBetween: 5,
		slidesPerView: 3,

		// If we need pagination
		pagination: {
			el: '.swiper-pagination',
		},

		// Navigation arrows
		navigation: {
			nextEl: '.swiper-button-next',
			prevEl: '.swiper-button-prev',
		},

		// And if we need scrollbar
		scrollbar: {
			el: '.swiper-scrollbar',
		}
	});
	
	$(".sc-hJZKUC").hide(); // 최초 10개 선택
	$(".sc-hJZKUC").slice(0, 3).show(); // 최초 10개 선택
	
	$("#load").click(function(e) { // Load More를 위한 클릭 이벤트e
		e.preventDefault();
		
		if ($(".gKbwzP:hidden").length == 0) { // 숨겨진 DIV가 있는지 체크
			alert("더 이상 항목이 없습니다"); // 더 이상 로드할 항목이 없는 경우 경고
			return;
		}
		$(".gKbwzP:hidden").slice(0, 3).show(); // 숨김 설정된 다음 10개를 선택하여 표시
		
	});
	
	$(".boardList").hide(); // 최초 10개 선택
	$(".boardList").slice(0, 3).show(); // 최초 10개 선택
	
	$("#moreList").click(function(e) { // Load More를 위한 클릭 이벤트e
		e.preventDefault();
		
		if ($(".boardList:hidden").length == 0) { // 숨겨진 DIV가 있는지 체크
			alert("더 이상 항목이 없습니다"); // 더 이상 로드할 항목이 없는 경우 경고
			return;
		}
		$(".boardList:hidden").slice(0, 3).show(); // 숨김 설정된 다음 10개를 선택하여 표시
		
	});
});