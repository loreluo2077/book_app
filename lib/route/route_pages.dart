import 'package:book_app/module/book/home/book_home_binding.dart';
import 'package:book_app/module/book/home/book_home_screen.dart';
import 'package:book_app/module/book/readMoreSetting/read_more_setting_binding.dart';
import 'package:book_app/module/book/readMoreSetting/read_more_setting_screen.dart';
import 'package:book_app/module/book/readSetting/read_setting_binding.dart';
import 'package:book_app/module/book/readSetting/read_setting_screen.dart';
import 'package:book_app/module/book/read/read_binding.dart';
import 'package:book_app/module/book/read/read_screen.dart';
import 'package:book_app/route/routes.dart';
import 'package:get/get.dart';

// import '../module/book/home/book_home.dart';

class RoutePages {
  static const initial = Routes.splash;
  static final routes = [
    GetPage(
        name: Routes.bookHome,
        page: () => BookHomeScreen(),
        binding: BookHomeBinding()),
    GetPage(
        name: Routes.read,
        page: () => const ReadScreen(),
        binding: ReadBinding()),
    GetPage(
        name: Routes.readSetting,
        page: () => const ReadSettingScreen(),
        binding: ReadSettingBinding()),
    GetPage(
        name: Routes.readMoreSetting,
        page: () => ReadMoreSettingScreen(),
        binding: ReadMoreSettingBinding()),
  ];
}
