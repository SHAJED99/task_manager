import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/style.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function()? onTap;
  final Widget? leading;
  final double height;
  final double elevation;

  const CustomAppBar({super.key, this.onTap, this.leading, this.height = defaultNavHeight, this.elevation = defaultElevation});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final Data data = Get.find();
  bool isValid = true;

  Widget circularImage({required String url, required Color backgroundColor}) {
    var netImage = ClipOval(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  isValid = false;
                  setState(() {});
                })),
      ),
    );

    if (isValid) {
      return netImage;
    } else {
      return ClipOval(
        child: Container(
          alignment: Alignment.center,
          color: defaultTextColorDark,
          child: FractionallySizedBox(
            heightFactor: 0.8,
            child: FittedBox(
              child: Icon(Icons.person, color: backgroundColor),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      elevation: widget.elevation,
      child: Row(
        children: [
          // Icon button, if given
          if (widget.leading != null)
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: defaultPadding),
              child: widget.leading,
            ),

          // User details
          Expanded(
            child: GetBuilder<Data>(builder: (_) {
              return InkWell(
                onTap: widget.onTap,
                child: Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    children: [
                      // Showing profile photo
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                        alignment: Alignment.center,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: circularImage(url: data.userData.photo ?? "", backgroundColor: Theme.of(context).primaryColor),
                        ),
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Flexible(child: Text("${data.userData.firstName ?? "Unknown"} ${data.userData.lastName ?? ""}", style: title)),
                            const SizedBox(height: defaultPadding / 10),
                            // Email
                            Flexible(child: Text(data.userData.email ?? "Unknown", style: subTitle1.copyWith(color: defaultTextColorDark))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
