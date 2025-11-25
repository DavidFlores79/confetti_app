import '../../../auth/data/models/user_model.dart';

class UsersEvent {}

class FetchUsersEvent extends UsersEvent {}

class FetchUserByIdEvent extends UsersEvent {
  final String id;
  FetchUserByIdEvent(this.id);
}

class CreateUserEvent extends UsersEvent {
  final UserModel userData;
  CreateUserEvent(this.userData);
}

class UpdateUserEvent extends UsersEvent {
  final String id;
  final UserModel userData;
  UpdateUserEvent(this.id, this.userData);
}

class DeleteUserEvent extends UsersEvent {
  final String id;
  DeleteUserEvent(this.id);
}
