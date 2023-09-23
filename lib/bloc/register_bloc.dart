import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase/supabase.dart';

class RegistrationState {
  final bool isLoading;
  final bool isRegistered;

  RegistrationState({
    required this.isLoading,
    required this.isRegistered,
  });

  factory RegistrationState.initial() {
    return RegistrationState(isLoading: false, isRegistered: false);
  }

  RegistrationState copyWith({
    bool? isLoading,
    bool? isRegistered,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}

class RegistrationEvent {}

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final SupabaseClient supabase;

  RegistrationBloc({required this.supabase}) : super(RegistrationState.initial());

  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegisterUser) {
      yield state.copyWith(isLoading: true);

      final email = event.email;
      final password = event.password;

      final response = await supabase.from('users').upsert([
        {
          'email': email,
          'password': password,
        },
      ]);

      if (response != null && response.error != null) {
        print('Error: ${response.error!.message}');
        yield state.copyWith(isLoading: false, isRegistered: false);
      } else {
        yield state.copyWith(isLoading: false, isRegistered: true);
      }
    }
  }
}

class RegisterUser extends RegistrationEvent {
  final String email;
  final String password;

  RegisterUser({required this.email, required this.password});
}
