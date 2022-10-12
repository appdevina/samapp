part of 'screen.dart';

class MainPage extends StatelessWidget {
  final controller = Get.arguments == null
      ? Get.put(MainPageController())
      : Get.put(MainPageController(initAfter: Get.arguments));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          SafeArea(
            child: Container(
              color: 'FAFAFC'.toColor(),
            ),
          ),
          SafeArea(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: (index) {
                controller.swipePage(index);
              },
              children: [
                GetBuilder<MainPageController>(
                    id: 'mode',
                    builder: (_) => (controller.role == null)
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : (controller.role == 1 ||
                                controller.role == 2 ||
                                controller.role == 3 ||
                                controller.role == 8)
                            ? HomePage()
                            : ArHomeScreen()),
                ListNooPage(),
                ProfilePage(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GetBuilder<MainPageController>(
              id: 'bottomnavbar',
              builder: (_) {
                return CustomBottomNavBar(
                  onTap: (index) {
                    controller.chaneNavbarBottom(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
