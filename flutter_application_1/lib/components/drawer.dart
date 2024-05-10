import "package:flutter/material.dart";
import "package:flutter_application_1/components/my_list_tile.dart";

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(68, 35, 72, 1),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
          //header
          const DrawerHeader(
              child: Icon(
              Icons.account_circle_outlined,
             color: Color.fromRGBO(246, 239, 248, 1),
              size: 64,
              ),
            ),

          //home list  title
          MyListTile(
          icon: Icons.home, 
          text: "H O M E",
          onTap: () => Navigator.pop(context),
          ),
          //profile list title
          MyListTile(
          icon: Icons.person,
          text: "P R O F I L E",
          onTap: onProfileTap,
          ),
          ],
        ),
          //logout list title
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
            icon: Icons.logout,
            text: "L O G O U T",
            onTap: onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}