import 'package:flutter/material.dart';
import 'package:habits_tracker/Screens/Home/bloc/habit_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateHabit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateHabitState();
}

class _CreateHabitState extends State<CreateHabit> {
  final _formKey = GlobalKey<FormState>();

  String? title;
  String category = "Health";
  String frequency = "Daily";
  DateTime? startDate;
  String? notes;

  final List<String> categories = [
    "Health",
    "Fitness",
    "Study",
    "Productivity",
    "Mental Health"
        "Other",
  ];

  final habitBloc = HabitBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HabitBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Add Habit")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Title is required"
                      : null,
                  onSaved: (value) => title = value,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: category,
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => category = val!),
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Frequency"),
                    Row(
                      children: [
                        Radio<String>(
                          value: "Daily",
                          groupValue: frequency,
                          onChanged: (val) {
                            setState(() => frequency = val!);
                          },
                        ),
                        const Text("Daily"),
                        Radio<String>(
                          value: "Weekly",
                          groupValue: frequency,
                          onChanged: (val) {
                            setState(() => frequency = val!);
                          },
                        ),
                        const Text("Weekly"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Start Date",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime today = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: today,
                          firstDate: DateTime(today.year - 1),
                          lastDate: DateTime(today.year + 5),
                        );
                        if (picked != null) {
                          setState(() => startDate = picked);
                        }
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: startDate != null
                        ? "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}"
                        : "",
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Notes",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => notes = value,
                ),
                const SizedBox(height: 24),
                BlocListener(
                  bloc: habitBloc,
                  listener: (context, state) {
                    if (state is HabitLoaded) {
                      if (state.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Habit saved")),
                        );
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: BlocBuilder(
                    bloc: habitBloc,
                    builder: (context, state) {
                      if (state is HabitLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              habitBloc.add(
                                createHabit(
                                  title: title!,
                                  category: category,
                                  frequency: frequency,
                                  startDate: "$startDate",
                                  notes: notes!,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child:  Text("Save",
                          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                          ),
                          ),
                        );
                      }
                    },
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
