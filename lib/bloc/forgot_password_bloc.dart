import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase/supabase.dart';

class ForgotPasswordState {
  final bool isLoading;
  final bool isEmailSent;

  ForgotPasswordState({
    required this.isLoading,
    required this.isEmailSent,
  });

  factory ForgotPasswordState.initial() {
    return ForgotPasswordState(isLoading: false, isEmailSent: false);
  }

  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? isEmailSent,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      isEmailSent: isEmailSent ?? this.isEmailSent,
    );
  }
}

class ForgotPasswordEvent {}

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final SupabaseClient supabase;

  ForgotPasswordBloc({required this.supabase}) : super(ForgotPasswordState.initial());

  Stream<ForgotPasswordState> mapEventToState(ForgotPasswordEvent event) async* {
    if (event is SendPasswordResetEmail) {
      yield state.copyWith(isLoading: true);

      final email = event.email;

      try {
        await supabase.auth.resetPasswordForEmail(email);

        yield state.copyWith(isLoading: false, isEmailSent: true);
      } catch (e) {
        print('Error sending password reset email: $e');
        yield state.copyWith(isLoading: false, isEmailSent: false);
      }
    }
  }
}

class SendPasswordResetEmail extends ForgotPasswordEvent {
  final String email;

  SendPasswordResetEmail({required this.email});
}
