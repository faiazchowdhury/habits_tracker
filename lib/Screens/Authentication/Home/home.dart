import 'package:flutter/material.dart';
import 'package:habits_tracker/Screens/Authentication/Home/bloc/habit_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habits_tracker/Screens/Authentication/Home/createhabit.dart';
import 'package:habits_tracker/Screens/Authentication/Home/drawer.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final habitBloc = HabitBloc();
  final completedBloc = HabitBloc();

  @override
  void initState() {
    habitBloc.add(getHabit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => habitBloc),
        BlocProvider(create: (context) => completedBloc),
      ],
      child: Scaffold(
        drawer: MyDrawer(),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => CreateHabit()));
          },
          child: Text(
            "Add Habit",
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
        appBar: AppBar(title: Text("Habits")),
        body: BlocBuilder(
          bloc: habitBloc,
          builder: (context, state) {
            if (state is HabitLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is HabitLoaded) {
              List<QueryDocumentSnapshot<Object>> res = state.response;
              return ListView.builder(
                itemCount: res.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${res[index].get('title')}",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                "Start Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(res[index].get('startDate')))}",
                              ),
                            ],
                          ),
                          Checkbox(
                            value: res[index].get('completed'),
                            onChanged: (val) {
                              habitBloc.add(
                                changeCompleted(flag: val!, doc: res[index].id),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
