import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/screens/demo/app_drawer.dart';
import 'package:spot_check/screens/demo/todo_item.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/store/controllers/tabs.controller.dart';
import 'package:spot_check/store/controllers/todo.controller.dart';
import 'package:spot_check/widgets/components.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen>
    with TickerProviderStateMixin {
  AuthController authController = AuthController.to;
  late MyTabController tabsController;
  @override
  void initState() {
    super.initState();
    tabsController = Get.put(MyTabController(), permanent: false);
  }

  buildBottomNavigationMenu(context, tabsController) {
    TextStyle unselectedLabelStyle = TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontWeight: FontWeight.w500,
        fontSize: 12);

    TextStyle selectedLabelStyle = const TextStyle(
        color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);

    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          height: 60,
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: tabsController.changeTabIndex,
            currentIndex: tabsController.tabIndex.value,
            backgroundColor: AppColors.primary,
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedItemColor: Colors.white,
            unselectedLabelStyle: unselectedLabelStyle,
            selectedLabelStyle: selectedLabelStyle,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  child: const Icon(
                    Icons.home,
                    size: 20.0,
                  ),
                ),
                label: 'Home',
                backgroundColor: AppColors.primary,
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  child: const Icon(
                    Icons.search,
                    size: 20.0,
                  ),
                ),
                label: 'Explore',
                backgroundColor: AppColors.primary,
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  child: const Icon(
                    Icons.location_history,
                    size: 20.0,
                  ),
                ),
                label: 'Places',
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    // final userImage = CircleAvatar(
    //   radius: 30,
    //   backgroundImage: NetworkImage(authController.user.value?.photoURL ?? ""),
    // );
    TodoController c = Get.put<TodoController>(TodoController());
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      bottomNavigationBar: buildBottomNavigationMenu(context, tabsController),
      appBar: AppBar(
        title: Obx(() => authController.user.value?.displayName != ""
            ? Text(" ${authController?.user?.value?.email}")
            : Container()),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu)),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                authController.handleSignOut();
              })
        ],
      ),
      body: Obx(() {
        if (c.isLoadingTodos.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.todos.isEmpty) {
          return const Center(child: Text('Nothing to do'));
        }
        // ListView.builder(
        //           itemCount: c.todos.length,
        //           itemBuilder: (context, index) {
        //             return TodoItem(c.todos.elementAt(index));
        //           });
        return Obx(() => IndexedStack(
              index: tabsController!.tabIndex.value,
              children: [
                ListView.builder(
                    itemCount: c.todos.length,
                    itemBuilder: (context, index) {
                      return TodoItem(c.todos.elementAt(index));
                    }),
                const Center(
                  child: PromText(text: "this is explore"),
                ),
                const Center(
                  child: PromText(text: "this is settings"),
                )
              ],
            ));
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed("/add-todo"),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
