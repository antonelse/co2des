let selectedColor = null;
let r = null;
let g = null;
let b = null;

let username;
let timerValue;

let sliderValue = 0;

let changingRoom=false;


//disk

var isDown=false;
var isUp=true;
var buttonPressed;
var dimensions;
var traslations;
var rotation1;
var rotation2;
var scaling=1;

let stretch=1;
let translation=1;
let isChanging=false;
let room=1;
let dim1=245;
let dim2=220;
let dim3=190;
let dim4=225;
let numLines5=0;
let numLines6=0;
let numLines7=0;
let numLines8=0;

const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);

function setUsername(){
    username = urlParams.get("username");
    if(username != null){
        document.querySelector("#username").value = username;
    }
}

function setRoom(){
    room = urlParams.get("room");
    if(room==null){
        room=Math.ceil(Math.random()*2);
        if(room==0) room=1;
    } 
    console.log(room);
}

window.onload = function(){
    enableButtons();
    setUsername();
    setRoom();
    showTimer();
}

function showTimer(){
    timerValue=parseInt(document.querySelector(".timer-container").innerHTML);
    if(username!=null){
        document.querySelector(".timer-container").style.setProperty("display","flex");
        document.querySelector(".wait-text").style.setProperty("display","flex");
        setInterval(countdown,1000);
    }
}

function countdown(){
    timerValue--;
    if(timerValue==0){
        clearInterval();
        hideTimer();
        return;
    }
    document.querySelector(".timer-container").innerHTML=timerValue;
}

function hideTimer(){
    document.querySelector(".timer-container").style.setProperty("display","none");
    document.querySelector(".wait-text").style.setProperty("display","none");
}

