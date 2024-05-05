import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/domain/service/repository/user_repository.dart';

class UserProvider extends UserTemplate {
  final UserRepository _userRepository;
  UserProvider({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<bool> createUser({required UserModel user}) {
    return _userRepository.createUser(user: user);
  }

  @override
  Future<UserModel> getUser() {
    return _userRepository.getUser();
  }
}
