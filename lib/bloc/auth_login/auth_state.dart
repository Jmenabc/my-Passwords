part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class Unauthenthicated extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}
