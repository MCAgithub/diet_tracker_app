import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final List<Widget>? actions;
  const MyAppBar({super.key, required this.title, required this.actions}) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;


  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: actions,
        );
  }
}
