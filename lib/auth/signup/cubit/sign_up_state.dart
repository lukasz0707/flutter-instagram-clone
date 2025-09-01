part of 'sign_up_cubit.dart';

/// Message that will be shown to user, when he will try to submit signup form,
/// but there is an error occurred. It is used to show user, what exactly went
/// wrong.
typedef SingUpErrorMessage = String;

/// Defines possible signup submission statuses. It is used to manipulate with
/// state, using Bloc, according to state. Therefore, when [success] we
/// can simply navigate user to main page and such.
enum SignUpSubmissionStatus {
  /// [SignUpSubmissionStatus.idle] indicates that user has not yet submitted
  /// signup form.
  idle,

  /// [SignUpSubmissionStatus.inProgress] indicates that user has submitted
  /// signup form and is currently waiting for response from backend.
  inProgress,

  /// [SignUpSubmissionStatus.success] indicates that user has successfully
  /// submitted signup form and is currently waiting for response from backend.
  success,

  /// [SignUpSubmissionStatus.emailAlreadyRegistered] indicates that email,
  /// provided by user, is occupied by another one in database.
  emailAlreadyRegistered,

  /// [SignUpSubmissionStatus.inProgress] indicates that user had no internet
  /// connection during network request.
  networkError,

  /// [SignUpSubmissionStatus.error] indicates something went wrong when user
  /// tried to sign up.
  error;

  bool get isSuccess => this == SignUpSubmissionStatus.success;
  bool get isLoading => this == SignUpSubmissionStatus.inProgress;
  bool get isEmailRegistered =>
      this == SignUpSubmissionStatus.emailAlreadyRegistered;
  bool get isNetworkError => this == SignUpSubmissionStatus.networkError;
  bool get isError =>
      this == SignUpSubmissionStatus.error ||
      isNetworkError ||
      isEmailRegistered;
}

/// {@template signup_state}
/// Defines signup state. It is used to store all the data, that is needed
/// for signup form to work properly. It also stores signup submission status,
/// that is used to manipulate with state, using Bloc, according to state.
/// {@endtemplate}
class SignUpState extends Equatable {
  const SignUpState._({
    required this.submissionStatus,
    required this.email,
    required this.fullName,
    required this.username,
    required this.password,
    required this.showPassword,
  });

  const SignUpState.initial()
    : this._(
        submissionStatus: SignUpSubmissionStatus.idle,
        email: const Email.pure(),
        fullName: const FullName.pure(),
        username: const Username.pure(),
        password: const Password.pure(),
        showPassword: false,
      );

  final SignUpSubmissionStatus submissionStatus;
  final Email email;
  final FullName fullName;
  final Username username;
  final Password password;
  final bool showPassword;

  @override
  List<Object> get props => [
    submissionStatus,
    email,
    fullName,
    username,
    password,
    showPassword,
  ];

  SignUpState copyWith({
    SignUpSubmissionStatus? submissionStatus,
    Email? email,
    FullName? fullName,
    Username? username,
    Password? password,
    bool? showPassword,
  }) {
    return SignUpState._(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}

final signupSubmissionStatusMessage =
    <SignUpSubmissionStatus, SubmissionStatusMessage>{
      SignUpSubmissionStatus.emailAlreadyRegistered:
          const SubmissionStatusMessage(
            title: 'User with this email already exists.',
            description: 'Try another email address.',
          ),
      SignUpSubmissionStatus.error:
          const SubmissionStatusMessage.genericError(),
      SignUpSubmissionStatus.networkError:
          const SubmissionStatusMessage.networkError(),
    };
