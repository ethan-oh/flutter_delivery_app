import 'package:delivery_flutter_app/common/component/custom_text_form_field.dart';
import 'package:delivery_flutter_app/common/const/colors.dart';
import 'package:delivery_flutter_app/common/extension/build_context_extension.dart';
import 'package:delivery_flutter_app/common/layout/default_layout.dart';
import 'package:delivery_flutter_app/common/utils/validate_utils.dart';
import 'package:delivery_flutter_app/user/model/user_model.dart';
import 'package:delivery_flutter_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formKeyProvider =
    Provider<GlobalKey<FormState>>((ref) => GlobalKey<FormState>());

class LoginScreen extends ConsumerWidget {
  static get routeName => 'login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userMeProvider);
    final formKey = ref.watch(formKeyProvider);
    String username = '';
    String password = '';
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Title(),
                  const SizedBox(height: 16.0),
                  const _SubTitle(),
                  Image.asset(
                    'asset/img/misc/logo.png',
                    height: MediaQuery.of(context).size.width / 1.25,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextFormField(
                    hintText: '이메일을 입력해주세요.',
                    validatior: ValidateUtils.emailValidator,
                    onSaved: (value) {
                      username = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextFormField(
                    hintText: '비밀번호를 입력해주세요.',
                    validatior: ValidateUtils.passwordValidator,
                    obscureText: true,
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  FilledButton(
                    onPressed: user is UserModelLoading
                        ? null
                        : () {
                            final formKeyState =
                                ref.read(formKeyProvider).currentState;
                            if (formKeyState!.validate()) {
                              formKeyState.save();
                              ref
                                  .read(userMeProvider.notifier)
                                  .login(
                                    username: username,
                                    password: password,
                                  )
                                  .then(
                                (value) {
                                  if (value is! UserModelError) return;
                                  context.showErrorSnackBar(value.message);
                                },
                              );
                            }
                          },
                    child: const Text('로그인'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      '회원가입',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인해주세요!\n오늘도 성공적인 주문이 되길:)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
