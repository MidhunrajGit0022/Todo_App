import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist/constant/text_constants.dart';
import 'package:todolist/controller/todo_controller.dart';

class Addtask extends StatefulWidget {
  const Addtask({super.key});

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TodoController());
    String formattedDate =
        DateFormat('EEEE - yyyy-MM-dd – kk:mm').format(DateTime.now());
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text(Textconstants.taskadd),
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
                onPressed: () async {
                  await controller.addtask();
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
                    '$formattedDate | ${value.text.length} characters',
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
