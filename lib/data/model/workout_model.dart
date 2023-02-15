// To parse this JSON data, do
//
//     final workoutModel = workoutModelFromJson(jsonString);

import 'package:equatable/equatable.dart';

class WorkoutModel extends Equatable{
  WorkoutModel({
    required this.title,
    required this.exercises,
  });

  final String? title;
  final List<Exercise> exercises;

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    List<Exercise> exercises = [];
    int index = 0;
    int startTime = 0;
    for (var ex in (json['exercises'] as Iterable)) {
      exercises.add(Exercise.fromJson(ex, index, startTime));
      index++;
      startTime += exercises.last.prelude! + exercises.last.duration!;
    }

    return WorkoutModel(title: json['title'] as String?, exercises: exercises);
  }

  Map<String, dynamic> toJson() => {'title': title, 'exercises': exercises};

  WorkoutModel copywith({String? title}) =>
      WorkoutModel(title: title ?? this.title, exercises: exercises);

  int getTotalTime(){
    final time = exercises.fold(0, (prev, element) => prev + element.duration! + element.prelude!);
    return time;
  }

  Exercise getCurrentExercise(int? elapsed) =>
    //last smallest element object
    exercises.lastWhere((element) => element.startTime! <= elapsed!);

  // using equatable we can detect changes and make class more responsive to changes
  @override
  List<Object?> get props => [
    title,
    exercises
  ];

  @override
  bool get stringify => true;

}

class Exercise extends Equatable{
  Exercise({
    required this.title,
    required this.prelude,
    required this.duration,

    //we will calculate them later so don't need required
    this.index,
    this.startTime
  });

  final String? title;
  final int? prelude;
  final int? duration;
  final int? index;
  final int? startTime;

  //because index and startTime not from json format so we need to add them to parameter
  //from json use to convert json to object (workout model)
  factory Exercise.fromJson(Map<String, dynamic> json, int index, int startTime) => Exercise(
    title: json["title"],
    prelude: json["prelude"],
    duration: json["duration"],
    index: index,
    startTime: startTime
  );

  //to json convert object to json
  Map<String, dynamic> toJson() => {
    "title": title,
    "prelude": prelude,
    "duration": duration,
  };

  //this constructor for edit the exercise
  Exercise copyWith({
    String? title,
    int? prelude,
    int? duration,
    int? index,
    int? startTime,
  })=>Exercise(
      //using expresion ?? because if we not edit the field we use previus data and keeping data not null
      title: title ?? this.title,
      prelude: prelude ?? this.prelude,
      duration: duration ?? this.duration,
      index: index ?? this.index,
      startTime: startTime ?? this.startTime
  );

  @override
  // TODO: implement props
  List<Object?> get props => [
    title,
    prelude,
    duration,
    index,
    startTime
  ];

  @override
  bool get stringify => true;
}
