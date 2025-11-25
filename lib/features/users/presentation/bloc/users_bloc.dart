import 'package:confetti_app/features/users/domain/usecases/get_users_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsersUseCase getUsersUseCase;
  UsersBloc({required this.getUsersUseCase}) : super(UsersInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    final result = await getUsersUseCase();
    result.fold(
      (failure) {
        emit(UsersError(failure.message));
      },
      (users) {
        emit(UsersLoaded(users));
      },
    );
  }
}
