import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_expense/page/collaboratori.dart';
import 'package:in_expense/page/profilo.dart';
import 'package:in_expense/service/account_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FutureBuilder(
            future: _createHeader(),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    snapshot.data,
                    _createDrawerItem(
                        icon: Icons.account_circle_outlined,
                        text: 'Profile',
                        onTap: () {
                          Get.to(ProfiloPage());
                        }),
                    _createDrawerItem(
                        icon: Icons.supervisor_account_outlined,
                        text: 'Collaborators',
                        onTap: () {
                          Get.to(CollaboratorPage());
                        }),
                    _createDrawerItem(
                        icon: Icons.logout,
                        text: 'Logout',
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove("token");
                          prefs.remove("email");
                          prefs.remove("lastname");
                          prefs.remove("fistname");
                          prefs.setString(
                              "UserStatus", UserStatus.EMPTY.toString());
                        }),
                    Divider(),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Future<Widget> _createHeader() async {
    var prefs = await SharedPreferences.getInstance();
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/drawer_background.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: CircleAvatar(
                  backgroundImage: NetworkImage(prefs.getString("uimage")))),
          Positioned(
              bottom: 20.0,
              left: 70.0,
              child: Text(
                  "${prefs.getString("uname")} ${prefs.getString("usname")}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
