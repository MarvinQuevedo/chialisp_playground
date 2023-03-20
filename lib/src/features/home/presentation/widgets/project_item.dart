import 'dart:io';
 
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; 
 

import '../../../editor/utils/dir_splitter.dart';

class ProjectItem extends StatelessWidget {
  final File file;
  final VoidCallback onTap;
  const ProjectItem({super.key, required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
     final itemName = fileName(file.path);
    return  Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        title: Text(itemName),
        hoverColor:Colors.white.withOpacity(0.1),
        leading: SvgPicture.asset(
          'assets/images/chialisp_dark.svg', 
          width: 20,
        )
      ),
    );
  }
}