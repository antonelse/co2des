import http.requests.*;

class API_Client{
  
  GetRequest req;
  
  //PostRequest post;
  String get_msg_api="";
  // ---- CONSTRUCTOR ----
  API_Client(String mainUrl){
    this.get_msg_api=mainUrl+"/get_msgs";
    this.req = new GetRequest(this.get_msg_api); 
    
  }
  
  // ---- METHODS ----
  String[] get_msgs(){
    this.req.send();
    JSONObject JSONobj = parseJSONObject(req.getContent());
    JSONArray JSONmsgs = JSONobj.getJSONArray("msgs"); 
    String[] msgs=new String[JSONmsgs.size()]; 
    for (int t=0; t<JSONmsgs.size(); t++){      
      msgs[t] = JSONmsgs.getString(t);    
    } 
    return msgs;
  }
}
