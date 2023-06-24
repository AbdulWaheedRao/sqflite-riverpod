import 'package:flutter/material.dart';

import 'Student.dart';

@immutable
abstract class StudentState  {
  
}
@immutable
class LoadingStudentState  extends StudentState{
  
}
@immutable
class LoadedFetchStudentState  extends StudentState{
  final List<Student> studentList ;
   LoadedFetchStudentState({required this.studentList});
} 
@immutable
class ErrorStudentState  extends StudentState{
  final String errorMessage ;
  ErrorStudentState ({required this.errorMessage});
  
}