// import 'dart:async';
// import 'dart:io';

// import 'package:book_app/log/log.dart';
import 'package:book_app/module/book/home/book_home_controller.dart';
import 'package:book_app/module/book/read/read_controller.dart';
import 'package:book_app/theme/color.dart';
// import 'package:book_app/util/bottom_bar_build.dart';
import 'package:book_app/util/limit_util.dart';
// import 'package:book_app/util/path_util.dart';
// import 'package:book_app/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';

bottom(context) async {
  // 计算进度
  ReadController controller = Get.find();
  controller.calReadProgress();
  controller.bottomType = "1";
  Navigator.of(context)
      .push(PageRouteBuilder(
          opaque: false,
          transitionDuration: const Duration(milliseconds: 100),
          pageBuilder: (context, animation, secondaryAnimation) {
            return _page(context, animation, secondaryAnimation, controller);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light, child: child),
            );
          }))
      .then((value) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  });
}

Widget _buildHead(context, controller) {
  return Container(
    height: 56 + MediaQuery.of(context).padding.top,
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    color: Colors.black,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          child: Container(
            margin: const EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.popRead();
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Text(
                    "${controller.book!.name!.length > 10 ? controller.book!.name!.substring(0, 10) : controller.book!.name}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildActions(context) {
  return Expanded(
      child: GestureDetector(
    onTap: () => Navigator.of(context).pop(),
    behavior: HitTestBehavior.opaque,
    child: Stack(
      children: [
        GetBuilder<ReadController>(
            id: 'bottomType',
            builder: (controller) {
              if (controller.bottomType == "1") {
                return Positioned(
                  bottom: 20,
                  right: 20,
                  child: _actions(controller),
                );
              }
              return Container();
            }),
      ],
    ),
  ));
}

Widget _buildMiddle() {
  return GetBuilder<ReadController>(
    id: 'bottomType',
    builder: (controller) {
      return _bottomType(controller);
    },
  );
}

Widget _buildBottom(context, controller) {
  return Container(
    margin: const EdgeInsets.only(top: 10, bottom: 10),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            child: Container(
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Icon(Icons.library_books, size: 24, color: Colors.white),
                  Text("目录",
                      style: TextStyle(color: Colors.white, fontSize: 14))
                ],
              ),
            ),
            onTap: () async {
              Navigator.of(context).pop();
              await controller.openDrawer();
            },
          ),
        ),
        GetBuilder<ReadController>(
          id: "bottomType",
          builder: (controller) {
            return Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.wb_sunny,
                          size: 24,
                          color: controller.bottomType == "2"
                              ? Theme.of(context).primaryColor
                              : Colors.white),
                      Text("亮度",
                          style: TextStyle(
                              color: controller.bottomType == "2"
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              fontSize: 14))
                    ],
                  ),
                ),
                onTap: () {
                  controller.changeBottomType("2");
                },
              ),
            );
          },
        ),
        GetBuilder<ReadController>(
          id: "bottomType",
          builder: (controller) {
            return Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.settings,
                          size: 24,
                          color: controller.bottomType == "3"
                              ? Theme.of(context).primaryColor
                              : Colors.white),
                      Text("设置",
                          style: TextStyle(
                              color: controller.bottomType == "3"
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              fontSize: 14))
                    ],
                  ),
                ),
                onTap: () {
                  controller.changeBottomType("3");
                },
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget _page(context, animation, secondaryAnimation, controller) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildHead(context, controller),
        _buildActions(context),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4))),
            child: Column(
              children: [
                _buildMiddle(),
                _buildBottom(context, controller),
              ],
            ),
          ),
          onTap: () {},
        ),
      ],
    ),
  );
}

Widget _actions(ReadController controller) {
  if (controller.rotateScreen) {
    var widgets = _actionsItems(controller);
    widgets.add(const SizedBox(
      width: 40,
    ));
    return Row(
      children: widgets,
    );
  } else {
    return Column(
      children: _actionsItems(controller),
    );
  }
}

List<Widget> _actionsItems(ReadController controller) {
  return [
    GestureDetector(
      child: CircleAvatar(
        minRadius: 25,
        backgroundColor: Colors.black.withOpacity(.5),
        child: Icon(
          controller.isDark ? Icons.wb_sunny : Icons.nights_stay,
          size: 25,
          color: Colors.yellowAccent,
        ),
      ),
      onTap: () =>
          LimitUtil.throttle(controller.changeDark, durationTime: 1000),
    )
  ];
}

Widget _buildProccess(controller) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            child: const Text(
              "上一章",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          onTap: () async {
            await controller.preChapter();
          },
        ),
      ),
      Expanded(
          flex: 2,
          child: GetBuilder<ReadController>(
            id: "chapterChange",
            builder: (controller) {
              return Slider(
                label:
                    "${controller.chapters[controller.readChapterIndex].name}",
                divisions: controller.chapters.length,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                min: 0,
                max: controller.chapters.length - 1,
                value: controller.readChapterIndex + 0,
                onChanged: (value) {
                  controller.chapterChange(value);
                },
                onChangeStart: (value) {},
                onChangeEnd: (value) {
                  controller.jumpChapter(value.toInt(), clearCount: true);
                },
              );
            },
          )),
      Expanded(
        flex: 1,
        child: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            child: const Text(
              "下一章",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          onTap: () => {
            LimitUtil.throttle(() async {
              await controller.nextChapter();
            })
          },
        ),
      ),
    ],
  );
}

