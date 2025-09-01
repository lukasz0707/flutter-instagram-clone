import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/auth/signup/cubit/sign_up_cubit.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';
import 'package:shared/shared.dart';

class Username extends StatefulWidget {
  const Username({super.key});

  @override
  State<Username> createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  late Debouncer _debouncer;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_focusNodeListener);
    _debouncer = Debouncer();
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      context.read<SignUpCubit>().onUsernameUnfocused();
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_focusNodeListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (SignUpCubit cubit) => cubit.state.submissionStatus.isLoading,
    );

    final usernameError = context.select(
      (SignUpCubit cubit) => cubit.state.username.errorMessage,
    );
    return AppTextField(
      filled: true,
      errorText: usernameError,
      focusNode: _focusNode,
      enabled: !isLoading,
      hintText: context.l10n.usernameText,
      textInputAction: TextInputAction.next,
      errorMaxLines: 3,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.givenName],
      onChanged: (value) => _debouncer.run(
        () {
          context.read<SignUpCubit>().onUsernameChanged(value);
        },
      ),
    );
  }
}
