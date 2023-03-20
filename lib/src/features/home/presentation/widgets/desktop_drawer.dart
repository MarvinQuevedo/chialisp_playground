import 'package:chialisp_playground/src/features/home/presentation/providers/theme_provider.dart';
import 'package:chialisp_playground/src/features/home/presentation/widgets/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import 'desktop_projects_list.dart';

enum DrawerItemType {
  projects,
}

class DesktopDrawer extends StatefulWidget {
  const DesktopDrawer({super.key});

  @override
  State<DesktopDrawer> createState() => _DesktopDrawerState();
}

class _DesktopDrawerState extends State<DesktopDrawer> {
  Widget? openedItem(BuildContext context) {
    switch (selectedItem) {
      case DrawerItemType.projects:
        return const DesktopProjectsList();

      default:
        return null;
    }
  }

  DrawerItemType? selectedItem = DrawerItemType.projects;
  @override
  Widget build(BuildContext context) {
    final themePro = Provider.of<ThemeProvider>(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: themePro.leftIconsColorDark,
          width: 50,
          child: ListView(
            children: [
              DrawerItem(
                icon: const Icon(Ionicons.documents_outline),
                onChanged: _changeValue,
                value: DrawerItemType.projects,
                groupValue: selectedItem,
              )
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          child: openedItem(context),
        )
      ],
    );
  }

  void _changeValue(DrawerItemType? value) {
    setState(() {
      selectedItem = value;
    });
  }
}
