import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/data_controller.dart';
import 'package:task_manager/models/task_status.dart';
import 'package:task_manager/screens/task_details_screen.dart';
import 'package:task_manager/style.dart';
import 'package:task_manager/widgets/app_bar_widget.dart';
import 'package:task_manager/widgets/app_drawer_widget.dart';
import 'package:task_manager/widgets/background_image_widget.dart';
import 'package:task_manager/widgets/botton_navigation_bar.dart';
import 'package:task_manager/widgets/status_count_tiles_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  final Data data = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      appBar: CustomAppBar(onTap: () => scaffoldKey.currentState!.openDrawer()),
      body: BackgroundImage(
        child: RefreshIndicator(
          onRefresh: () async {
            await data.reloadData();
          },
          child: Column(
            children: [
              // If New Task Page then add some other widgets
              StatusCountTiles(show: currentIndex == 0),
              Expanded(child: TaskDetailsScreen(taskStatus: TaskStatus.values[currentIndex])),
            ],
          ),
        ),
      ),

      // If New Task Page then add some other widgets
      floatingActionButton: currentIndex != 0
          ? null
          : FloatingActionButton.small(
              elevation: defaultElevation,
              onPressed: () {},
              child: const Icon(Icons.add),
            ),

      // Botton navbar
      bottomNavigationBar: CustomBottomNavigationBar(
        onPressed: (index) => setState(() => currentIndex = index),
        customBottomNavigationBarItems: const [
          CustomBottomNavigationBarItems(icon: Icons.task, label: "New Task"),
          CustomBottomNavigationBarItems(icon: Icons.task, label: "Completed"),
          CustomBottomNavigationBarItems(icon: Icons.task, label: "Canceled"),
          CustomBottomNavigationBarItems(icon: Icons.task, label: "Progress"),
        ],
      ),
    );
  }
}
