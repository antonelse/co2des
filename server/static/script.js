let selectedColor = null;

function sendMessage(){
    var name = document.getElementById("username").value;
    if(name.length < 1 ){
        swal({
            title: "Warning!",
            icon: "warning",
            text: "Insert a username",
        });
    } else if (selectedColor == null) {
        swal({
            title: "Warning!",
            icon: "warning",
            text: "select a color",
        });
    } else {
        message = username + ";" + selectedColor;
        //window.location.href = "http://wemakethings.pythonanywhere.com/send_msg?text="+message;
        console.log("Username: " + name + ", color: " + selectedColor);
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
        }
    }
}

function rgbToHex(rgbString){

}