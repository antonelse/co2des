from urllib.parse import parse_qs
from shareyourheart.models import Text
from django.http import JsonResponse
from django.http import HttpResponseRedirect
from django.shortcuts import redirect, render

def get_msgs(request):
    texts=Text.objects.all()
    response={"msgs":[]}
    for text in texts:
        response["msgs"].append(text.text)
    # your code to get color
    return JsonResponse(response)

def send_msg(request):
    try:
        query = parse_qs( request.META["QUERY_STRING"])
        # your code to save color
        obj=Text.objects.create(text=query["text"][0])
        obj.save()
        response={"status":"ok", "message":"ok"}
    except Exception as exc:
        response={"status":"fail", "message":str(exc)}
    return redirect("http://wemakethings.pythonanywhere.com/static/index.html")

def delete_all(request):
    texts=Text.objects.all()
    for text in texts:
        text.delete()
    #response = redirect("http://wemakethings.pythonanywhere.com/static/index.html")
    #response.mimetype = 'application/json'
    #return redirect("http://wemakethings.pythonanywhere.com/static/index.html")