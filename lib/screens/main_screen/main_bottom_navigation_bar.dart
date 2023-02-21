import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/auth_methods.dart';
import '../../providers/app_provider.dart';
import '../../utilities/app_image.dart';
import '../auth/phone_number_screen.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double iconSize = 25;
    AppProvider navBar = Provider.of<AppProvider>(context);
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
      selectedItemColor: Theme.of(context).primaryColor,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      unselectedItemColor: Colors.grey,
      currentIndex: navBar.currentTap,
      onTap: (int index) {
        navBar.onTabTapped(index);
        // if (AuthMethods.getCurrentUser == null && (index != 0 && index != 1)) {
        //   Navigator.of(context).pushNamed(PhoneNumberScreen.routeName);
        // } else {
        //   navBar.onTabTapped(index);
        // }
      },
      items:  <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SizedBox(width: iconSize,child: Image.asset(AppImages.homeOutline)),
          activeIcon: SizedBox(width: iconSize,child: Image.asset(AppImages.homeActive)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(width: iconSize, child: Image.asset(AppImages.cartOutline)),
          activeIcon: SizedBox(width: iconSize, child: Image.asset(AppImages.cartActive)),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(width: iconSize,child: Image.asset(AppImages.videoOutline)),
          activeIcon: SizedBox(width: iconSize, child: Image.asset(AppImages.videoActive)),
          label: 'Live',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(width: iconSize, child: Image.asset(AppImages.addOutline)),
          activeIcon: SizedBox(width: iconSize, child: Image.asset(AppImages.addActive)),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(width: iconSize, child: Image.asset(AppImages.messageOutline)),
          activeIcon: SizedBox(width: iconSize, child: Image.asset(AppImages.messageActive)),
          label: 'chat',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(width: iconSize, child: Image.asset(AppImages.profileOutline)),
          activeIcon: SizedBox(width: iconSize, child: Image.asset(AppImages.profileActive)),
          label: 'Profile',
        ),
      ],
    );
  }
}
