function optionBox(action) {
	if (action == "open") {
		document.getElementById('light').style.display='block';
		document.getElementById('fade').style.display='block';
	}
	if (action == "close") {
		document.getElementById('light').style.display='none';
		document.getElementById('fade').style.display='none';
	}
}
