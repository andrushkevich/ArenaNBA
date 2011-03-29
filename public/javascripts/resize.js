// JavaScript Document
function resize()
{
	var curBlockHeight = document.getElementById("bg_borders_800");
	var curContainer1Height = document.getElementById("container1");
	curBlockHeight.style.height = curContainer1Height.clientHeight + "px";
	
}