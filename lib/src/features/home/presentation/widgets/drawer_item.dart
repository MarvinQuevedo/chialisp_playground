import 'package:flutter/material.dart';

import 'desktop_drawer.dart';

class DrawerItem extends StatelessWidget {
  final Widget icon;
  final ValueChanged<DrawerItemType?> onChanged;
  final DrawerItemType value;
  final DrawerItemType? groupValue;
  const DrawerItem({super.key, required this.icon, required this.onChanged,  required this.value, required this.groupValue});

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: ()=> onChanged( isSelected?null:value),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
            ),
            
          ),
          child: icon,
        ),
      ),);
  }
}