Widget _buildBrighness(controller) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            child: const Icon(
              Icons.wb_sunny,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Expanded(
          flex: 4,
          child: GetBuilder<ReadController>(
            id: "brightness",
            builder: (controller) {
              return Slider(
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                min: 0,
                max: 1,
                value: controller.brightness,
                onChanged: (value) async {
                  BookHomeController home = Get.find();
                  if (home.autoBrightness) {
                    return;
                  }
                  await controller.setBrightness(value);
                },
                onChangeStart: (value) {},
                onChangeEnd: (value) {},
              );
            },
          )),
      Expanded(
        flex: 1,
        child: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            child: const Icon(
              Icons.wb_sunny,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
      GestureDetector(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 15),
          child: GetBuilder<ReadController>(
            id: "brightness",
            builder: (controller) {
              BookHomeController home = Get.find();
              if (home.autoBrightness) {
                return Container(
                  padding: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  child: const Text("Auto",
                      style: TextStyle(fontSize: 14, color: Colors.blue)),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: Colors.blue)),
                );
              }
              return Container(
                padding: const EdgeInsets.all(4),
                alignment: Alignment.center,
                child: const Text("Auto",
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.white)),
              );
            },
          ),
        ),
        behavior: HitTestBehavior.opaque,
        onTap: () {
          controller.changeAutoBrightness();
        },
      ),
    ],
  );
}

Widget _bottomType(ReadController controller) {
  if (controller.bottomType == "1") {
    return _buildProccess(controller);
  } else if (controller.bottomType == "2") {
    // 亮度调节
    return Column(
      children: [
        // 亮度,
        _buildBrighness(controller),
        // 背景色
        Container(
          height: 30,
          margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _colors(controller),
          ),
        )
      ],
    );
  } else if (controller.bottomType == "3") {
    return _buildFontSetting(controller);
  }
  return Container();
}

Widget _buildFontSetting(controller) {
  return SizedBox(
    height: 50,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          child: const Row(
            children: [
              Icon(
                Icons.menu,
                color: Colors.white,
                size: 25,
              ),
              Text(
                "-",
                style: TextStyle(color: Colors.white, fontSize: 30, height: 1),
              )
            ],
          ),
          onTap: () async {
            await controller.fontHeightSub();
          },
        ),
        GestureDetector(
          child: const Row(
            children: [
              Icon(
                Icons.menu,
                color: Colors.white,
                size: 25,
              ),
              Text(
                "+",
                style: TextStyle(color: Colors.white, fontSize: 16, height: 1),
              )
            ],
          ),
          onTap: () async {
            await controller.fontHeightAdd();
          },
        ),
        GetBuilder<ReadController>(
          id: 'autoPage',
          builder: (controller) {
            return Text("Auto",
                style: TextStyle(
                    fontSize: 16,
                    color: (controller.autoPage == null ||
                            !controller.autoPage!.isActive)
                        ? Colors.white
                        : Theme.of(controller.context).primaryColor));
          },
        ),
        GestureDetector(
          child: Image.asset(
            "lib/resource/image/screen_h.png",
            width: 25,
            color: Colors.white,
          ),
          onTap: () async {
            await controller.rotateScreenChange();
          },
        ),
        GestureDetector(
          child: Container(
            padding:
                const EdgeInsets.only(top: 3, bottom: 5, left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white)),
            child: const Text(
              "更多设置",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          onTap: () async {
            await controller.toMoreSetting();
          },
        ),
      ],
    ),
  );
}

List<Widget> _colors(ReadController controller) {
  List<Widget> list =
      List<Widget>.generate(controller.backgroundColors.length, (index) {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: hexToColor(controller.backgroundColors[index]),
        child: Text(controller.backgroundColors[index] ==
                controller.readSettingConfig.backgroundColor
            ? "√"
            : ""),
      ),
      onTap: () {
        controller.setBackGroundColor(controller.backgroundColors[index]);
      },
    );
  });
  // Aa+ Aa-
  list.add(GestureDetector(
    child: Container(
      padding: const EdgeInsets.only(left: 4, right: 4),
      alignment: Alignment.center,
      child:
          const Text("重置", style: TextStyle(fontSize: 14, color: Colors.white)),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.white)),
    ),
    onTap: () async {
      await controller.resetReadSetting();
    },
  ));
  list.add(GestureDetector(
    child: Container(
      padding: const EdgeInsets.only(left: 4, right: 4),
      alignment: Alignment.center,
      child: const Text("自定义",
          style: TextStyle(fontSize: 14, color: Colors.white)),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.white)),
    ),
    onTap: () async {
      await controller.toSetting();
    },
  ));
  return list;
}
