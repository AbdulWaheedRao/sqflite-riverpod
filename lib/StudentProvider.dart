import 'package:flutter_database_sqflite_riverpod/StudentState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'StudentStateNotifier.dart';

final studentProvider =
    StateNotifierProvider<StudentStateNotifier, StudentState>(
  (ref) {
    return StudentStateNotifier();
  },
);
