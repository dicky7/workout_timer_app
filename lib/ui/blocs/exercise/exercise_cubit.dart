import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wakelock/wakelock.dart';
import 'package:workout_timer_app/data/model/workout_model.dart';

part 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  ExerciseCubit() : super(const ExerciseInitial());
  Timer? _timer;

  //this function to edit workout, workout is in the home page
  editWorkout(WorkoutModel workout, int index) =>
      emit(ExerciseEditing(workout, index, null));

  //this function to edit exercise
  editExercise(int? exIndex) =>
      emit(ExerciseEditing(state.workout, (state as ExerciseEditing).index, exIndex));

  pauseWorkout() => emit(WorkoutPause(state.workout, state.elapsed));

  resumeWorkout() => emit(WorkoutInProgress(state.workout, state.elapsed));

  onTick(Timer timer){
    if (state is WorkoutInProgress) {
      WorkoutInProgress work = state as WorkoutInProgress;
      if (work.elapsed! < work.workout!.getTotalTime()) {
        emit(WorkoutInProgress(work.workout, work.elapsed! + 1));

      } else{
        _timer!.cancel();
        Wakelock.disable();
        emit(const ExerciseInitial());
      }
      
    }  
  }
  //using [] array in parameter to make the parameter optional
  startWorkout(WorkoutModel workoutModel, [int? index]){
    Wakelock.enable();
    if (index !=  null){


    }else{
      emit(WorkoutInProgress(workoutModel, 0));
    }
    _timer = Timer.periodic(const Duration(seconds: 1), onTick);

  }
}
