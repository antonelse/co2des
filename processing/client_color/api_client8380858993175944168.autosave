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
    interaction.clear();
    for (int t=0; t<JSONmsgs.size(); t++){      
      msgs[t] = JSONmsgs.getString(t);
      interaction.add(extractData(msgs[t]));
    } 
    return msgs;
  }
  
  Interaction extractData(String msg){
      Interaction inter;
      String[] elements=msg.split("-");
      inter=new Interaction(elements[0],int(elements[1]),int(elements[2]),int(elements[3]),float(elements[4]));
      return inter;
  } 
}
