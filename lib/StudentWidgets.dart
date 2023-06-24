import 'package:flutter/material.dart';
import 'package:flutter_database_sqflite_riverpod/StudentDBProvider.dart';
import 'package:flutter_database_sqflite_riverpod/StudentProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Student.dart';

class LoadingStudentWidget extends ConsumerWidget {
  const LoadingStudentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(studentProvider.notifier).fetchData();
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class LoadedFetchStudentWidget extends ConsumerStatefulWidget {
  const LoadedFetchStudentWidget({required this.studentList, super.key});
  final List<Student> studentList;

  @override
  ConsumerState<LoadedFetchStudentWidget> createState() =>
      _LoadedFetchStudentWidgetState();
}

class _LoadedFetchStudentWidgetState
    extends ConsumerState<LoadedFetchStudentWidget> {
  final studentDBProvider = StudentDBProvider();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: widget.studentList.length,
      itemBuilder: (context, index) => Column(
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            width: width * 0.92,
            height: height * 0.07,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 226, 97, 88),
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Text(
                widget.studentList[index].rollNo.toString(),
              ),
              title: Text(
                widget.studentList[index].name,
              ),

              trailing: Text(widget.studentList[index].fee.toString()),
              // IconButton(
              //     onPressed: () async {
              //
              //     },
              //     icon: const Icon(Icons.delete)),
              onLongPress: () {
                _showDialog(context,
                    index: index, height: height, width: width);
              },
            ),
          ),
        ],
      ),
    );
  }

  _showDialog(BuildContext context,
      {required int index, required double height, required double width}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('What you want to do?'),
          actions: [
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Color.fromARGB(255, 226, 97, 88),
                ),
              ),
              onPressed: () async {
                await studentDBProvider
                    .delete(widget.studentList[index].rollNo);
                ref.watch(studentProvider.notifier).fetchData();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                'Update',
                style: TextStyle(
                  color: Color.fromARGB(255, 226, 97, 88),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                updateDialog(context,
                    height: height, width: width, index: index);
              },
            ),
          ],
        );
      },
    );
  }
  //Updation Dialog

  updateDialog(BuildContext context,
      {required double height, required double width, required int index}) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _namecontroller = TextEditingController();
    TextEditingController _feecontroller = TextEditingController();
    StudentDBProvider studentDBProvider = StudentDBProvider();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Asset Image
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 226, 97, 88),
                  radius: 60,
                  child: Image.asset('assets/images/profile_photo.png'),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                // Name TextField
                SizedBox(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: _namecontroller,
                    decoration: InputDecoration(
                      focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      label: const Text(
                        'Name',
                        style:
                            TextStyle(color: Color.fromARGB(255, 235, 95, 85)),
                      ),
                      hintText: widget.studentList[index].name,
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 235, 95, 85)),
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
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                //Fee Textfield

                SizedBox(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: _feecontroller,
                    decoration: InputDecoration(
                      focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange)),
                      label: const Text(
                        'Fee',
                        style:
                            TextStyle(color: Color.fromARGB(255, 235, 95, 85)),
                      ),
                      hintText: widget.studentList[index].fee.toString(),
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 235, 95, 85)),
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
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await studentDBProvider.update(
                      student: Student(
                        name: _namecontroller.text,
                        rollNo: widget.studentList[index].rollNo,
                        fee: double.parse(_feecontroller.text),
                      ),
                    );
                    ref.read(studentProvider.notifier).fetchData();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data Updated Successfully'),
                      ),
                    );
                  }
                },
                child: const Text('Update')),
            // Cancel Button
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
          ],
        );
      },
    );
  }
}

class ErrorStudentWidget extends StatelessWidget {
  const ErrorStudentWidget({required this.errorMessage, super.key});
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(errorMessage),
    );
  }
}
