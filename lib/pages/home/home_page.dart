import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/pages/account/account_page.dart';
import 'package:vschool/pages/home/pages/home_base_page.dart';
import 'package:vschool/pages/mail/mail_page.dart';
import 'package:vschool/pages/qr_code/qr_code_page.dart';
import 'package:vschool/pages/study/study_pages.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeBasePage(),
    const StudyPages(),
    const QRCodePage(),
    const MailPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ColorName.primaryColor,
        selectedIconTheme: const IconThemeData(color: ColorName.primaryColor),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Assets.icons.home.svg(),
            activeIcon: Assets.icons.homeActive.svg(),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.study.svg(),
            activeIcon: Assets.icons.studyActive.svg(),
            label: 'Học tập',
          ),
          BottomNavigationBarItem(
            icon: Lottie.asset(Assets.lottie.qrScaner),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.mail.svg(),
            activeIcon: Assets.icons.mailActive.svg(),
            label: 'Hộp thư',
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.account.svg(),
            activeIcon: Assets.icons.accountActive.svg(),
            label: 'Tài khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        unselectedItemColor: ColorName.textGray2,
        selectedFontSize: 12.0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
