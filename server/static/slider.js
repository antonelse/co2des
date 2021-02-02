function setup(){
    frameRate(30); 
      
}
function draw(){
    createCanvas(windowWidth,windowHeight);    
    
    //greyslice
    noStroke();
    xToStart=windowWidth/2;
    yToStart=windowHeight/2;
    zToStart=0;

    //animation
    if(changingRoom&&isChanging){
        stretch-=0.1;
        translation+=20*(20-stretch*20);
        scale(stretch,1)
        translate(translation,0);
        if(stretch<0){
            isChanging=false;
        }  
    }
    else if(changingRoom&&!isChanging){
        stretch+=0.1;
        translation-=20*(20-stretch*16);
        scale(stretch,1)
        translate(translation,0);
        if(stretch>1){
            changingRoom=false;
            stretch=1;
            translation=1;
        }
    }
    
    fill(58,58,58);
    arc(xToStart,yToStart,280,280,PI+PI/30,PI+PI/30+PI/2);
    fill(79,79,79);
    arc(xToStart,yToStart,280,280,PI+PI/30+PI/2,PI+PI+PI/8);
    fill(41,41,41);
    arc(xToStart,yToStart,280,280,PI+PI+PI/8,PI/2+PI/20);
    fill(28,28,28);
    arc(xToStart,yToStart,280,280,PI/2+PI/20,PI+PI/30);

    //colored slice
    if(room==1&&!changingRoom){
        document.querySelector(".text-room").innerHTML="Audio parameters";
        document.querySelectorAll(".container-disco-transparent")[0].style.setProperty("display","inline-flex");
        document.querySelectorAll(".container-disco-transparent")[1].style.setProperty("display","none");
        fill(245, 203, 54);
        arc(xToStart,yToStart,dim1,dim1,PI-PI/20,PI+PI/30+PI/2);
        fill(6, 48, 189);
        arc(xToStart,yToStart,dim2,dim2,PI+PI/30+PI/2,PI/40);
        fill(10, 209, 183);
        arc(xToStart,yToStart,dim3,dim3,PI/40,PI/3+PI/8);
        fill(190, 9, 206);
        arc(xToStart,yToStart,dim4,dim4,PI/3+PI/8,PI-PI/20);

    }
    else if(room==2&&!changingRoom){
        document.querySelector(".text-room").innerHTML="Pattern parameters";
        document.querySelectorAll(".container-disco-transparent")[0].style.setProperty("display","none");
        document.querySelectorAll(".container-disco-transparent")[1].style.setProperty("display","inline-flex");
        noFill();
        strokeWeight(4);
        let dimR1=110;
        let dimR2=110;
        let dimR3=110;
        let dimR4=110;
        let dimcoeff=20;
        for(let i=0;i<8;i++){
            if(i<numLines5){
                stroke(245, 203, 54);
            }else{
                stroke(245, 203, 54,120);
            }      
            arc(xToStart,yToStart,dimR1,dimR1,PI-PI/20,PI+PI/30+PI/2);
            if(dimR1<dim1) dimR1+=dimcoeff;
        }
        
        for(let i=0;i<6;i++){
            if(i<numLines6){
                stroke(6, 48, 189);
            }else{
                stroke(6, 48, 189,120);
            } 
            arc(xToStart,yToStart,dimR2,dimR2,PI+PI/30+PI/2,PI/40);
            if(dimR2<dim2) dimR2+=dimcoeff;
        }
        for(let i=0;i<5;i++){
            if(i<numLines7){
                stroke(10, 209, 183);
            }else{
                stroke(10, 209, 183,120);
            } 
            arc(xToStart,yToStart,dimR3,dimR3,PI/40,PI/3+PI/8);
            if(dimR3<dim3) dimR3+=dimcoeff;
        }
        
        for(let i=0;i<7;i++){
            if(i<numLines8){
                stroke(190, 9, 206);
            }else{
                stroke(190, 9, 206,120);
            } 
            arc(xToStart,yToStart,dimR4,dimR4,PI/3+PI/8,PI-PI/20);
            if(dimR4<dim4) dimR4+=dimcoeff;
        }
    }

    fill(0,0,0);
    stroke(56, 56, 56);
    strokeWeight(8);
    circle(xToStart,yToStart,100);

    if(isDown){
        if(buttonPressed=="button-transparent1"){
            if(dim1<350) dim1+=2;
        } 
        else if(buttonPressed=="button-transparent2"){
            if(dim4<350) dim4+=2;
        } 
        else if(buttonPressed=="button-transparent3"){
             if(dim2<350) dim2+=2;
        }
        else if(buttonPressed=="button-transparent4"){
             if(dim3<350) dim3+=2;
        }

        if(buttonPressed=="button-transparent5"){
            if(numLines5<8)numLines5+=0.1;
        } 
        else if(buttonPressed=="button-transparent6"){
            if(numLines8<7)numLines8+=0.1;
        } 
        else if(buttonPressed=="button-transparent7"){
             if(numLines6<6)numLines6+=0.1;
        }
        else if(buttonPressed=="button-transparent8"){
             if(numLines7<5)numLines7+=0.1;
        }       
    }
}