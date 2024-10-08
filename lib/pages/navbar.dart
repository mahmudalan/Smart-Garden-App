import 'package:flutter/material.dart';
import 'package:lock_system_garden/pages/home_page.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    Color blue = const Color(0xff008DDA);
    Color teal = const Color(0xffACE2E1);
    return Drawer(
      backgroundColor: teal,
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: blue,
              image: const DecorationImage(image: AssetImage('lib/assets/wallpaper.jpg'), fit: BoxFit.cover)
            ),
            accountName: const Text('Muhammad Al Farizi', style: TextStyle(fontWeight: FontWeight.bold),),
            accountEmail: const Text('almondmaf@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('lib/assets/user.jpg',),
              ),
            ),
          ),
          ListTile(
            leading: Image.asset('lib/assets/dashboard.png',height: 25,color:Colors.white,),
            title: const Text('Dashboard',
              style: TextStyle(
                fontFamily: 'Balance',
                color:Colors.white,
                fontSize: 20
              ),),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
          ),
          ListTile(
            leading: Image.asset('lib/assets/user.png',height: 25,color: Colors.white,),
            title: const Text('Profile',
              style: TextStyle(
                  fontFamily: 'Balance',
                  color: Colors.white,
                  fontSize: 20
              ),),
            onTap: () {},
          ),
          ListTile(
            leading: Image.asset('lib/assets/arroba.png',height: 25,color: Colors.white,),
            title: const Text('Contact Us',
              style: TextStyle(
                  fontFamily: 'Balance',
                  color: Colors.white,
                  fontSize: 20
              ),),
            onTap: () {},
          ),
          ListTile(
            leading: Image.asset('lib/assets/setting-lines.png',height: 25,color: Colors.white,),
            title: const Text('Settings',
              style: TextStyle(
                  fontFamily: 'Balance',
                  color: Colors.white,
                  fontSize: 20
              ),),
            onTap: () {},
          ),
          ListTile(
            leading: Image.asset('lib/assets/help.png',height: 25,color: Colors.white,),
            title: const Text('Help',
              style: TextStyle(
                  fontFamily: 'Balance',
                  color: Colors.white,
                  fontSize: 20
              ),),
            onTap: () {},
          ),
          ListTile(
            leading: Image.asset('lib/assets/logout.png',height: 25,color: Colors.white,),
            title: const Text('Sign Out',
              style: TextStyle(
                  fontFamily: 'Balance',
                  color: Colors.white,
                  fontSize: 20
              ),),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

