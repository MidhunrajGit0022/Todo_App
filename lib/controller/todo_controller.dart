import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist/model/todo_model.dart';

class TodoController extends GetxController {
  static TodoController get instance => Get.find();
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();

  CollectionReference todoCollection =
      FirebaseFirestore.instance.collection('todo');

  Future<String> addtask() async {
    try {
      String formattedDate =
          DateFormat('EEEE - yyyy-MM-dd – kk:mm').format(DateTime.now());
      await todoCollection.add({
        'title': titlecontroller.text,
        'description': descriptioncontroller.text,
        'currentTime': formattedDate
      });
      Get.back();
      Get.snackbar(
        'Successfull',
        'Task Added',
        colorText: Colors.white,
      );
      titlecontroller.clear;
      descriptioncontroller.clear;
      titlecontroller.text = '';
      descriptioncontroller.text = '';

      log("Task Added successfully");
      return "Task added successfully";
    } catch (error) {
      log("Error adding data: $error");
      Get.snackbar(
        'Unsuccessfull',
        'Task Failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return "Task Unsuccessfull";
    }
  }

  Stream<List<TodoModel>> gettododata() {
    return todoCollection
        .orderBy('currentTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TodoModel.fromSnapshot(doc)).toList();
    });
  }

  Future<String> updatetododata(TodoModel todo) async {
    try {
      await todoCollection.doc(todo.id).update({
        'title': todo.title,
        'description': todo.description,
        'currentTime': todo.currentTime
      });
      Get.back();
      Get.snackbar(
        'Successfull',
        'Task Update successfully',
        colorText: Colors.white,
      );

      return "ToDO updated successfully";
    } catch (e) {
      log("Error updating data: $e");
      Get.snackbar(
        'Failed',
        'Update Failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return "Failed to update data";
    }
  }

  Future<String> deletetodo(String docID) async {
    try {
      await todoCollection.doc(docID).delete();

      Get.snackbar(
        'Delete',
        'Task deleted successfully',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return "Task deleted successfully";
    } catch (error) {
      log("Error deleting data: $error");
      Get.snackbar(
        'Unsuccessfull',
        'deleted unsuccessfully',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return "Failed to delete data";
    }
  }

  Future<String> updateTask(String docID, bool isChecked) async {
    try {
      await todoCollection.doc(docID).update({
        'isChecked': isChecked,
      });
      return "Task checked state updated successfully";
    } catch (e) {
      log("Error updating task checked state: $e");
      return "Failed to update task checked state";
    }
  }
}
