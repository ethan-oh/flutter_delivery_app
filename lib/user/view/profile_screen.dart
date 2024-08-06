import 'package:delivery_flutter_app/common/const/colors.dart';
import 'package:delivery_flutter_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userMeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: ImageIcon(
              AssetImage(
                'asset/img/logo/ethan_logo.png',
              ),
              color: PRIMARY_COLOR,
              size: 50,
            ),
            // leading: CircleAvatar(
            //   child: Image.asset(
            //     'asset/img/logo/ethan_logo.png',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            title: Text('Ethan'),
            subtitle: Text('test@tesasdfasdfasdft.com'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
