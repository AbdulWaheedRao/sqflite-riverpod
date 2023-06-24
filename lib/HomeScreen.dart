import 'package:flutter/material.dart';
import 'package:flutter_database_sqflite_riverpod/Student.dart';
import 'package:flutter_database_sqflite_riverpod/StudentDBProvider.dart';
import 'package:flutter_database_sqflite_riverpod/StudentProvider.dart';
import 'package:flutter_database_sqflite_riverpod/StudentState.dart';
import 'package:flutter_database_sqflite_riverpod/StudentWidgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  StudentDBProvider studentDBProvider = StudentDBProvider();

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(studentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Record'),
        backgroundColor: Colors.orange,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          if (state is LoadingStudentState) {
            return const LoadingStudentWidget();
          } else if (state is LoadedFetchStudentState) {
            if (state.studentList.isEmpty) {
              return const Center(child: Text('no data'));
            } else {
              return LoadedFetchStudentWidget(
                studentList: state.studentList,
              );
            }
          } else {
            return ErrorStudentWidget(
                errorMessage: (state as ErrorStudentState).errorMessage);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          insertDialog(context);
          ref.read(studentProvider.notifier).fetchData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //Insertion Dialog

  insertDialog(
    BuildContext context,
  ) {
    final formKey = GlobalKey<FormState>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextEditingController _namecontroller = TextEditingController();
    TextEditingController _rollNocontroller = TextEditingController();
    TextEditingController _feecontroller = TextEditingController();
    StudentDBProvider studentDBProvider = StudentDBProvider();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Asset Image
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 226, 97, 88),
                  radius: 60,
                  child: Image.asset('assets/images/profile_photo.png'),
                ),
                TextFormField(
                  controller: _namecontroller,
                  decoration: const InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    label: Text(
                      'Name',
                      style:
                          TextStyle(color: Color.fromARGB(255, 235, 95, 85)),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: height * 0.007,
                ),
                //RollNo TextField

                TextFormField(
                  controller: _rollNocontroller,
                  decoration: const InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    label: Text(
                      'Roll No.',
                      style:
                          TextStyle(color: Color.fromARGB(255, 235, 95, 85)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: height * 0.007,
                ),
                //Fee Textfield

                TextFormField(
                  controller: _feecontroller,
                  decoration: const InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    label: Text(
                      'Fee',
                      style:
                          TextStyle(color: Color.fromARGB(255, 235, 95, 85)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'required';
                    } else {
                      return null;
                    }
                  },
                ),
                ButtonBar(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await studentDBProvider.insert(
                              student: Student(
                                name: _namecontroller.text,
                                rollNo: int.parse(_rollNocontroller.text),
                                fee: double.parse(_feecontroller.text),
                              ),
                            );
                            ref.read(studentProvider.notifier).fetchData();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data Inserted Successfully'),
                              ),
                            );
                          }
                        },
                        child: const Text('Insert')),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    // Cancel Button
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
