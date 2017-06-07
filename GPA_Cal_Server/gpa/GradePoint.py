#!/usr/bin/env python3
# coding=utf-8
import re
from http import cookiejar
# from urllib import request, parse
import urllib.request, urllib.parse
import json
import random
import socket
from django.http import HttpResponse

agents = [
    "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
    "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
    "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0",
    "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)",
    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
    "Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
    "Opera/9.80 (Macintosh; Intel Mac OS X 10.6.8; U; en) Presto/2.8.131 Version/11.11",
    "Opera/9.80 (Windows NT 6.1; U; en) Presto/2.8.131 Version/11.11",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Maxthon 2.0)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; TencentTraveler 4.0)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; The World)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; SE 2.X MetaSr 1.0; SE 2.X MetaSr 1.0; .NET CLR 2.0.50727; SE 2.X MetaSr 1.0)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; 360SE)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Avant Browser)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)"
]

headers = {
    'User-Agent': random.choice(agents)
}


def getUserAgentHeader():
    return headers



def getGPA(request, username, password):
    # try:
        postdata = {
            'userName': username,
            'password': password
        }

        # # 登录教务系统的URL
        loginUrl = 'http://jw.nju.edu.cn:8080/jiaowu/login.do'

        cookie = cookiejar.CookieJar()  # 创建cookiejar用于保存cookie
        cjhdr = urllib.request.HTTPCookieProcessor(cookie)  # 创建cookiehandler用于管理http的cookie
        opener = urllib.request.build_opener(cjhdr)  # 将cookiehandler注册并生成一个opener之后使用这个opener就可以自动保存cookie
        socket.setdefaulttimeout(5)  # 设置全局timeout
        loginPostData = urllib.parse.urlencode(postdata).encode('utf-8')
        loginRequest = urllib.request.Request(loginUrl, loginPostData, method='POST')  # 创建post请求
        response = opener.open(loginRequest)  # 请求request

        commonUrl = 'http://jw.nju.edu.cn:8080/jiaowu/student/studentinfo/achievementinfo.do?method=searchTermList'
        get_request = urllib.request.Request(commonUrl)  # 创建request
        commonPage = opener.open(get_request).read().decode()

        termItems = re.findall(r'<tr align="center" height="22">\s+<td><a  href="(.*?)".*?</a> </td>\s+</tr>',
                               commonPage)

        result_list = []
        # 对每一个学期的成绩统计
        for item in termItems:
            term_list = []
            # 利用cookie请求访问另一个网址
            gradeUrl = 'http://jw.nju.edu.cn:8080/jiaowu/' + item
            # 请求访问该网址
            get_request = urllib.request.Request(gradeUrl)  # 创建request
            gradePage = opener.open(get_request).read().decode()

            term_name = re.findall(r'<a style="font-size: 14px; text-align: center;font-weight: bold;">(.*?)</a>',
                                   gradePage, re.S)[0]
            term_dict = {"term": term_name}
            # 正则表达式读取
            detailScoreItems = re.findall('<td valign="middle">(.*?)</td>.*?'
                                          '<td valign="middle">(.*?)</td>.*?'
                                          '<td align="center" valign="middle">\s+(.*?)\s+</td>.*?'
                                          '<td align="center" valign="middle">(.*?)</td>.*?'
                                          '<td align="center" valign="middle">\s+<ul\s+style="color:black"\s+>\s+(.*?)\s+</ul>\s+</td>',
                                          gradePage, re.S)

            # 对每一项课程的成绩统计
            for item in detailScoreItems:
                # print '====='
                # print item[0]
                # print item[1]
                # print item[2]
                # print item[3]
                # print item[4]
                term_list.append({"chinese_name": item[0],
                                  "english_name": item[1],
                                  "type": item[2],
                                  "credit": item[3],
                                  "score": item[4]})
            term_dict["course_list"] = term_list
            result_list.append(term_dict)
        return HttpResponse(json.dumps(result_list, ensure_ascii=False))
    # except:
        # return HttpResponse("Fail")

