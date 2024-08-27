import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final List<Widget>? persistentFooterButtons;
  final List<Widget>? actions;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.persistentFooterButtons,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(context),
      extendBodyBehindAppBar: title == null,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      persistentFooterButtons: persistentFooterButtons,
    );
  }

  AppBar? buildAppBar(context) {
    if (title == null) {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
    } else {
      return AppBar(
        centerTitle: true,
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.surface,
        foregroundColor:
            foregroundColor ?? Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: actions,
        title: Text(
          title!,
          style: TextStyle(
            color: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
  }
}
