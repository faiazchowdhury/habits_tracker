import 'package:flutter/material.dart';
import 'package:habits_tracker/Screens/Home/bloc/habit_bloc.dart';
import 'package:habits_tracker/Screens/Home/drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_tracker/Screens/Profile/bloc/profile_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final favBloc = HabitBloc();

  @override
  void initState() {
    favBloc.add(getFavoriteList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text("Favorites")),
      body: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => favBloc)],
        child: BlocBuilder(
          bloc: favBloc,
          builder: (context, state) {
            if (state is HabitLoaded) {
              QuerySnapshot query=state.response;
              return ListView.builder(
                itemCount: query.docs.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 200,
                    child: Card(
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
                                  "\"${query.docs[index].get("quote")}\"",
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
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  '- ${query.docs[index].get("author")}',
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
                                favBloc.add(deleteFavorite(uid: query.docs[index].id));
                              },
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    "Unfavorite",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).scaffoldBackgroundColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
