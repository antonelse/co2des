let selectedColor = null;
let r = null;
let g = null;
let b = null;

let username;

let sliderValue = 0;

const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);

function setUsername(){
    username = urlParams.get("username");
    if(username != null){
        document.querySelector("#username").value = username;
    }
}

window.onload = setUsername;

function sendMessage(){
    scaling=1;
    var name = document.getElementById("username").value;
    if(name.length < 1 ){
        swal({
            title: "Warning!",
            icon: "warning",
            text: "Insert a username",
        });
    } /*else if (selectedColor == null) {
        swal({
            title: "Warning!",
            icon: "warning",
            text: "select a color",
        });
    }*/ else {
        //blnm
            if(r!=null||g!=null||b!=null){
                username = name;
                message = name + "-" + r + "-" + g + "-" + b + "-" + sliderValue;
                window.location.href = "http://wemakethings.pythonanywhere.com/send_msg?text="+message;
            }
        }
    }

function getMessages(){
    window.location.href = "http://wemakethings.pythonanywhere.com/get_msgs";
}

function deleteAll(){
    window.location.href = "http://wemakethings.pythonanywhere.com/delete_all";
    console.log("ciao");
}

function selectColor(id){
    var colors = document.querySelectorAll(".color-square");
    //var colorsArray = Array.prototype.slice.call(colors);

    for (let i=0; i<colors.length; i++){
        if(colors[i].id != id){
            colors[i].classList.add("disabled");
        } else {
            colors[i].classList.remove("disabled");
            selectedColor = getComputedStyle(colors[i]).backgroundColor;
            rgbToSingleValues(selectedColor);
        }
    }
}

function rgbToSingleValues(rgbString){
    var values = rgbString.substring(4, rgbString.length-1);
    var valueArray = values.split(", ");
    r = valueArray[0];
    g = valueArray[1];
    b = valueArray[2];
}

function setValue(value){
    sliderValue = value;
}

function normalize(val, max, min) {
    let value=(val - min) / (max - min);
    value.toFixed(2);
    if(value>1) value=1;
    else if(value<0) value=0;
    return value; 
}




//disco

var isDown=false;
var isUp=true;
var buttonPressed;
var dimensions;
var traslations;
var rotation1;
var rotation2;
var scaling=1;

function toggleValueSlider(button){
    if(isDown){
        isDown=false;
        document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling.toFixed(2);
        document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling.toFixed(2);
        document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling.toFixed(2);
        document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling.toFixed(2);

        console.log(normalize(scaling,1.5,1))
        setValue(normalize(scaling,1.5,1));
        sendMessage();
    } 
    else{
        isDown=true;
        //buttonPressed=button.path[0].classList[0];
        buttonPressed=button;
        console.log("buttonPressed");
        if(buttonPressed=="button-transparent1"){
            dimensions=int(getComputedStyle(document.querySelector(".squarecircle1")).borderRightWidth);
            traslations=80;
            rotation1=50;
            rotation2=30;
            r=245;
            g=203;
            b=54;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            //document.querySelectorAll(".parameter-changing")[1].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="slow";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        }
        else if(buttonPressed=="button-transparent2") {
            dimensions=int(getComputedStyle(document.querySelector(".squarecircle4")).borderRightWidth);
            traslations=82;
            rotation1=300;
            rotation2=301.5;
            r=190;
            g=9;
            b=206;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            //document.querySelectorAll(".parameter-changing")[1].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="cutoff";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        }
        else if(buttonPressed=="button-transparent3"){
            dimensions=int(getComputedStyle(document.querySelector(".squarecircle2")).borderRightWidth);
            traslations=82;
            rotation1=140;
            rotation2=140;
            r=6;
            g=48;
            b=189;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            //document.querySelectorAll(".parameter-changing")[1].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="offset";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        } 
        else if(buttonPressed=="button-transparent4"){
            dimensions=int(getComputedStyle(document.querySelector(".squarecircle3")).borderRightWidth);
            traslations=85;
            rotation1=220;
            rotation2=220;
            r=10;
            g=209;
            b=183;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            //document.querySelectorAll(".parameter-changing")[1].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="crusher";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        } 

        console.log(buttonPressed);
        loop();
    }
}

function toggle1(){
    toggleValueSlider("button-transparent1");
}
function toggle2(){
    toggleValueSlider("button-transparent2");
}
function toggle3(){
    toggleValueSlider("button-transparent3");
}
function toggle4(){
    toggleValueSlider("button-transparent4");
}

document.querySelector(".button-transparent1").onmousedown=toggle1;
document.querySelector(".button-transparent1").onmouseup=toggle1;
document.querySelector(".button-transparent2").onmousedown=toggle2;
document.querySelector(".button-transparent2").onmouseup=toggle2;
document.querySelector(".button-transparent3").onmousedown=toggle3;
document.querySelector(".button-transparent3").onmouseup=toggle3;
document.querySelector(".button-transparent4").onmousedown=toggle4;
document.querySelector(".button-transparent4").onmouseup=toggle4;

document.querySelector(".button-transparent1").ontouchstart=toggle1;
document.querySelector(".button-transparent1").ontouchend=toggle1;
document.querySelector(".button-transparent2").ontouchstart=toggle2;
document.querySelector(".button-transparent2").ontouchend=toggle2;
document.querySelector(".button-transparent3").ontouchstart=toggle3;
document.querySelector(".button-transparent3").ontouchend=toggle3;
document.querySelector(".button-transparent4").ontouchstart=toggle4;
document.querySelector(".button-transparent4").ontouchend=toggle4;


