var url = location.href;
if (url == "http://grantstavely.com/photos") {
	var photoTitle = document.createElement("ul");
	var photoLi = document.createElement("li");
	var photoH3 = document.createElement("h3");
	photoH3.innerHTML="Photo sets";
	photoLi.appendChild(photoH3);
	photoTitle.appendChild(photoLi);
	var existingHead = document.getElementById("PhotosHead");
	existingHead.appendChild(photoTitle);
}
