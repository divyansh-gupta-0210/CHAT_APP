import 'package:chat_app/Helper/helperfunctions.dart';
import 'package:chat_app/Services/auth.dart';
import 'package:chat_app/Services/database.dart';
import 'package:chat_app/View/chatroomscreen.dart';
import 'package:chat_app/Widgets/widget.dart';
import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethod authMethods = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameEditingController =
      new TextEditingController();
  TextEditingController emailEditingController =
      new TextEditingController();
  TextEditingController passwordEditingController =
      new TextEditingController();

  signMeUp() async{
    if (formKey.currentState.validate()) {

      Map<String, String> userInfoMap = {
        "name": usernameEditingController.text,
        "email": emailEditingController.text
      };

      HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

      setState(() {
        isLoading = true;
      });
      await authMethods
          .signUpWithEmailAndPassword(emailEditingController.text,
          passwordEditingController.text)
          .then((value) {
        // print("$value");

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              style: simpleTextStyle(),
                              controller: usernameEditingController,
                              validator: (val){
                                return val.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                              },
                              decoration: textFieldInputDecoration("username"),
                            ),
                            TextFormField(
                              controller: emailEditingController,
                              style: simpleTextStyle(),
                              validator: (val){
                                return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                                null : "Enter correct email";
                              },
                              decoration: textFieldInputDecoration("email"),
                            ),
                            TextFormField(
                              obscureText: true,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("password"),
                              controller: passwordEditingController,
                              validator:  (val){
                                return val.length < 6 ? "Enter Password 6+ characters" : null;
                              },

                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Forgot Password?',
                          style: simpleTextStyle(),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          //TODO
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xff007EF4),
                                  const Color(0xff2A75BC)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      // Container(
                      //   alignment: Alignment.center,
                      //   width: MediaQuery.of(context).size.width,
                      //   padding: EdgeInsets.symmetric(vertical: 20),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(30),
                      //   ),
                      //   child: Text(
                      //     "Sign In with Google",
                      //     style: TextStyle(
                      //       color: Colors.black87,
                      //       fontSize: 17,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: mediumTextStyle(),
                          ),
                          GestureDetector(
                            onTap: (){
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Stack(
                                children: <Widget>[
                                  Text(
                                    " Sign-In Now!",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Positioned(
                                    bottom: 1,
                                    child: Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.indigoAccent,
                                            Colors.purpleAccent
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
