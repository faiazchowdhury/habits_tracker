import 'package:flutter/material.dart';
import 'package:habits_tracker/Screens/Home/bloc/habit_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habits_tracker/Screens/Home/createhabit.dart';
import 'package:habits_tracker/Screens/Home/drawer.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final habitBloc = HabitBloc();
  final quoteBloc = HabitBloc();
  final favBloc = HabitBloc();
  @override
  void initState() {
    habitBloc.add(getHabit());
    quoteBloc.add(getQuote());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => habitBloc),
        BlocProvider(create: (context) => quoteBloc),
        BlocProvider(create: (context) => favBloc),
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
        appBar: AppBar(title: Text("")),
        body: BlocBuilder(
          bloc: habitBloc,
          builder: (context, state) {
            if (state is HabitLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is HabitLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Today's Quote",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    BlocBuilder(
                      bloc: quoteBloc,
                      builder: (context, quoteState) {
                        if (quoteState is HabitLoaded) {
                          List quotes = quoteState.response;
                          return CarouselSlider(
                            items: quotes.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Card(
                                    margin: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 20,
                                                top: 20,
                                              ),
                                              child: SelectableText(
                                                '"${i['q']}"',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge!.color,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10.0,
                                              ),
                                              child: Text(
                                                ' - ${i['a']}',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              favBloc.add(
                                                favQuote(
                                                  quote: i['q'],
                                                  author: i['a'],
                                                  context: context
                                                ),
                                              );
                                            },
                                            child: Container(
                                              alignment:
                                                  Alignment.bottomCenter,
                                              width: double.infinity,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(12),
                                                      bottomRight:
                                                          Radius.circular(12),
                                                    ),
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Favorite",
                                                  style: TextStyle(
                                                    color: Theme.of(
                                                      context,
                                                    ).scaffoldBackgroundColor,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            options: CarouselOptions(),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Habits for today",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Expanded(
                      flex: 0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.response.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${state.response[index].get('title')}",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge!.color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        "Start Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(state.response[index].get('startDate')))}",
                                      ),
                                    ],
                                  ),
                                  Checkbox(
                                    value: state.response[index].get(
                                      'completed',
                                    ),
                                    onChanged: (val) {
                                      habitBloc.add(
                                        changeCompleted(
                                          flag: val!,
                                          doc: state.response[index].id,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
