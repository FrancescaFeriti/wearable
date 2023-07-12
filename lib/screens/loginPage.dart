import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flow1_prova/screens/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flow1_prova/utils/impact.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routename = 'LoginPage';

  @override
  _stateLoginPage createState() => _stateLoginPage();
}

class _stateLoginPage extends State<LoginPage> {
  final TextEditingController myController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  } //dispose

  @override
  void initState() {
    super.initState();
    //check if the user is already logged in before rendering the login page
    _checkLogin();
  } //initState()

  void _checkLogin() async {
    final sp = await SharedPreferences.getInstance();
    if (sp.getString('access') != 'null') {
      //if (...){
      // _refreshTokens()

      //bisognerebbe anche controllare che il token di accesso sia ancora valido
      //altrimenti si fa il refresh dei token
      //if username is already set, I open the HomePage
      _toHomePage(context);
    } //if
  } //_checklogin

  Future<void> _loginUser(String? credentials, String? password) async {
    if (credentials != null && password != null) {
      //non dobbiamo controllare l'username, ma i token
      final result = await _authorize();
      if (result == 200) {
        _toHomePage(context);
      } else {
        print('Request failed');
      }
      //if ((credentials == Impact.username) && (password == Impact.password)) {
      //  final sp = await SharedPreferences.getInstance();
      //  sp.setString('username', credentials);
      //  sp.setString('password', password);
      //  _toHomePage(context);
      //} else {
      //  ScaffoldMessenger.of(context)
      //  ..removeCurrentMaterialBanner()
      //  ..showSnackBar(SnackBar(content: Text('Wrong Credentials'),));
      //}
    }
  } //_loginUser

  @override
  Widget build(BuildContext context) {
    String? credentials;
    String? password;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  child: Image.asset(
                    'assets/images/background_login.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 7,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 25, sigmaX: 25),
                            child: SizedBox(
                              width: size.width * .9,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: size.width * .15,
                                      bottom: size.width * .1,
                                    ),
                                    child: const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                    child: Container(
                                      height: size.width / 8,
                                      width: size.width / 1.25,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(right: size.width / 30),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextFormField(
                                        controller: myController,
                                        style: const TextStyle(color: Colors.white),
                                        onChanged: (newValue) => credentials = myController.text,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.account_circle_outlined,
                                            color: Colors.white,
                                          ),
                                          border: InputBorder.none,
                                          hintMaxLines: 1,
                                          hintText: 'Enter your username...',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                    child: Container(
                                      height: size.width / 8,
                                      width: size.width / 1.25,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(right: size.width / 30),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextFormField(
                                        controller: passwordController,
                                        style: const TextStyle(color: Colors.white),
                                        onChanged: (newValue) => password = passwordController.text,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.lock_outlined,
                                            color: Colors.white,
                                          ),
                                          border: InputBorder.none,
                                          hintMaxLines: 1,
                                          hintText: 'Enter your password...',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Forgotten password!',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              HapticFeedback.lightImpact();
                                              Fluttertoast.showToast(
                                                msg: 'Forgotten password! button pressed',
                                              );
                                            },
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Create a new Account',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              HapticFeedback.lightImpact();
                                              Fluttertoast.showToast(
                                                msg: 'Create a new Account button pressed',
                                              );
                                            },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.width * .3),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 3,
                                      alignment: Alignment.center,
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.black.withOpacity(.1),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      fixedSize: Size(size.width / 1.25, size.width / 8),
                                    ),
                                    onPressed: () async {
                                      credentials = myController.text;
                                      password = passwordController.text;
                                      print('credentials: $credentials, password: $password');
                                      if (credentials != null && password != null) {
                                        if (credentials == Impact.username && password == Impact.password) {
                                          await _loginUser(credentials, password);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                            ..removeCurrentMaterialBanner()
                                            ..showSnackBar(const SnackBar(
                                              content: Text('Wrong Credentials'),
                                            ));
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Sign-In',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
  } //_toHomePage

  Future<int?> _authorize() async {
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': Impact.username, 'password': Impact.password};

    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);
    print('Response Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    } //if
    return response.statusCode;
  } //_authorize

  Future<int> _refreshTokens() async {
    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If the response is OK, set the tokens in SharedPreferences to the new values
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
  } //_refreshTokens

  Future<int?> _getTokens() async {
    return null;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
