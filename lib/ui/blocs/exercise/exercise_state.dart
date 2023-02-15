part of 'exercise_cubit.dart';

abstract class ExerciseState extends Equatable {
  final WorkoutModel? workout;
  final int? elapsed;

  const ExerciseState(this.workout, this.elapsed);
}

class ExerciseInitial extends ExerciseState {

  const ExerciseInitial(): super(null, 0);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WorkoutInProgress extends ExerciseState{
  WorkoutInProgress(WorkoutModel? workout, int? elapsed):super(workout, elapsed);

  @override
  List<Object?> get props => [workout, elapsed];

}
class ExerciseEditing extends ExerciseState {
  final int index;
  final int? exIndex;

  const ExerciseEditing(WorkoutModel? workout, this.index, this.exIndex)
      : super(workout, 0);

  @override
  List<Object?> get props => [workout, index, exIndex];
}

class WorkoutPause extends ExerciseState{
  WorkoutPause(WorkoutModel? workout, int? elapsed):super(workout, elapsed);

  @override
  List<Object?> get props => [workout, elapsed];

}