import 'package:flutter_database_sqflite_riverpod/StudentDBProvider.dart';
import 'package:flutter_database_sqflite_riverpod/StudentState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Student.dart';

class StudentStateNotifier extends StateNotifier<StudentState> {
  StudentStateNotifier():super(LoadingStudentState());

  
  fetchData() async {
   
    try { 
      // state= LoadingStudentState();
      final studentDBProvider = StudentDBProvider();
      List<Student> studentList = await studentDBProvider.fetch();
      state = LoadedFetchStudentState(studentList: studentList);
    } catch (e) {
      state = ErrorStudentState(errorMessage: e.toString());
    }
  }
}
