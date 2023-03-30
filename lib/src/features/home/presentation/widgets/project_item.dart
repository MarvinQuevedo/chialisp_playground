import 'dart:io';
 
import 'package:chialisp_playground/src/features/home/presentation/providers/theme_provider.dart';
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

     return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/chialisp_dark.svg', 
                width: 20,
              ),
              const SizedBox(width: 10,),
              Text(itemName, style: TextStyle(fontSize: ThemeProvider.of(context).projecftListFontSize),),
            ],
          ),
        ),
    
      )); 
  }
}