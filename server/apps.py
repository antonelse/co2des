from urllib.parse import parse_qs
from shareyourheart.models import Text
from django.http import JsonResponse
from django.http import HttpResponseRedirect
from django.shortcuts import redirect, render

timer="3"

def get_msgs(request):
    texts=Text.objects.all()
    response={"msgs":[]}
    for text in texts:
        response["msgs"].append(text.text)
    # your code to get color
    return JsonResponse(response)

def send_msg(request):
    global timer
    try:
        query = parse_qs( request.META["QUERY_STRING"])
        # your code to save color
        obj=Text.objects.create(text=query["text"][0])
        obj.save()
        username=obj.text.split("-")[0]
        room=obj.text.split("-")[1];
        response={"status":"ok", "message":"ok"}
    except Exception as exc:
        response={"status":"fail", "message":str(exc)}
    return redirect("https://wemakethings.pythonanywhere.com/static/index.html?username="+username+"&room="+room+"&timer="+timer)

def delete_all(request):
    texts=Text.objects.all()
    #response = redirect("http://wemakethings.pythonanywhere.com/static/index.html")
    #response.mimetype = 'application/json'
    response={"msgs":[]}
    for text in texts:
        text.delete()
    #return redirect("https://wemakethings.pythonanywhere.com/static/index.html")
    return JsonResponse(response)

def increase_timer(request):
    global timer
    timer="10"
    timer.save()
    response={"msgs":[]}
    return JsonResponse(response)

def set_default_timer(request):
    global timer
    timer="3"
    timer.save()
    response={"msgs":[]}
    return JsonResponse(response)