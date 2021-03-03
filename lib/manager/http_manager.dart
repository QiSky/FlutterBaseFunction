import 'dart:async';

import 'package:base_plugin/export_config.dart';
import 'package:base_plugin/util/sp_util.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// 请求管理
class HttpManager{

  /// 单例
  static HttpManager _instance;

  static HttpManager get instance => _getInstance();

  static const String _METHOD_GET = "get";
  static const String _METHOD_POST = "post";
  static const String _METHOD_DELETE = "delete";
  static const String _METHOD_PUT = "put";

  //网络请求
  static Dio _httpClient;

  ///暴露给外部的网络请求变量
  Dio get httpClient => _httpClient;

  int httpTimeout = 12000;

  HttpManager._internal(){
    _httpClient = Dio();
    _httpClient.options
      ..connectTimeout = httpTimeout
      ..receiveTimeout = httpTimeout
      ..headers = {"Connection": "keep-alive", 'Accept': '*/*', 'Accept-Encoding': 'gzip, deflate, br'};
    _httpClient.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true));
  }

  static HttpManager _getInstance(){
    if(_instance == null)
      _instance = HttpManager._internal();
    return _instance;
  }

  /// get请求
  /// 通用参数描述:
  /// url:请求地址
  /// [params]: FormData类型数据(get请求将自动转换成urlEncode)
  /// [data]: RequestBody类型数据
  /// [headers]: 请求头
  /// [isShowNetworkAvailableToast]: 网络不可用时是否显示默认不可用Toast
  /// [needRetry]: 是否需要重试（如为false，则重试相关参数无效）
  /// [retryTime]: 重试次数
  /// [isShowTimeoutToast]: 网络超时是否要显示默认超时Toast
  /// [retrySuccessCallBack]: 重试成功后回调方法
  /// [networkUnavailableCallBack]: 网络不可用情况下回调方法（并自动抛出异常）
  /// [timeoutCallBack]: 网络请求中出现超时的回调方法
  Future<Response> getRequest(String url,{Map<String, dynamic> params, Map<String, dynamic> headers, bool needRetry = false, int retryTime = 2, bool isShowTimeoutToast = true,bool isShowNetworkAvailableToast = true,
    Function retrySuccessCallBack, Function networkUnavailableCallBack, Function timeoutCallBack}) async{
    _checkNetworkStatus(isShowNetworkAvailableToast, networkUnavailableCallBack);
    Response<dynamic> result = await _request(url, _METHOD_GET, params: params, headers: headers,
        errorCallback: (error) => _handleErrorFunction(error,needRetry,retryTime,isShowTimeoutToast,
            retrySuccessCallBack, timeoutCallBack));
    return result;
  }

  ///post请求
  Future<Response> postRequest(String url,{Map<String, dynamic> params, dynamic data, Map<String, dynamic> headers,
    bool needRetry = false, int retryTime = 2,bool isShowTimeoutToast = true,bool isShowNetworkAvailableToast = true,
    Function retrySuccessCallBack, Function networkUnavailableCallBack, Function timeoutCallBack}) async{
    _checkNetworkStatus(isShowNetworkAvailableToast, networkUnavailableCallBack);
    Response<dynamic> result = await _request(url, _METHOD_POST, params: params, data: data, headers: headers,
        errorCallback: (error) => _handleErrorFunction(error,needRetry,retryTime,isShowTimeoutToast,
            retrySuccessCallBack, timeoutCallBack));
    return result;
  }

  ///put请求
  Future<Response> putRequest(String url,{Map<String, dynamic> params, dynamic data, Map<String, dynamic> headers,
    bool needRetry = false, int retryTime = 2,bool isShowTimeoutToast = true,bool isShowNetworkAvailableToast = true,
    Function retrySuccessCallBack, Function networkUnavailableCallBack, Function timeoutCallBack}) async{
    _checkNetworkStatus(isShowNetworkAvailableToast, networkUnavailableCallBack);
    Response<dynamic> result = await _request(url, _METHOD_PUT, params: params, data: data, headers: headers,
        errorCallback: (error) => _handleErrorFunction(error,needRetry,retryTime,isShowTimeoutToast,
            retrySuccessCallBack, timeoutCallBack));
    return result;
  }

  ///delete请求
  Future<Response> deleteRequest(String url,{Map<String, dynamic> params, dynamic data, Map<String, dynamic> headers,
    bool needRetry = false, int retryTime = 2,bool isShowTimeoutToast = true,bool isShowNetworkAvailableToast = true,
    Function retrySuccessCallBack, Function networkUnavailableCallBack, Function timeoutCallBack}) async{
    _checkNetworkStatus(isShowNetworkAvailableToast, networkUnavailableCallBack);
    Response<dynamic> result = await _request(url, _METHOD_DELETE, params: params, data: data, headers: headers,
        errorCallback: (error) => _handleErrorFunction(error,needRetry,retryTime,isShowTimeoutToast,
            retrySuccessCallBack, timeoutCallBack));
    return result;
  }

  ///检查当前网络是否可用
  void _checkNetworkStatus(bool isShowNetworkAvailableToast,Function networkUnavailableCallBack) {
    if (!ExportConfig.instance.isNetworkConnected) {
      if (isShowNetworkAvailableToast) {
        if(networkUnavailableCallBack != null)
          networkUnavailableCallBack();
        throw Exception();
      }
    }
  }

  ///首次网络请求错误处理
  void _handleErrorFunction(DioError error,bool needRetry, int retryTime, bool isShowTimeoutToast,Function retrySuccessCallBack, Function timeoutCallBack){
    if(error.type == DioErrorType.CONNECT_TIMEOUT || error.type == DioErrorType.SEND_TIMEOUT || error.type == DioErrorType.RECEIVE_TIMEOUT){
      if(isShowTimeoutToast){
        if(timeoutCallBack != null)
          timeoutCallBack();
      }
    }
    if(needRetry && retryTime>0){
      Timer.periodic(Duration(milliseconds: SPUtil.getData("http_base_url") + 500), (timer) async{
        if(retryTime > 0){
          Response tempResult = await _retryRequest(error.request.path, error.request.queryParameters, error.request.data, error.request.headers, error.request.method);
          if(tempResult != null){
            if(retrySuccessCallBack != null)
              retrySuccessCallBack(tempResult);
            retryTime = 0;
            timer?.cancel();
          }
          retryTime--;
        }else
          timer?.cancel();
      });
    }
  }

  Future<Response> _retryRequest(String url,Map<String, dynamic> params, dynamic data, Map<String, dynamic> headers,String method) async{
    Response result;
    try{
      switch(method.trim().toLowerCase()){
          case _METHOD_GET:
            result = await getRequest(url,params: params,headers: headers,isShowNetworkAvailableToast: false, isShowTimeoutToast: false);
          break;
          case _METHOD_POST:
            result = await postRequest(url,params: params,data: data, headers: headers,isShowNetworkAvailableToast: false, isShowTimeoutToast: false);
          break;
          case _METHOD_PUT:
            result = await putRequest(url,params: params,data: data, headers: headers,isShowNetworkAvailableToast: false, isShowTimeoutToast: false);
          break;
          case _METHOD_DELETE:
            result = await deleteRequest(url,params: params,data: data, headers: headers,isShowNetworkAvailableToast: false, isShowTimeoutToast: false);
          break;
          }
    }catch(e){
      result = null;
    }
    return result;
  }

  ///基础请求
  Future<Response> _request(String url, String method, {Map<String, Object> params, Map<String, dynamic> headers, dynamic data,Function errorCallback}) async {
    Response response;
    try {
      if (headers != null)
        _httpClient.options.headers = headers;
      switch(method){
        case _METHOD_GET:
          if (params != null && params.isNotEmpty) {
            StringBuffer sb = new StringBuffer("?");
            params.forEach((key, value) => sb.write("$key" + "=" + "$value" + "&"));
            url += sb.toString().substring(0, sb.toString().length - 1);
          }
          response = await _httpClient?.get(url);
          break;
        case _METHOD_POST:
          if (params != null && params.isNotEmpty)
            response = await _httpClient.post(url, queryParameters: params);
          else if (data != null)
            response = await _httpClient.post(url, data: data);
          else
            response = await _httpClient.post(url);
          break;
        case _METHOD_DELETE:
          if (params != null && params.isNotEmpty)
            response = await _httpClient?.delete(url, queryParameters: params);
          else if (data != null)
            response = await _httpClient?.delete(url, data: data);
          else
            response = await _httpClient?.delete(url);
          break;
        case _METHOD_PUT:
          if (params != null && params.isNotEmpty)
            response = await _httpClient?.put(url, queryParameters: params);
          else if (data != null)
            response = await _httpClient?.put(url, data: data);
          else
            response = await _httpClient?.put(url);
          break;
      }
    } on DioError catch (e) {
      if(errorCallback != null)
        errorCallback(e);
    }
    return response;
  }
}