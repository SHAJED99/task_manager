import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/button_widget.dart';
import 'package:task_manager/widgets/card_widget.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});
  final Data data = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Data>(
      builder: (_) => Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(right: defaultPadding * 2, top: MediaQuery.of(context).padding.top),
        // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        constraints: const BoxConstraints(
          maxWidth: 400 + (defaultPadding * 2),
        ),
        color: Theme.of(context).primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile information
            FullProfileImage(data: data),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 4, vertical: defaultPadding / 4),
              child: CustomElevatedButton(
                enableBackgroundColor: defaultTextColorDark,
                borderRadius: defaultPadding / 4,
                onPressed: () => data.logoutRequest(),
                child: Text("Logout", style: head1.copyWith(color: Theme.of(context).primaryColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile picture
class FullProfileImage extends StatelessWidget {
  const FullProfileImage({
    super.key,
    required this.data,
  });

  final Data data;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      alignment: null,
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(maxHeight: 300),
      child: Stack(
        children: [
          // Profile picture
          SizedBox(
            width: double.infinity,
            child: Image.network(
              data.userData.photo ?? "",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => FractionallySizedBox(
                heightFactor: 1,
                child: FittedBox(
                  child: Icon(Icons.person, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomCard(
              backgroundColor: defaultTextColorLight.withOpacity(0.5),
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text("${data.userData.firstName ?? "Unknown"} ${data.userData.lastName ?? ""}", style: title),
                    // Email
                    Text(data.userData.email ?? "Unknown", style: subTitle1.copyWith(color: defaultTextColorDark)),
                    // Mobile
                    Text(data.userData.mobile ?? "Unknown", style: subTitle1.copyWith(color: defaultTextColorDark))
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: defaultPadding / 2,
            right: defaultPadding / 2,
            child: CustomIconButton(
              backgroundColor: Theme.of(context).primaryColor,
              padding: defaultPadding / 2,
              size: defaultPadding * 2.5,
              icon: const Icon(
                Icons.edit,
                color: defaultTextColorDark,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
