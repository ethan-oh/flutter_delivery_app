import 'package:delivery_flutter_app/common/component/custom_text_form_field.dart';
import 'package:delivery_flutter_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTextFormField(
                hintText: '이메일을 입력해주세요.',
              ),
              CustomTextFormField(
                hintText: '비밀번호를 입력해주세요.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
