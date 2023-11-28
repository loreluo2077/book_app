import 'package:book_app/module/book/home/book_home_controller.dart';
import 'package:book_app/util/bottom_bar_build.dart';
import 'package:book_app/util/dialog_build.dart';
import 'package:book_app/util/ex_list.dart';
import 'package:book_app/util/ex_widget.dart';
import 'package:book_app/util/future_do.dart';
import 'package:book_app/util/system_utils.dart';
import 'package:book_app/util/toast.dart';
import 'package:book_app/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:book_app/model/book/book.dart';

import '../../../widget/icon.dart';

class BookHomeScreen extends GetView<BookHomeController> {
  const BookHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text("书架"),
        centerTitle: true,
        elevation: 0,
        // backgroundColor: backgroundColor(),
      ),
      // backgroundColor: backgroundColor(),
      body: _body(context),
    );
  }

  Widget _parseProcess() {
    return GetBuilder<BookHomeController>(
      id: "parseProcess",
      builder: (controller) {
        if (controller.parseNow) {
          return LinearProgressIndicator(
            value: controller.parseProcess / 100,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildBookCard(Book localBook) {
    return Card(
            child: <Widget>[
      IconWidget.icon(
        Icons.book,
        size: 50,
      ),
      TextWidget(
        text: localBook.name!,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      )
    ].toColumn(mainAxisAlignment: MainAxisAlignment.center))
        .onTap(() {
      FutureDo.doAfterExecutor300(() => controller.getBookInfo(localBook),
          preExecutor: () => Get.back());
    }).onLongPress(() {
      _longPressBook(localBook);
    });
  }

  Widget _body(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 1,
          color: Colors.grey[800],
        ),
        _parseProcess(),
        Expanded(
          child: GetBuilder<BookHomeController>(
            id: 'bookList',
            builder: (controller) {
              int count = controller.localBooks.length;
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 40,
                      mainAxisSpacing: 5,
                      childAspectRatio: .65),
                  itemCount: count + 1,
                  itemBuilder: (context, index) {
                    if (index < count) {
                      // Return book card
                      return _buildBookCard(controller.localBooks[index]);
                    } else {
                      // Return add book card
                      return _addBookWidget(context);
                    }
                  }).marginSymmetric(horizontal: 25, vertical: 15);
              // );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _addBookWidget(context) {
    return Column(
      children: [
        IconWidget.icon(
          Icons.add,
          size: 45,
          color: Colors.black54,
        ).center().card(color: Colors.grey[200]).onTap(() {
          _showSelect();
        }).expanded()
      ],
    );
  }

  _handleDelete(Book book) async {
    Get.dialog(DialogBuild(
        "温馨提示",
        Text.rich(
          TextSpan(
              text: "你确定要删除",
              children: [
                TextSpan(
                    text: "${book.name}",
                    style: const TextStyle(color: Colors.redAccent)),
                const TextSpan(text: "吗?")
              ],
              style: const TextStyle(color: Colors.black45)),
        ), confirmFunction: () async {
      controller.deleteBook(book);
      Get.back();
    }));
  }

  _longPressBook(Book book) {
    Get.bottomSheet(BottomBarBuild(
      "选项",
      [
        BottomBarBuildItem(
          "重命名",
          () {
            Get.back();
            _rename(book);
          },
          longFunction: () {
            Get.back();
          },
        ),
        BottomBarBuildItem("", () {
          Get.back();
          _handleDelete(book);
        }, longFunction: () {
          Get.back();
        },
            titleWidget: const Text(
              "删除",
              style: TextStyle(color: Colors.redAccent),
            ))
      ],
    ));
  }

  void _rename(Book book) {
    TextEditingController textEditingController = TextEditingController();
    Get.dialog(DialogBuild(
        "重命名",
        TextField(
          controller: textEditingController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: book.name,
          ),
        ), confirmFunction: () async {
      var text = textEditingController.text.trim();
      if (text.isNotEmpty && text.length > 20) {
        Toast.toast(toast: "名字长度最长20");
        return;
      }
      Get.back();
      if (text.isNotEmpty) {
        await controller.updateBookName(book.id!, text);
      }
    }));
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
                const Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: "1. 本地导入，选择对应的txt文件即可导入，文件中需包含第x章，否则可能无法导入成功\n\n",
                    ),
                  ], style: TextStyle(color: Colors.black)),
                ), confirmFunction: () async {
              Get.back();
            }));
          },
          longFunction: () {
            Get.back();
          },
        ),
        BottomBarBuildItem(
          "本地导入",
          () async {
            Get.back();
            await controller.manageChoose("1");
          },
          longFunction: () {
            Get.back();
          },
        ),
      ],
    ));
  }
}
