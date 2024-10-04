import 'dart:convert';
// import 'package:alice/alice.dart';
// import 'package:beyown_flutter/screens/widgets/custom_loader.dart';
// import 'package:beyown_flutter/screens/widgets/custom_toast.dart';
import 'package:dio/dio.dart' as pdio;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:itp_voice/locator.dart';
import 'package:itp_voice/repo/auth_repo.dart';
import 'package:itp_voice/repo/shares_preference_repo.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/services/numbers_service.dart';
import 'package:itp_voice/storage_keys.dart';
import 'package:itp_voice/widgets/custom_loader.dart';
import 'package:itp_voice/widgets/custom_toast.dart';

class BaseRequester {
  final AuthRepo _authRepo = AuthRepo();
  // late String baseURL = "https://gym.vidseries.com/";
  // late String BearerImageUrl = "https://gym.vidseries.com/";
  late String BearerImageUrl = "https://gym.globalcaregroup.net/";
  // late String imagesUrl = "https://gym.vidseries.com/static/images/";
  late String imagesUrl = "https://gym.globalcaregroup.net/static/images/";

  // late FirebaseAuth _auth = FirebaseAuth.instance;

  String? token;

  // static NavigationService _navigationService = locator<NavigationService>();

  // static Alice alice = Alice(
  //     showNotification: true,
  //     navigatorKey: Get.rootController.key,
  //     darkTheme: true);

  Future baseGetAPI(url,
      {successMsg,
      loading,
      status,
      utfDecoded,
      bool return404 = false,
      bool errorToast = true,
      bool direct = false}) async {
    // Map data = await SharedPreferencesMethod.getUserInfo();
    await updateToken();
    // _auth.passw

    if (loading == true && loading != null) {
      CustomLoader.showLoader();
    }

    // String bearerAuth = 'Bearer ' + data['token'];

    String bearerAuth = 'Bearer $token';

    print(url);
    http.Response response;
    try {
      print("------base request.dart-----Url----1---$url");
      response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': bearerAuth
        },
      );
      print("------base request.dart-----baseGetAPI----2---${response.body}");
      _logRequestOnAlice(response);
      print("------base request.dart----line no 68-Url----3---");
      
      // log(response.body.toString());
      if (loading == true && loading != null) {
        CustomLoader.dismisLoader();
      }

      if (direct == true) {
        return response.body;
      }

      if (status != null) {
        return response.statusCode;
      }

