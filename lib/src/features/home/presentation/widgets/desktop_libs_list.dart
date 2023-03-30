import 'package:flutter_svg/svg.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../editor/utils/show_install_cypher_libs.dart';
import '../providers/theme_provider.dart';

class DesktopLibList extends StatefulWidget {
  const DesktopLibList({super.key});

  @override
  State<DesktopLibList> createState() => _DesktopLibListState();
}

class _DesktopLibListState extends State<DesktopLibList> {
  final double _width = 200;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themePro = Provider.of<ThemeProvider>(context);
    return ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 200,
        ),
        child: Container(
          width: _width,
          decoration: BoxDecoration(color: themePro.leftElementsBackColorDark),
          child: Builder(
            builder: (context) {
              return ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: SizedBox(
                      height: 35,
                      child: Center(
                        child: Row(
                          children: const [
                            Expanded(
                              child: Text(
                                "Third party libraries",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      LibItem(
                        name: "Install Cypher",
                        onTap: () {
                          showInstallCipherLibs(context);
                        },
                      )
                    ],
                  )
                ],
              );
            },
          ),
        ));
  }
}

class LibItem extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const LibItem({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(
                  width: 10,
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: ThemeProvider.of(context).projecftListFontSize),
                ),
              ],
            ),
          ),
        ));
  }
}
