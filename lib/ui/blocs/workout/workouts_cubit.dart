import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:workout_timer_app/data/model/workout_model.dart';


class WorkoutsCubit extends HydratedCubit<List<WorkoutModel>> {
  WorkoutsCubit() : super([]);

  void getWorkouts() async{
    final List<WorkoutModel> workouts = [];
    final workoutJson = jsonDecode(await rootBundle.loadString("assets/workouts.json"));
    for(var i in (workoutJson as Iterable)){
      workouts.add(WorkoutModel.fromJson(i));
    }
    emit(workouts);
  }

  saveWorkout(WorkoutModel workout, int index) {
    WorkoutModel newWorkout = WorkoutModel(title: workout.title, exercises: []);
    int exIndex = 0;
    int startTime = 0;

    for (var ex in workout.exercises) {
      newWorkout.exercises.add(
        Exercise(
            title: ex.title,
            prelude: ex.prelude,
            duration: ex.duration,
            index: ex.index,
            startTime: ex.startTime),
      );
      exIndex++;
      startTime += ex.prelude! + ex.duration!;
    }
    state[index] = newWorkout;
    print('...I have ${state.length} states');
    emit([...state]);
  }

  @override
  List<WorkoutModel>? fromJson(Map<String, dynamic> json) {
    List<WorkoutModel> workouts = [];
    json['workouts'].forEach((el) => workouts.add(WorkoutModel.fromJson(el)));
    return workouts;
  }

  @override
  Map<String, dynamic>? toJson(List<WorkoutModel> state) {
    if (state is List<WorkoutModel>) {
      var json = {'workouts': []};
      for (var workout in state) {
        json['workouts']!.add(workout.toJson());
      }
      return json;
    } else {
      return null;
    }
  }

}
