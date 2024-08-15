import 'package:delivery_flutter_app/user/model/user_model.dart';
import 'package:delivery_flutter_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // read 사용 이유. ProfileScreen에 들어왔다는건
    // userMeProvider가 Null 이 아니라는 게 확정인 상황.
    // watch로 설정하는 경우 logout()호출 시 state가 null이 되고
    // 상태가 변경되었기 때문에 위젯을 리빌드하면서
    // as UserModel으로 타입을 지정한 부분에서 에러가 발생한다.

    // watch로 설정 후 return하는 값을 if(user is UserModel){...}else{...} 등으로
    // 예외 처리할 수는 있지만,read로 설정한 이유는 두 가지이다.
    // 이유 1) 로그인 후 로그아웃까지 user의 상태가 변경될 일이 없음.
    // (만약 user의 정보를 변경하는 기능이 서버에서 주어진다면 watch로 변경해야 함)
    // 이유 2) 로그아웃 시 바로 loginScreen으로 이동하기 때문에
    // user가 null이거나 한 상태의 위젯을 그리는 상황이 발생하지 않음.
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
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
