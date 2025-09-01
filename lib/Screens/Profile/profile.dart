import 'package:flutter/material.dart';
import 'package:habits_tracker/Screens/Home/drawer.dart';
import 'package:habits_tracker/Screens/Authentication/Widgets/Textfield.dart';
import 'package:habits_tracker/Screens/Profile/bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final profileBloc = ProfileBloc();
  final nameController = TextEditingController();
  bool updatedFlag = false;
  int pressed = 0;
  @override
  void initState() {
    nameController.text = "ASdsadf";
    profileBloc.add(getProfileInfo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text("Profile")),
      body: BlocProvider(
        create: (context) => profileBloc,
        child: BlocListener(
          bloc: profileBloc,
          listener: (context, state) {
            if (state is ProfileLoaded) {
              DocumentSnapshot res = state.response;
              nameController.text = res.get('name');
              pressed = res.get('gender') == "male"
                  ? 1
                  : res.get('gender') == "other"
                  ? 3
                  : 2;
              updatedFlag=false;
            }
          },
          child: BlocBuilder(
            bloc: profileBloc,
            builder: (context, state) {
              if (state is ProfileLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(200),
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 150,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        SizedBox(height: 60),
                        TextFormField(
                          initialValue: state.response.get('email'),
                          enabled: false,
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(width: 2),
                            ),
                            label: Text(
                              "Email",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(width: 1),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: nameController,
                          onChanged: (value) =>
                              setState(() => updatedFlag = true),
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.edit),
                            label: Text(
                              "Name",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          elevation: 3,
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    updatedFlag = true;
                                    pressed = 1;
                                  }),
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: pressed == 1
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(
                                              context,
                                            ).scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Male",
                                      style: TextStyle(
                                        color: pressed == 1
                                            ? Theme.of(
                                                context,
                                              ).scaffoldBackgroundColor
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
                                    updatedFlag = true;
                                    pressed = 2;
                                  }),
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: pressed == 2
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(
                                              context,
                                            ).scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Female",
                                      style: TextStyle(
                                        color: pressed == 2
                                            ? Theme.of(
                                                context,
                                              ).scaffoldBackgroundColor
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
                                    updatedFlag = true;
                                    pressed = 3;
                                  }),
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: pressed == 3
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(
                                              context,
                                            ).scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Other",
                                      style: TextStyle(
                                        color: pressed == 3
                                            ? Theme.of(
                                                context,
                                              ).scaffoldBackgroundColor
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
                        SizedBox(height: 50),

                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: updatedFlag
                                ? WidgetStateProperty.all(
                                    Theme.of(context).primaryColor,
                                  )
                                : WidgetStateProperty.all(Colors.grey),
                          ),
                          onPressed: () {
                            if (updatedFlag) {
                              profileBloc.add(
                                updateProfile(
                                  name: nameController.text,
                                  gender: pressed == 1
                                      ? "male"
                                      : pressed == 2
                                      ? "female"
                                      : "other",
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
