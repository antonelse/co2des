function sendMessage(){
    var value=document.getElementById("mytext").value;
    window.location.href = "http://wemakethings.pythonanywhere.com/send_msg?text="+value;
}
function getMessages(){
    window.location.href = "http://wemakethings.pythonanywhere.com/get_msgs";
}
function deleteAll(){
    window.location.href = "http://wemakethings.pythonanywhere.com/delete_all";
    console.log("ciao");
}