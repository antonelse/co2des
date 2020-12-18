from django.http import HttpResponseRedirect
from django.shortcuts import render
from django.shortcuts import redirect

def index(request):
    return HttpResponseRedirect("http://wemakethings.pythonanywhere.com/static/index.html")

def redirect_view(request):
    response = redirect("/redirect-success/")
    return response
