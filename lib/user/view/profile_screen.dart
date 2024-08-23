import 'package:delivery_flutter_app/common/provider/theme_provider.dart';
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl),
            ),
            title: Text(
              user.username.split('@')[0],
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(user.username),
          ),
          FilledButton(
            onPressed: () {
              ref.read(userMeProvider.notifier).logout();
            },
            child: const Text('로그아웃'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.brightness_6_outlined),
            title: Text('테마'),
            trailing: ThemeModeDropdown(),
          ),
        ],
      ),
    );
  }
}

class ThemeModeDropdown extends ConsumerStatefulWidget {
  const ThemeModeDropdown({super.key});

  @override
  ConsumerState<ThemeModeDropdown> createState() => _ThemeModeDropdownState();
}

class _ThemeModeDropdownState extends ConsumerState<ThemeModeDropdown> {
  @override
  Widget build(BuildContext context) {
    ThemeMode selectedThemeMode = ref.watch(themeModeProvider);
    return PopupMenuButton<ThemeMode>(
      onSelected: (value) {
        setState(() {
          ref.read(themeModeProvider.notifier).setTheme(value);
          selectedThemeMode = value;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
        const PopupMenuItem(
          value: ThemeMode.system,
          child: Text('기기 테마 사용'),
        ),
        const PopupMenuItem(
          value: ThemeMode.light,
          child: Text('밝은 테마'),
        ),
        const PopupMenuItem(
          value: ThemeMode.dark,
          child: Text('어두운 테마'),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedThemeMode == ThemeMode.system
                ? '기기 테마 사용'
                : selectedThemeMode == ThemeMode.light
                    ? '밝은 테마'
                    : '어두운 테마',
            style: const TextStyle(fontSize: 13),
          ),
          const Icon(
            Icons.arrow_drop_down,
            size: 18,
          ),
        ],
      ),
    );
  }
}
