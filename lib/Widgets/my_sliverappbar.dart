import 'package:diet_tracker_app/Views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySliverAppBar extends StatelessWidget {
  final String title;
  final Widget? centerWidget;
  final Widget? stackedWidget;
  final double appbarHeight;
  const MySliverAppBar(
      {super.key,
      required this.title,
      required this.appbarHeight,
      this.centerWidget,
      this.stackedWidget});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      snap: false,
      pinned: false,
      expandedHeight: appbarHeight,
      centerTitle: true,
      title: Text(
        title,
        style: GoogleFonts.dancingScript(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),
        //style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: appbarHeight * 0.85,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Colors.red,
                          Colors.yellow,
                          Colors.green,
                          Colors.blue,
                          Colors.purple
                        ]),
                  ),
                  child: Center(
                      child: SizedBox(
                          height: 150, width: 150, child: centerWidget)),
                ),
                /*
                Container(
                    height: appbarHeight * 0.15,
                    decoration: const BoxDecoration(),
                    child: const SizedBox(
                      height: 100,
                      //width: 150,
                    ))*/
              ],
            ),
            if (stackedWidget != null) Column(mainAxisAlignment: MainAxisAlignment.end,children: [stackedWidget!]),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
            Navigator.push(context, MaterialPageRoute<Widget>(
                                      builder: (BuildContext context) {return const SettingsPage();}));
            }
          ),
        )
      ],
    );
  }
}
