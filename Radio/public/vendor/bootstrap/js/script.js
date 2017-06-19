$(document).ready(function(){
	$("#muda").click(function () {
		$("body").css("background-image", "url('bg1.jpg')");
	})
	$("#desmuda").click(function () {
		$("body").css("background-image", "url('bg.jpg')");
	})		
});

function chama(){
	texto = document.getElementById('talk').value;
	var msg = new SpeechSynthesisUtterance(texto);
	window.speechSynthesis.speak(msg);
}