      var jsonData;
      if (response.statusCode == 200) {
        if (utfDecoded == true) {
          jsonData = json.decode(utf8.decode(response.bodyBytes));

          return jsonData;
        }
        jsonData = json.decode(response.body);
        if (successMsg != null) {
          CustomToast.showToast(successMsg, false);
        }
        return jsonData;
      } else if (response.statusCode == 401) {
        _authRepo.logoutUser();
        final bool rememberMe =
            SharedPreferencesMethod.getBool(StorageKeys.REMEMBER)!;
        if (rememberMe) {
          Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
          CustomToast.showToast("Session expired, Please login again", true);
          return response.statusCode;
        } else {
          var tryRelogin = await _authRepo.reLoginUser();

          ///Commented
          // if (tryRelogin.runtimeType == String) {
          //   _authRepo.logoutUser();
          //   Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
          //   CustomToast.showToast("Session expired, Please login again", true);
          //   return;
          // }
          // if (tryRelogin) {
          //   final response = await baseGetAPI(url);
          //   return response;
          // }
          if (tryRelogin.runtimeType == String) {
            CustomToast.showToast(tryRelogin.toString(), true);

            return;
          }
          if (tryRelogin == null) {
            CustomToast.showToast("Unexpected error occurred", true);

            return;
          } else {
            await locator<NumbersService>().getUpdatedNumbersList();
            Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);
          }
        }
      } else {
        jsonData = json.decode(response.body);
      }
    } catch (SocketException) {
      print(SocketException);
      if (loading == true && loading != null) {
        CustomLoader.dismisLoader();
      }
      CustomToast.showToast(
        
          "There seems to be your network problem or a server side issue. Please try again or report the bug to the manager.",
          false);

      return null;
    }
  }

  Future basePostAPI(url, body,
      {successMsg, loading, protected = false, bool useDio = false}) async {
    protected ? await updateToken() : null;

    if (loading == true && loading != null) {
      // CustomLoader.showLoader();

      // EasyLoading.show(status: 'Please wait...',indicator: Container(height: 100,width: 100,color: Colors.red,),);
    }

    String bearerAuth = 'Bearer $token';

    if (useDio) {
      try {
        pdio.Dio dio = pdio.Dio();
        pdio.Response resp = await dio.post(
          url,
          data: pdio.FormData.fromMap(body),
          options: pdio.Options(
            headers: {
              'Authorization': bearerAuth,
            },
          ),
        );
        if (resp.statusCode == 200) {
          print("Check 1: ${resp.data}");
          return resp.data;
        } else {
          print("Unexpected status code: ${resp.statusCode}");
        }
        return null;
      } catch (e) {
        print("Error in Dio request:");
        if (e is pdio.DioError) {
          // Print detailed response data for debugging
          print("Error Status Code: ${e.response?.statusCode}");
          print("Error Data: ${e.response?.data}");
          print("Error Headers: ${e.response?.headers}");
        } else {
          print("Unexpected error: $e");
        }
        return null;
      }
    }

    http.Response response;
    print(body);
    print(url);

    try {
      response = await http.post(
        Uri.parse(url),
        headers: protected
            ? <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': bearerAuth
              }
            : <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
        body: body,
      );

      _logRequestOnAlice(response);
      // CustomLoader.dismisLoader();

      var jsonData;
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (successMsg != null) {
          CustomToast.showToast(successMsg, false);
        }
        if (jsonData['isSuccess'] == false) {
          CustomToast.showToast(jsonData['message'], true);
          return;
        }
        return jsonData;
      } else if (response.statusCode == 400) {
        jsonData = json.decode(response.body);
        return jsonData;
      } else if (response.statusCode == 401) {
        // _authRepo.logoutUser();
        // Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
        // CustomToast.showToast("Session expired, Please login again", true);
        // return;
        _authRepo.logoutUser();
        final bool rememberMe =
            SharedPreferencesMethod.getBool(StorageKeys.REMEMBER)!;
        if (rememberMe) {
          Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
          CustomToast.showToast("Session expired, Please login again", true);
          return response.statusCode;
        } else {
          var tryRelogin = await _authRepo.reLoginUser();
          if (tryRelogin.runtimeType == String) {
            CustomToast.showToast(tryRelogin.toString(), true);

            return;
          }
          if (tryRelogin == null) {
            CustomToast.showToast("Unexpected error occurred", true);

            return;
          } else {
            await locator<NumbersService>().getUpdatedNumbersList();
            Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);
          }
          // if (protected == false) {
          //   jsonData = json.decode(response.body);

          //   return jsonData;
          // }
          // var tryRelogin = await _authRepo.reLoginUser();
          // if (tryRelogin.runtimeType == String) {
          //   _authRepo.logoutUser();
          //   Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
          //   CustomToast.showToast("Session expired, Please login again", true);
          //   return;
          // }
          // if (tryRelogin) {
          //   final response = await basePostAPI(url, body, protected: protected);
          //   return response;
          // }
          // jsonData = json.decode(response.body); //

          // return jsonData; //
        }
      } else {
        throw Exception('Failed');
      }
    } catch (SocketException) {
      print(SocketException);
      // CustomLoader.dismisLoader();
      return null;
    }
  }

  Future basePatchAPI(url, body,
      {successMsg, loading, protected = false, bool jsonType = true}) async {
    protected ? await updateToken() : null;

    if (loading == true && loading != null) {
      // CustomLoader.showLoader();

      // EasyLoading.show(status: 'Please wait...',indicator: Container(height: 100,width: 100,color: Colors.red,),);
    }

    String bearerAuth = 'Bearer $token';

    http.Response response;
    print(body);
    print(url);

    try {
      response = await http.patch(Uri.parse(url),
          headers: protected
              ? jsonType == true
                  ? <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization': bearerAuth
                    }
                  : <String, String>{'Authorization': bearerAuth}
              : <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
          body: (body));

      _logRequestOnAlice(response);
      // CustomLoader.dismisLoader();

      var jsonData;
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (successMsg != null) {
          CustomToast.showToast(successMsg, false);
        }
        if (jsonData['isSuccess'] == false) {
          CustomToast.showToast(jsonData['message'], true);
          return;
        }
        return jsonData;
      } else if (response.statusCode == 400) {
        jsonData = json.decode(response.body);
        return jsonData;
      } else if (response.statusCode == 401) {
        _authRepo.logoutUser();
        final bool rememberMe =
            SharedPreferencesMethod.getBool(StorageKeys.REMEMBER)!;
        if (rememberMe) {
          Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
          CustomToast.showToast("Session expired, Please login again", true);
          return response.statusCode;
        } else {
          var tryRelogin = await _authRepo.reLoginUser();
          if (tryRelogin.runtimeType == String) {
            CustomToast.showToast(tryRelogin.toString(), true);

            return;
          }
          if (tryRelogin == null) {
            CustomToast.showToast("Unexpected error occurred", true);

            return;
          } else {
            await locator<NumbersService>().getUpdatedNumbersList();
            Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);
          }
        }
        // if (protected == false) {
        //   jsonData = json.decode(response.body);

        //   return jsonData;
        // }
        // var tryRelogin = await _authRepo.reLoginUser();
        // if (tryRelogin.runtimeType == String) {
        //   _authRepo.logoutUser();
        //   Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
        //   CustomToast.showToast("Session expired, Please login again", true);
        //   return;
        // }
        // if (tryRelogin) {
        //   final response = await basePostAPI(url, body, protected: protected);
        //   return response;
        // }
        // jsonData = json.decode(response.body); //

        // return jsonData; //
      } else {
        throw Exception('Failed');
      }
    } catch (SocketException) {
      print(SocketException);
      // CustomLoader.dismisLoader();
      return null;
    }
  }

  Future basePutAPI(url, body, {successMsg, loading, protected = false}) async {
    protected ? await updateToken() : null;

    if (loading == true && loading != null) {
      CustomLoader.showLoader();
    }

    String bearerAuth = 'Bearer $token';

    http.Response response;

    try {
      response = await http.put(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': bearerAuth
          },
          body: jsonEncode(body));

      _logRequestOnAlice(response);
      CustomLoader.dismisLoader();

      var jsonData;
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (successMsg != null) {
          CustomToast.showToast(successMsg, false);
        }
        return jsonData;
      } else if (response.statusCode == 400) {
        jsonData = json.decode(response.body);
        // CustomToast.showToast("Error",jsonData["message"], true);
        // return {};
        return jsonData;
      } else if (response.statusCode == 401) {
        _authRepo.logoutUser();
        final bool rememberMe =
            SharedPreferencesMethod.getBool(StorageKeys.REMEMBER)!;
        if (rememberMe) {
          Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
          CustomToast.showToast("Session expired, Please login again", true);
          return response.statusCode;
        } else {
          var tryRelogin = await _authRepo.reLoginUser();
          if (tryRelogin.runtimeType == String) {
            CustomToast.showToast(tryRelogin.toString(), true);

            return;
          }
          if (tryRelogin == null) {
            CustomToast.showToast("Unexpected error occurred", true);

            return;
          } else {
            await locator<NumbersService>().getUpdatedNumbersList();
            Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);
          }
        }
        // var tryRelogin = await _authRepo.reLoginUser();
        // if (tryRelogin.runtimeType == String) {
        //   _authRepo.logoutUser();
        //   Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
        //   CustomToast.showToast("Session expired, Please login again", true);
        //   return;
        // }
        // if (tryRelogin) {
        //   final response = await basePutAPI(url, body, protected: protected);
        //   return response;
        // }
      } else {
        throw Exception('Failed');
      }
    } catch (SocketException) {
      print(SocketException);
      CustomLoader.dismisLoader();
      return null;
    }
  }

  Future baseDeleteAPI(url, body,
      {successMsg, loading, protected = false}) async {
    protected ? await updateToken() : null;

    if (loading == true && loading != null) {
      CustomLoader.showLoader();
    }

    String bearerAuth = 'Bearer $token';

    http.Response response;

    try {
      response = await http.delete(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': bearerAuth
          },
          body: jsonEncode(body));

      _logRequestOnAlice(response);
      CustomLoader.dismisLoader();

      var jsonData;
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (successMsg != null) {
          CustomToast.showToast(successMsg, false);
        }
        return jsonData;
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        jsonData = json.decode(response.body);
        // CustomToast.showToast("Error",jsonData["message"], true);
        // return {};
        return jsonData;
      } else if (response.statusCode == 401) {
        _authRepo.logoutUser();
        final bool rememberMe =
            SharedPreferencesMethod.getBool(StorageKeys.REMEMBER)!;
        if (rememberMe) {
          Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
          CustomToast.showToast("Session expired, Please login again", true);
          return response.statusCode;
        } else {
          var tryRelogin = await _authRepo.reLoginUser();
          if (tryRelogin.runtimeType == String) {
            CustomToast.showToast(tryRelogin.toString(), true);

            return;
          }
          if (tryRelogin == null) {
            CustomToast.showToast("Unexpected error occurred", true);

            return;
          } else {
            await locator<NumbersService>().getUpdatedNumbersList();
            Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);
          }
        }
        // var tryRelogin = await _authRepo.reLoginUser();
        // if (tryRelogin.runtimeType == String) {
        //   _authRepo.logoutUser();
        //   Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
        //   CustomToast.showToast("Session expired, Please login again", true);
        //   return;
        // }
        // if (tryRelogin) {
        //   final response = await baseDeleteAPI(url, body, protected: protected);
        //   return response;
        // }
      } else {
        throw Exception('Failed');
      }
    } catch (SocketException) {
      print(SocketException);
      CustomLoader.dismisLoader();

      return null;
    }
  }

  static void _logRequestOnAlice(http.Response response) {
    // if (isDevelopmentMode == true) {
    // alice.onHttpResponse(response);
    // }
  }

  Future updateToken() async {
    final String _token =
        SharedPreferencesMethod.getString(StorageKeys.REFRESH_TOKEN)!;
    token = _token;
  }
}

class BaseRequesterMethods {
  static var baseRequester = Get.find<BaseRequester>();
}
