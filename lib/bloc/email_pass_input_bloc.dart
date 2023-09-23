import 'package:flutter_bloc/flutter_bloc.dart';

class EmailPasswordInputBloc extends Cubit<EmailPasswordInputState> {
  EmailPasswordInputBloc() : super(EmailPasswordInputState());

  void validateInput(String text, bool isPassword) {
    if (text.isEmpty) {
      emit(state.copyWith(errorText: 'Please enter your details first.'));
    } else if (isPassword && text.length < 6) {
      emit(state.copyWith(
          errorText:
              'Password must be at least 6 characters long and include numbers, symbols, and uppercase letters for security.'));
    } else if (!isPassword && (!text.contains('@') || !text.contains('.'))) {
      emit(state.copyWith(errorText: 'Please enter a valid email address.'));
    } else {
      emit(state.copyWith(errorText: null));
    }
  }
}

class EmailPasswordInputState {
  final String? errorText;

  EmailPasswordInputState({this.errorText});

  EmailPasswordInputState copyWith({String? errorText}) {
    return EmailPasswordInputState(errorText: errorText ?? this.errorText);
  }
}
