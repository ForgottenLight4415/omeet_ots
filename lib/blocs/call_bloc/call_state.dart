part of 'call_cubit.dart';

@immutable
abstract class CallState {}

class CallInitial extends CallState {}

class CallLoading extends CallState {}

class CallReady extends CallState {}

class CallFailed extends CallState {
  final int code;
  final String cause;

  CallFailed(this.code, this.cause);
}
