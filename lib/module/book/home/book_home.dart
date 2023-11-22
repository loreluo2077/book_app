import 'package:book_app/theme/color.dart';
import 'package:book_app/util/bottom_bar_build.dart';
import 'package:book_app/util/dialog_build.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'book_home_controller.dart';

class BookHomeScreen2 extends GetView<BookHomeController> {
  final int bookCount = 1; // Example book count

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('书架'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 20, // Horizontal space between cards
          mainAxisSpacing: 20, // Vertical space between cards
          childAspectRatio: 0.8, // Aspect ratio of the cards
        ),
        itemCount: bookCount + 1, // bookCount plus the add button
        itemBuilder: (context, index) {
          if (index < bookCount) {
            // Return book card
            return buildBookCard();
          } else {
            // Return add book card
            return buildAddBookCard();
          }
        },
      ),
    );
  }

  Widget buildBookCard() {
    return Card(
      child: InkWell(
        onTap: () {
          // Handle book tap
        },
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.book, size: 50),
              Text('飞天'), // The book count can be dynamic
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddBookCard() {
    return Card(
      child: InkWell(
        onTap: () {
          _showSelect();
        },
        child: Container(
          alignment: Alignment.center,
          child: Icon(Icons.add, size: 50),
        ),
      ),
    );
  }

  void _showSelect() {
    Get.bottomSheet(BottomBarBuild(
      "选项",
      [
        BottomBarBuildItem(
          "如何使用?",
          () async {
            Get.back();
            Get.dialog(DialogBuild(
                "如何使用?",
                Text.rich(
                  TextSpan(children: const [
                    TextSpan(
                      text: "1. 本地导入，选择对应的txt文件即可导入，文件中需包含第x章，否则可能无法导入成功\n\n",
                    ),
                    TextSpan(
                      text: "2. 链接导入，通过复制链接再返回到APP中即可解析链接。",
                    ),
                  ], style: TextStyle(color: textColor())),
                ), confirmFunction: () async {
              Get.back();
            }));
          },
        ),
        BottomBarBuildItem(
          "本地导入",
          () async {
            Get.back();
            await controller.manageChoose("1");
          },
        ),
      ],
    ));
  }
}
