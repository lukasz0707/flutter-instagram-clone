import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/view/app.dart';
import 'package:flutter_instagram_clone/auth/auth.dart';
import 'package:flutter_instagram_clone/auth/signup/widgets/widgets.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.submissionStatus.isError) {
          openSnackbar(
            SnackbarMessage.error(
              title:
                  signupSubmissionStatusMessage[state.submissionStatus]!.title,
              description: signupSubmissionStatusMessage[state.submissionStatus]
                  ?.description,
            ),
            clearIfQueue: true,
          );
        }
      },
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email
          EmailFormField(),
          // Name
          SizedBox(height: AppSpacing.md),
          FullNameFormField(),
          // Username
          SizedBox(height: AppSpacing.md),
          Username(),
          // Password
          SizedBox(height: AppSpacing.md),
          PasswordFormField(),
        ],
      ),
    );
  }
}
