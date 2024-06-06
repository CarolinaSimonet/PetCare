import 'package:flutter/material.dart';

class GenericAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? icon;
  final Route<Object?>? mpr;
  final List<Widget>? actions;

  const GenericAppBar({super.key, required this.title, this.icon, this.mpr,  this.actions});

  @override
  Widget build(BuildContext context) {
    bool visibility = icon != null;
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 100,
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 10.0),
        child: Text(
          title,
          style: TextStyle(
            //color: Color(0xff55432f),
            color: Colors.brown.shade800,
            fontSize: 36,
            fontWeight: FontWeight.w900,
            fontFamily: 'Rowdies',
          ),
        ),
      ),
      actions: [
       Visibility(
          visible: visibility,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 20.0),
            child: IconButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(
                icon,
                size: 40,
                //color: const Color(0xff55432f),
                color: Colors.brown.shade800,
              ),
              onPressed: () { Navigator.push(context, mpr!); },
            ),
          ),
        ),
         ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
