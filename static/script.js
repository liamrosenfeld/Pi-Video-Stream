function optionBox(action) {
	if (action == "open") {
		document.getElementById('light').style.display='block';
		document.getElementById('fade').style.display='block';
	} else if (action == "close") {
		document.getElementById('light').style.display='none';
		document.getElementById('fade').style.display='none';
	}
}

function resizeVideo(size) {
	var video = document.getElementById("video");
	
	if (size == "fullscreen" && !video.classList.contains("fullscreen")) {
		video.className += "fullscreen";
	} else if (size == "real") {
		video.classList.remove("fullscreen"); 
	}
}

