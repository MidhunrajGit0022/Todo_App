import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist/constant/text_constants.dart';
import 'package:todolist/controller/todo_controller.dart';
import 'package:todolist/model/todo_model.dart';

class Updatetask extends StatefulWidget {
  final TodoModel todo;

  const Updatetask(this.todo, {super.key});

  @override
  State<Updatetask> createState() => _UpdatetaskState();
}

class _UpdatetaskState extends State<Updatetask> {
  final controller = Get.put(TodoController());
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  String docid = "";
  @override
  void initState() {
    super.initState();
    docid = widget.todo.id;
    controller.titlecontroller.text = widget.todo.title;
    controller.descriptioncontroller.text = widget.todo.description;
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    descriptioncontroller.dispose();
    super.dispose();
  }

  void updatetododata() async {
    final formattedDate =
        DateFormat('EEEE - yyyy-MM-dd – kk:mm').format(DateTime.now());
    final updatadata = TodoModel(
        id: docid,
        title: controller.titlecontroller.text,
        description: controller.descriptioncontroller.text,
        currentTime: formattedDate);
    String todoresult = await controller.updatetododata(updatadata);
    controller.titlecontroller.clear();
    controller.descriptioncontroller.clear();
    log(todoresult);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE - yyyy-MM-dd – kk:mm').format(DateTime.now());
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Textconstants.updatetask),
        backgroundColor: Colors.blue.shade900,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  updatetododata();
                  // Get.back();
                },
                icon: const Icon(Icons.check)),
          )
        ],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.titlecontroller,
                maxLength: 30,
                decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                cursorColor: Colors.blue[900],
              ),
              SizedBox(
                height: screenSize.height * 0.02,
              ),
              ValueListenableBuilder(
                valueListenable: controller.descriptioncontroller,
                builder: (context, value, child) {
                  return Text(
                    '${widget.todo.currentTime ?? ''} | ${value.text.length} characters',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  );
                },
              ),
              TextField(
                controller: controller.descriptioncontroller,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description',
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                cursorColor: Colors.blue[900],
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
