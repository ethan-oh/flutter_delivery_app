import 'package:delivery_flutter_app/common/const/colors.dart';
import 'package:delivery_flutter_app/user/model/user_model.dart';
import 'package:delivery_flutter_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userMeProvider) as UserModel;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.imageUrl),
              ),
            ),
            title: Text(user.username.split('@')[0]),
            subtitle: Text(user.username),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(userMeProvider.notifier).logout();
            },
            child: Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
