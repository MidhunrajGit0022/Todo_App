import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/constant/text_constants.dart';
import 'package:todolist/controller/todo_controller.dart';
import 'package:todolist/model/todo_model.dart';
import 'package:todolist/views/completetask.dart';
import 'package:todolist/views/updatetask.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final controller = Get.put(TodoController());
  String? _selectedValue = 'All List';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          automaticallyImplyLeading: false,
          title: const Text(
            Textconstants.appname,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue.shade900,
          onPressed: () {
            controller.titlecontroller.clear();
            controller.descriptioncontroller.clear();

            Get.toNamed('/add');
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<List<TodoModel>>(
          stream: controller.gettododata(),
          builder:
              (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No todo lists available'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  TodoModel tododisplay = snapshot.data![index];
                  final String docID = tododisplay.id;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => Updatetask(tododisplay));
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Task'),
                              content: const Text(
                                  'Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    controller.deletetodo(docID);
                                    Get.back();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Dismissible(
                        key: ValueKey(tododisplay),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.delete_outline_outlined,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) async {
                          await controller.deletetodo(docID);
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blue.shade900
                                          .withOpacity(0.1)),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.blue.shade900.withOpacity(0.1),
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
                                                    fontWeight: FontWeight.bold,
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
                                            checkColor: Colors.white,
                                            activeColor: Colors.blue.shade900,
                                            onChanged: (value) {
                                              controller.updateTask(
                                                  docID, value!);
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
