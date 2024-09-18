import 'package:delivery_flutter_app/common/component/custom_text_form_field.dart';
import 'package:delivery_flutter_app/common/extension/build_context_extension.dart';
import 'package:delivery_flutter_app/common/layout/default_layout.dart';
import 'package:delivery_flutter_app/common/utils/validate_utils.dart';
import 'package:delivery_flutter_app/user/model/user_model.dart';
import 'package:delivery_flutter_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formKeyProvider =
    Provider<GlobalKey<FormState>>((ref) => GlobalKey<FormState>());

// 로그인 성공 시 autoDispose로 초기화
final obsecurePasswordProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);

class LoginScreen extends ConsumerWidget {
  static get routeName => 'login';
  const LoginScreen({super.key});

  Future<void> _login(WidgetRef ref, BuildContext context, String username,
      String password) async {
    final result = await ref
        .read(userMeProvider.notifier)
        .login(username: username, password: password);
    if (result is! UserModelError) return;
    // 로그인 실패 시 스낵바
    context.showSnackBar(result.message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userMeProvider);
    final formKey = ref.watch(formKeyProvider);

    String username = '';
    String password = '';
    return ScaffoldMessenger(
      // MaterialApp의 ScaffoldMessenger에서 SnackBar를 생성하면
      // 페이지가 이동되어도 SnackBar가 사라지지 않기 때문에 새로운 ScaffoldMessenger를
      // 로그인 스크린에서만 사용함
      child: Stack(
        children: [
          DefaultLayout(
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
                          textInputAction: TextInputAction.next,
                          hintText: '이메일을 입력해주세요.',
                          validatior: ValidateUtils.emailValidator,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus,
                          onSaved: (value) {
                            username = value;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Consumer(
                          builder: (context, ref, __) {
                            bool isObsecure =
                                ref.watch(obsecurePasswordProvider);
                            return CustomTextFormField(
                              textInputAction: TextInputAction.done,
                              hintText: '비밀번호를 입력해주세요.',
                              validatior: ValidateUtils.passwordValidator,
                              obscureText: isObsecure,
                              suffixIcon: IconButton(
                                onPressed: () => ref
                                    .read(obsecurePasswordProvider.notifier)
                                    .state = !isObsecure,
                                icon: Icon(isObsecure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              onFieldSubmitted: (_) {
                                formKey.currentState!.save();
                                _login(ref, context, username, password);
                              },
                              onSaved: (value) {
                                password = value;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Builder(builder: (context) {
                          return FilledButton(
                              onPressed: () {
                                formKey.currentState!.save();
                                _login(ref, context, username, password);
                              },
                              child: const Text('로그인'));
                        }),
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
          ),
          if (user is UserModelLoading) // 로딩 중인 경우 오버레이 추가
            Positioned.fill(
              child: Container(
                color: Colors.black54, // 배경 색상
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Ethan\'s Delivery',
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
    return Text(
      '이메일과 비밀번호를 입력해서 로그인해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
