import 'Course.dart';

class CourseGroup {
  int level;
  List<List<Course>> rows;

  CourseGroup(int level, List<List<Course>> rows) {
    this.level = level;
    this.rows = rows;
  }
}