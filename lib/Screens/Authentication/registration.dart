import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habits_tracker/Screens/Authentication/Home/home.dart';
import 'package:habits_tracker/Screens/Authentication/Widgets/Textfield.dart';
import 'package:habits_tracker/Screens/Authentication/bloc/authenticatebloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_tracker/Screens/ErrorText.dart';

class Registration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final nameController = TextEditingController();
  int pressed = 0;
  bool boxChecked = false;
  String errorText = "";

  final registerBloc = AuthenticateblocBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => registerBloc,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Text(
                  "Hello!\nLet's get you started!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text("Name"),
                ),
                Textfield(nameController, "Enter name"),
                SizedBox(height: 20),
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
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text("Confrim Password"),
                ),
                Textfield(confirmPassController, "Confirm Password"),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text("Gender"),
                ),
                Card(
                  elevation: 3,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            pressed = 1;
                          }),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: pressed == 1
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Male",
                              style: TextStyle(
                                color: pressed == 1
                                    ? Theme.of(context).scaffoldBackgroundColor
                                    : Theme.of(
                                        context,
                                      ).textTheme.bodyLarge!.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            pressed = 2;
                          }),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: pressed == 2
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Female",
                              style: TextStyle(
                                color: pressed == 2
                                    ? Theme.of(context).scaffoldBackgroundColor
                                    : Theme.of(
                                        context,
                                      ).textTheme.bodyLarge!.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            pressed = 3;
                          }),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: pressed == 3
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Other",
                              style: TextStyle(
                                color: pressed == 3
                                    ? Theme.of(context).scaffoldBackgroundColor
                                    : Theme.of(
                                        context,
                                      ).textTheme.bodyLarge!.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: boxChecked,
                      onChanged: (flag) {
                        setState(() {
                          boxChecked = flag!;
                        });
                      },
                    ),
                    Text(
                      "Accept Terms and Conditions",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 10),
                ErrorText(errorText),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: BlocListener(
                    bloc: registerBloc,
                    listener: (context, state) {
                      if (state is AuthenticateblocLoaded) {
                        if (state.statusCode == 200) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Home()),
                            (route) => false,
                          );
                        }
                      }
                    },
                    child: BlocBuilder(
                      bloc: registerBloc,
                      builder: (context, state) {
                        if (state is AuthenticateblocLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ElevatedButton(
                            onPressed: () {
                              if (boxChecked) {
                                if (nameController.text != "" &&
                                    passController.text != "" &&
                                    emailController.text != "" &&
                                    pressed != 0) {
                                  if (RegExp(
                                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
                                  ).hasMatch(passController.text)) {
                                    if (confirmPassController.text ==
                                        passController.text) {
                                      setState(() {
                                        errorText = "";
                                      });
                                      registerBloc.add(
                                        resgisterUser(
                                          name: nameController.text,
                                          password: passController.text,
                                          email: emailController.text,
                                          gender: pressed == 1
                                              ? "male"
                                              : pressed == 2
                                              ? "female"
                                              : "other",
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        errorText = "Passwords don't match";
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      errorText =
                                          "Password must have atleast 8 characters, upper case, lower case and number";
                                    });
                                  }
                                } else {
                                  setState(() {
                                    errorText = "Fields cannot be left empty";
                                  });
                                }
                              } else {
                                setState(() {
                                  errorText =
                                      "Need to agree to the terms and condition";
                                });
                              }
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    children: [
                      TextSpan(
                        text: "Already have an account?  ",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      TextSpan(
                        text: "Sign in",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Registration(),
                            ),
                          ),
                        style: TextStyle(color: Theme.of(context).primaryColor),
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
}
