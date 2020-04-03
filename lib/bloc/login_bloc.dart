import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:elysium_app/validators/login_validator.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidator {
  final _emailController = BehaviorSubject<String>();
  final _senhaController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _senhaController.stream;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _senhaController.sink.add;

  

  void submit() {
    _stateController.add(LoginState.LOADING);
    // codigo de login
    
  }

  @override
  void dispose() {
    _emailController.close();
    _senhaController.close();
    _stateController.close();
  }
}
