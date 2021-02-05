from django.shortcuts import render

# Create your views here.
import json
import time

from rest_framework.decorators import action 
from rest_framework.response import Response 
from rest_framework.viewsets import ModelViewSet 

class Test(ModelViewSet):
    """
    
    """
    @action(methods=['get'], detail=False)
    def test_get(self, request, *args, **kwargs):
        """
            test "get" request
        """
        print(f"test_get:{request.query_params}")
        return Response({'msg':'ok', 'data': request.query_params})

    @action(methods=['post'], detail=False)
    def test_post(self, request, *args, **kwargs):
        """
            测试post 请求
        """
        print(f"test_post:{request.data}")
        return Response({'msg':'ok', 'data':request.data})
