import http.requests.*;

class API_Client{
  
  GetRequest req;
  GetRequest del;
  GetRequest incr_timer;
  GetRequest def_timer;

  //PostRequest post;
  String get_msg_api="";
  String delete_msg_api="";
  String increase_timer="";
  String default_timer="";
  
  API_Client(String mainUrl){
    this.get_msg_api=mainUrl+"/get_msgs";
    this.delete_msg_api=mainUrl+"/delete_all";
    this.increase_timer=mainUrl+"/increase_timer";
    this.default_timer=mainUrl+"/set_default_timer";
    this.req = new GetRequest(this.get_msg_api); 
    this.del = new GetRequest(this.delete_msg_api);
    this.incr_timer = new GetRequest(this.increase_timer);
    this.def_timer = new GetRequest(this.default_timer);  
  }
  
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

  void delete_all(){
    this.del.send();
  }
  
  Interaction extractData(String msg){
      Interaction inter;
      String[] elements=msg.split("-");
      inter=new Interaction(elements[0],int(elements[2]),int(elements[3]),int(elements[4]),float(elements[5])); //Skipped elements[1] because it's the room value
      return inter;
  } 

  void increase_timer(){
    this.incr_timer.send();
  }

  void set_default_timer(){
    this.def_timer.send();
  }
}
