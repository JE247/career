function adminUpdate(mno) {
	var popupWidth = 500;
	var popupHeight = 500;
	var popupX = (window.screen.width / 2) - (popupWidth / 2);
	var popupY = (window.screen.height / 2.5) - (popupHeight / 2);
	var url = "/career/adminUpdate?mno=" + mno;
	var name = "adminUpdate";
	var option = "width = 500px, height = 600px, top = " + popupY + ", left = " + popupX + ", resizable=no, location = no";

	window.open(url, name, option);
};

