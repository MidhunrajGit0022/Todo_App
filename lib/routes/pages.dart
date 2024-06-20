import 'package:get/get.dart';
import 'package:todolist/main.dart';
import 'package:todolist/views/addtask.dart';

var pages = [
  GetPage(name: "/add", page: () => const Addtask()),
  GetPage(name: "/todo", page: () => const Todolist()),
];
