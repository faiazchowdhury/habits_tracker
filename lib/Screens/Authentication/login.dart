import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habits_tracker/Screens/Home/createhabit.dart';
import 'package:habits_tracker/Screens/Home/home.dart';
import 'package:habits_tracker/Screens/Authentication/Widgets/Textfield.dart';
import 'package:habits_tracker/Screens/Authentication/bloc/authenticatebloc_bloc.dart';
import 'package:habits_tracker/Screens/Authentication/registration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_tracker/Screens/ErrorText.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final loginBloc = AuthenticateblocBloc();
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginBloc,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Text(
                    "Hello!\nLet's log you in!",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text("Email"),
                  ),
                  Textfield(emailController, "Enter email"),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text("Password"),
                  ),
                  Textfield(passController, "Enter password"),
                  SizedBox(height: 20),
                  ErrorText(errorText),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: BlocListener(
                      bloc: loginBloc,
                      listener: (context, state) {
                        if (state is AuthenticateblocLoaded) {
                          if (state.statusCode == 200) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Home()),
                              (value) => false,
                            );
                          }
                        }
                      },
                      child: BlocBuilder(
                        bloc: loginBloc,
                        builder: (context, state) {
                          if (state is AuthenticateblocLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return ElevatedButton(
                              onPressed: () {
                                if (emailController.text == "" ||
                                    passController.text == "") {
                                  setState(() {
                                    errorText = "Fields can't be empty";
                                  });
                                } else {
                                  setState(() {
                                    errorText = "";
                                  });
                                  loginBloc.add(
                                    loginUser(
                                      email: emailController.text,
                                      password: passController.text,
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 80),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      children: [
                        TextSpan(
                          text: "No account yet?  ",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        TextSpan(
                          text: "Sign up",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registration(),
                              ),
                            ),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