function sendMessage(){
    disableOtherButtons();
    scaling=1;
    var name = document.getElementById("username").value;
    if(name.length>20) name=name.substr(0,19);
    if(name.length < 1 ){
        swal({
            title: "Warning!",
            icon: "warning",
            text: "Insert a username",
        });
        enableButtons();
        resetInitialValues();
    } else {
        //blnm
            if(r!=null||g!=null||b!=null){
                username = name;
                message = name + "-" + room+ "-" + r + "-" + g + "-" + b + "-" + sliderValue;
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

function resetInitialValues(){
    dim1=245;
    dim2=220;
    dim3=190;
    dim4=225;
    numLines5=0;
    numLines6=0;
    numLines7=0;
    numLines8=0;
    document.querySelectorAll(".parameter-changing")[0].style.setProperty("color", "rgb(0,0,0,0)");
    document.querySelectorAll(".parameter-changing")[1].style.setProperty("color", "rgb(0,0,0,0)");
}

function toggleValueSlider(button){
    if(isDown){
        isDown=false;
        document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling.toFixed(2);
        document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling.toFixed(2);

        if(button=="button-transparent1"){
            document.querySelectorAll(".parameter-changing")[1].innerHTML=dim1.toFixed(2);
            console.log(normalize(dim1,350,245))
            setValue(normalize(dim1,350,245));
        }
        if(button=="button-transparent2"){
            document.querySelectorAll(".parameter-changing")[1].innerHTML=dim4.toFixed(2);
            console.log(normalize(dim4,350,245))
            setValue(normalize(dim4,350,245));
        }
        if(button=="button-transparent3"){
            document.querySelectorAll(".parameter-changing")[1].innerHTML=dim2.toFixed(2);
            console.log(normalize(dim2,350,245))
            setValue(normalize(dim2,350,245));
        }
        if(button=="button-transparent4"){
            document.querySelectorAll(".parameter-changing")[1].innerHTML=dim3.toFixed(2);
            console.log(normalize(dim3,350,245))
            setValue(normalize(dim3,350,245));
        }
        if(button=="button-transparent5"){
            document.querySelectorAll(".parameter-changing")[1].innerHTML=int(numLines5);
            console.log(normalize(int(numLines5),8,0))
            setValue(normalize(int(numLines5),8,0));
        }
        if(button=="button-transparent6"){
            document.querySelectorAll(".parameter-changing")[1].innerHTML=int(numLines8);
            console.log(normalize(int(numLines8),7,0))
            setValue(normalize(int(numLines8),7,0));
        }
        if(button=="button-transparent7"){
            document.querySelectorAll(".parameter-changing")[1].innerHTML=int(numLines6);
            console.log(normalize(int(numLines6),6,0))
            setValue(normalize(int(numLines6),6,0));
        }
        if(button=="button-transparent8"){
            document.querySelectorAll(".parameter-changing")[1].innerHTML=int(numLines7);
            console.log(normalize(int(numLines7),5,0))
            setValue(normalize(int(numLines7),5,0));
        }
        sendMessage();
    } 
    else{
        isDown=true;
        buttonPressed=button;
        console.log("buttonPressed");
        if(buttonPressed=="button-transparent1"){
            traslations=80;
            rotation1=50;
            rotation2=30;
            r=245;
            g=203;
            b=54;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="cutoff";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        }
        else if(buttonPressed=="button-transparent2") {
            traslations=82;
            rotation1=300;
            rotation2=301.5;
            r=190;
            g=9;
            b=206;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="crusher";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        }
        else if(buttonPressed=="button-transparent3"){
            traslations=82;
            rotation1=140;
            rotation2=140;
            r=6;
            g=48;
            b=189;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="rndFloat";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        } 
        else if(buttonPressed=="button-transparent4"){
            traslations=85;
            rotation1=220;
            rotation2=220;
            r=10;
            g=209;
            b=183;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="pan";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        } 
        else if(buttonPressed=="button-transparent5"){
            traslations=80;
            rotation1=50;
            rotation2=30;
            r=246;
            g=203;
            b=54;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="rndInt";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        }
        else if(buttonPressed=="button-transparent6") {
            traslations=82;
            rotation1=300;
            rotation2=301.5;
            r=191;
            g=9;
            b=206;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="every";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        }
        else if(buttonPressed=="button-transparent7"){
            traslations=82;
            rotation1=140;
            rotation2=140;
            r=7;
            g=48;
            b=189;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="fast";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        } 
        else if(buttonPressed=="button-transparent8"){
            traslations=85;
            rotation1=220;
            rotation2=220;
            r=11;
            g=209;
            b=183;
            document.querySelectorAll(".parameter-changing")[0].style.color="rgb("+r+","+g+","+b+")";
            document.querySelectorAll(".parameter-changing")[0].innerHTML="offset";
            document.querySelectorAll(".parameter-changing")[1].innerHTML=scaling;
        } 

        console.log(buttonPressed);
        loop();
    }
}

function disableOtherButtons(){
    document.querySelector(".button-transparent1").onmousedown="none";
    document.querySelector(".button-transparent1").onmouseup="none";
    document.querySelector(".button-transparent1").ontouchstart="none";
    document.querySelector(".button-transparent1").ontouchend="none";

    document.querySelector(".button-transparent2").onmousedown="none";
    document.querySelector(".button-transparent2").onmouseup="none";
    document.querySelector(".button-transparent2").ontouchstart="none";
    document.querySelector(".button-transparent2").ontouchend="none";

    document.querySelector(".button-transparent3").onmousedown="none";
    document.querySelector(".button-transparent3").onmouseup="none";
    document.querySelector(".button-transparent3").ontouchstart="none";
    document.querySelector(".button-transparent3").ontouchend="none";

    document.querySelector(".button-transparent4").onmousedown="none";
    document.querySelector(".button-transparent4").onmouseup="none";
    document.querySelector(".button-transparent4").ontouchstart="none";
    document.querySelector(".button-transparent4").ontouchend="none";

    document.querySelector(".button-transparent5").onmousedown="none";
    document.querySelector(".button-transparent5").onmouseup="none";
    document.querySelector(".button-transparent5").ontouchstart="none";
    document.querySelector(".button-transparent5").ontouchend="none";

    document.querySelector(".button-transparent6").onmousedown="none";
    document.querySelector(".button-transparent6").onmouseup="none";
    document.querySelector(".button-transparent6").ontouchstart="none";
    document.querySelector(".button-transparent6").ontouchend="none";

    document.querySelector(".button-transparent7").onmousedown="none";
    document.querySelector(".button-transparent7").onmouseup="none";
    document.querySelector(".button-transparent7").ontouchstart="none";
    document.querySelector(".button-transparent7").ontouchend="none";

    document.querySelector(".button-transparent8").onmousedown="none";
    document.querySelector(".button-transparent8").onmouseup="none";
    document.querySelector(".button-transparent8").ontouchstart="none";
    document.querySelector(".button-transparent8").ontouchend="none";
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
function toggle5(){
    toggleValueSlider("button-transparent5");
}
function toggle6(){
    toggleValueSlider("button-transparent6");
}
function toggle7(){
    toggleValueSlider("button-transparent7");
}
function toggle8(){
    toggleValueSlider("button-transparent8");
}

function changeRoom(){
    changingRoom=true;
    isChanging=true;
    if(room==1) room=2;
    else room=1;
}

function enableButtons(){
    //disk1
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
    
    document.querySelector(".button-transparent1").ondragend=toggle1;
    document.querySelector(".button-transparent2").ondragend=toggle2;
    document.querySelector(".button-transparent3").ondragend=toggle3;
    document.querySelector(".button-transparent4").ondragend=toggle4;
    
    //disk 2
    document.querySelector(".button-transparent5").onmousedown=toggle5;
    document.querySelector(".button-transparent5").onmouseup=toggle5;
    document.querySelector(".button-transparent6").onmousedown=toggle6;
    document.querySelector(".button-transparent6").onmouseup=toggle6;
    document.querySelector(".button-transparent7").onmousedown=toggle7;
    document.querySelector(".button-transparent7").onmouseup=toggle7;
    document.querySelector(".button-transparent8").onmousedown=toggle8;
    document.querySelector(".button-transparent8").onmouseup=toggle8;
    
    document.querySelector(".button-transparent5").ontouchstart=toggle5;
    document.querySelector(".button-transparent5").ontouchend=toggle5;
    document.querySelector(".button-transparent6").ontouchstart=toggle6;
    document.querySelector(".button-transparent6").ontouchend=toggle6;
    document.querySelector(".button-transparent7").ontouchstart=toggle7;
    document.querySelector(".button-transparent7").ontouchend=toggle7;
    document.querySelector(".button-transparent8").ontouchstart=toggle8;
    document.querySelector(".button-transparent8").ontouchend=toggle8;
    
    document.querySelector(".button-transparent5").ondragend=toggle5;
    document.querySelector(".button-transparent6").ondragend=toggle6;
    document.querySelector(".button-transparent7").ondragend=toggle7;
    document.querySelector(".button-transparent8").ondragend=toggle8;
}



document.querySelector(".change-room-right").onclick=changeRoom;
document.querySelector(".change-room-left").onclick=changeRoom;




