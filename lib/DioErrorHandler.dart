import 'package:dio/dio.dart';

import 'error_response.dart';

class DioErrorHandler {
  ErrorResponse errorResponse = ErrorResponse();
  String errorDescription = "";




  ErrorResponse handleDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:

        errorResponse.message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        errorResponse.message = "Connection timeout with API server";
        break;
      case DioExceptionType.unknown:

        if((dioError.message?.contains("RedirectException")??false)){
          errorResponse.message = "${dioError.message}";
        }else {
          errorResponse.message = "Please check the internet connection";
        }
        break;
      case DioExceptionType.receiveTimeout:

        errorResponse.message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        try {

          if (dioError.response?.data['message'] != null) {
            errorResponse.message = dioError.response?.data['message'];
          } else if (dioError.response?.data['error'] != null) {
            errorResponse.message = dioError.response?.data['error']['message'];
          }  else {
            if ((dioError.response?.statusMessage ?? "").isNotEmpty)
              errorResponse.message = dioError.response?.statusMessage;
            else
              return _handleError(
                  dioError.response!.statusCode, dioError.response!.data);
          }
        } catch (e) {

          if ((dioError.response?.statusMessage ?? "").isNotEmpty)
            errorResponse.message = dioError.response?.statusMessage;
          else
            return _handleError(
                dioError.response!.statusCode, dioError.response!.data);
        }

        break;
      case DioExceptionType.sendTimeout:

        errorResponse.message = "Send timeout in connection with API server";
        break;
      default:

        errorResponse.message = "Something went wrong";
        break;
    }
    return errorResponse;
  }

  ErrorResponse _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return getMas(error);
    // case 401:
    //   return checkTokenExpire(error);
      case 404:
        return getMas(error);
      case 403:
        return getMas(error);
      case 500:
        errorResponse.message = 'Internal server error';
        return errorResponse;
      default:
        return getUnKnownMes(error);
    }
  }

  // checkTokenExpire(error) {
  //   // print("my error ${error}");
  //   if (error['msg'].toString().toLowerCase() ==
  //       "Token has expired".toLowerCase()) {
  //     UIData.tokenExpire(error['msg']);
  //     return;
  //   }
  //   errorResponse.message = error['msg'].toString();
  //   return errorResponse;
  // }

  getMas(dynamic error) {
    print("myError ${error.runtimeType}");
    if (error.runtimeType != String) {
      errorResponse.message =
          error['message'].toString(); //?? S.of(Get.context).something_wrong;
    } else {
      if (error['msg'] != null) {
        errorResponse.message = error['msg'].toString();
      } else {
        errorResponse.message = "Something Wrong";
      } //S.of(Get.context).something_wrong;
    }
    return errorResponse;
  }

  getUnKnownMes(dynamic error) {
    if (error['msg'] != null) {
      errorResponse.message = error['msg'].toString();
    } else if (error['message'] != null) {
      errorResponse.message = error['message'].toString();
    } else {
      errorResponse.message = "Something went wrong";
    }
    return errorResponse;
  }
}


class ErrorHandler {

  static final ErrorHandler _inst=ErrorHandler.internal();
  ErrorHandler.internal();

  factory ErrorHandler() {
    return _inst;
  }
  ErrorResponse errorResponse=ErrorResponse();

  ErrorResponse handleError(var error) {
    if(error.runtimeType.toString().toLowerCase() =="_TypeError".toLowerCase()){
      // return error.toString();
      errorResponse.message ="The Provided API key is invalid";
      return errorResponse;
    }


    else if(error is DioException) {
      return DioErrorHandler().handleDioError(error);
    }
    errorResponse.message = "The Provided API key is invalid";
    return errorResponse;
  }


}