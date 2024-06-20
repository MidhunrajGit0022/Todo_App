import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/controller/todo_controller.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/views/dashboard.dart';

class Completetask extends StatefulWidget {
  const Completetask({super.key});

  @override
  State<Completetask> createState() => _CompletetaskState();
}

class _CompletetaskState extends State<Completetask> {
  final controller = Get.put(TodoController());
  String? _selectedValue = 'Finished';
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          automaticallyImplyLeading: false,
          title: const Text("Completed Task"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.blue.shade900,
                ),
                child: DropdownButton(
                  style: const TextStyle(color: Colors.white),
                  value: _selectedValue,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedValue = newValue.toString();
                      if (_selectedValue == 'All List') {
                        Get.to(const Dashboard());
                      } else if (_selectedValue == 'Finished') {
                        Get.to(const Completetask());
                      }
                    });
                  },
                  underline: Container(
                    height: 0,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'All List',
                      child: Text(
                        'All List',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Finished',
                      child: Text(
                        'Finished',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder<List<TodoModel>>(
          stream: controller.gettododata(),
          builder:
              (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<TodoModel> completedTasks =
                  snapshot.data!.where((todo) => todo.isChecked).toList();
              return completedTasks.isEmpty
                  ? const Center(child: Text('No completed tasks'))
                  : ListView.builder(
                      itemCount: completedTasks.length,
                      itemBuilder: (context, index) {
                        TodoModel tododisplay = completedTasks[index];
                        final String docID = tododisplay.id;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue.shade900
                                            .withOpacity(0.1)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.shade900
                                            .withOpacity(0.1),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    color: Colors.grey.shade300,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                width: screenSize.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tododisplay.title,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                  maxLines: 1,
                                                ),
                                                SizedBox(
                                                  height:
                                                      screenSize.height * 0.01,
                                                ),
                                                Text(
                                                  tododisplay.description,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey[600]),
                                                  maxLines: 3,
                                                ),
                                                SizedBox(
                                                  height:
                                                      screenSize.height * 0.01,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.date_range,
                                                      size: 10,
                                                      color: Colors.grey[800],
                                                    ),
                                                    Text(
                                                      tododisplay.currentTime ??
                                                          ''.toString(),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Colors.grey[800]),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Checkbox(
                                            value: tododisplay.isChecked,
                                            onChanged: null,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
            }
          },
        ));
  }
}
