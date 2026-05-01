import 'package:chatapp/core/utils/di.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';

UserEntity get me {
  final user = getIt<AuthBloc>().state.user;
  if (user != null) {
    return user;
  } else {
    throw Exception('User not authenticated');
  }
}
