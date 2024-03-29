import 'package:igreja_izau/app/models/user.dart';
import 'package:igreja_izau/app/repositories/auth/auth_repository.dart';
import 'package:igreja_izau/app/services/auth/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;

  AuthServiceImpl({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<String?> login({required String email, required String password}) async {
    UserModel user = UserModel(userName: email, password: password, roles: ["USER"]);
    return _authRepository.login(user: user);
  }
}
