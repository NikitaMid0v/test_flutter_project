// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:test_flutter_project/model/user.dart';
// import 'package:test_flutter_project/services/auth.dart';
//
// class UserDetailsPage extends StatefulWidget {
//   UserDetailsPage({Key key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => UserDetailsPageState();
// }
//
// class UserDetailsPageState extends State<UserDetailsPage> {
//   TextEditingController _firstNameController = TextEditingController();
//   TextEditingController _lastNameController = TextEditingController();
//
//
//   String _email;
//   String _password;
//   bool showLogin = true;
//
//   AuthService _authService = AuthService();
//
//   Widget _input(String hint, TextEditingController textController,
//       bool obscure) {
//     return Container(
//         padding: EdgeInsets.only(left: 20, right: 20),
//         child: TextField(
//           controller: textController,
//           obscureText: obscure,
//           style: TextStyle(fontSize: 20, color: Colors.black),
//           decoration: InputDecoration(
//             hintStyle: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                 color: Colors.black38),
//             hintText: hint,
//             focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.black, width: 3)),
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.black, width: 3)),
//           ),
//         )
//     );
//   }
//
//   Widget _button(String label, void onPress()){
//     return RaisedButton(
//       splashColor: Theme.of(context).primaryColor,
//       highlightColor: Theme.of(context).primaryColor,
//       color: Colors.red,
//       child: Text(
//           label,
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
//       ),
//       onPressed: () => {
//         onPress()
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//       return Container(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.only(bottom: 20, top: 10),
//               child: _input("First name", _firstNameController, false),
//             ),
//             Padding(
//               padding: EdgeInsets.only(bottom: 20, top: 10),
//               child: _input("Last name", _lastNameController, true),
//             ),
//             SizedBox(height: 20),
//             // Padding(
//             //   padding: EdgeInsets.only(left: 20, right: 20),
//             //   child: Container(
//             //     height: 50,
//             //     width: MediaQuery
//             //         .of(context)
//             //         .size
//             //         .width,
//             //     child: _button(label, onPress),
//             //   ),
//             // )
//           ],
//         ),
//       );
//
//
//     // void _loginUser() async {
//     //   _email = _emailController.text;
//     //   _password = _passwordController.text;
//     //
//     //   if(_email.isEmpty || _password.isEmpty){
//     //     return;
//     //   }
//     //
//     //   User user = await _authService.signInWithEmailAndPassword(_email.trim(), _password.trim());
//     //   if(user == null){
//     //     Fluttertoast.showToast(
//     //         msg: "Can't sign in. Invalid email or password",
//     //         toastLength: Toast.LENGTH_SHORT,
//     //         gravity: ToastGravity.CENTER,
//     //         backgroundColor: Colors.red,
//     //         textColor: Colors.white,
//     //         fontSize: 16.0
//     //     );
//     //   }
//     //   else {
//     //     _emailController.clear();
//     //     _passwordController.clear();
//     //   }
//     // }
//     //
//     // void _signUpUser() async {
//     //   _email = _emailController.text;
//     //   _password = _passwordController.text;
//     //   if(_email.isEmpty || _password.isEmpty){
//     //     return;
//     //   }
//     //
//     //   User user = await _authService.signUpWithEmailAndPassword(_email.trim(), _password.trim());
//     //   if(user == null){
//     //     Fluttertoast.showToast(
//     //         msg: "Can't sign up. Invalid email or password",
//     //         toastLength: Toast.LENGTH_SHORT,
//     //         gravity: ToastGravity.CENTER,
//     //         backgroundColor: Colors.red,
//     //         textColor: Colors.white,
//     //         fontSize: 16.0
//     //     );
//     //   }
//     //   else {
//     //     _emailController.clear();
//     //     _passwordController.clear();
//     //   }
//     // }
//
//     // return Scaffold(
//     //   body: Column(
//     //     children: [
//     //       SizedBox(height: 43),
//     //       (
//     //           showLogin
//     //               ?
//     //           Column(
//     //             children: <Widget>[
//     //               _form("LOGIN", _loginUser),
//     //               Padding(
//     //                 padding: EdgeInsets.all(10),
//     //                 child: GestureDetector(
//     //                   child: Text("Don't have an account? Sign up.", style: TextStyle(fontSize: 20, color: Colors.black),),
//     //                   onTap:() {
//     //                     setState((){
//     //                       showLogin = false;
//     //                     });
//     //                   },
//     //                 ),
//     //               )
//     //             ],
//     //           )
//     //               :
//     //           Column(
//     //             children: <Widget>[
//     //               _form("SIGN UP", _signUpUser),
//     //               Padding(
//     //                 padding: EdgeInsets.all(10),
//     //                 child: GestureDetector(
//     //                   child: Text("Already have an account? Login.", style: TextStyle(fontSize: 20, color: Colors.black),),
//     //                   onTap:() {
//     //                     setState((){
//     //                       showLogin = true;
//     //                     });
//     //                   },
//     //                 ),
//     //               )
//     //             ],
//     //           )
//     //       )
//     //     ],
//     //   ),
//     // );
//   }
// }
