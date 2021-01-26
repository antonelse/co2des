
function setup(){
    frameRate(20);
}
function draw(){
    if(isDown){
        if(buttonPressed=="button-transparent1"){
            buttons=document.querySelectorAll(".squarecircle1");

        } 
        else if(buttonPressed=="button-transparent2"){
            buttons=document.querySelectorAll(".squarecircle4");
           
        } 
        else if(buttonPressed=="button-transparent3"){
             buttons=document.querySelectorAll(".squarecircle2");
            
        }
        else if(buttonPressed=="button-transparent4"){
             buttons=document.querySelectorAll(".squarecircle3");
            
        }
            dimensions++;
            
            dimensionString=dimensions.toString();
            /*for(let i=0;i<buttons.length;i++){
                console.log((dimensions));
                buttons[i].style.setProperty("border-right-width", dimensionString+"px");
                buttons[i].style.setProperty("border-top-width", dimensionString+"px");
                buttons[i].style.setProperty("border-left-width", dimensionString+"px");
                buttons[i].style.setProperty("border-buttom-width", dimensionString+"px");
                buttons[i].style.setProperty("border-radius", dimensionString+"px");
            }
            buttons[0].style.setProperty("transform", "translate(-"+traslations+"%,-"+traslations+"%) rotate("+rotation1+"deg)");
            buttons[1].style.setProperty("transform", "translate(-"+traslations+"%,-"+traslations+"%) rotate("+rotation2+"deg)");
            traslations-=0.25;*/
                buttons[0].style.setProperty("transform", "translate(-"+traslations+"%,-"+traslations+"%) rotate("+rotation1+"deg) scale("+scaling+","+scaling+")");
                buttons[1].style.setProperty("transform", "translate(-"+traslations+"%,-"+traslations+"%) rotate("+rotation2+"deg) scale("+scaling+","+scaling+")");
                if(scaling<1.5)scaling+=0.01;
            
    }
    else{
        console.log("up");
        noLoop();
    }
}