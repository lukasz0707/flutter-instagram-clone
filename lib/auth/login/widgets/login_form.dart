import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_instagram_clone/auth/login/cubit/login_cubit.dart';
import 'package:flutter_instagram_clone/auth/login/widgets/widgets.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isError) {
          openSnackbar(
            SnackbarMessage.error(
              title: loginSubmissionStatusMessage[state.status]!.title,
              description:
                  loginSubmissionStatusMessage[state.status]?.description,
            ),
            clearIfQueue: true,
          );
        }
      },
      listenWhen: (previous, current) => previous.status != current.status,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailFormField(),
          SizedBox(
            height: AppSpacing.md,
          ),
          PasswordFormField(),
        ],
      ),
    );
  }
}
