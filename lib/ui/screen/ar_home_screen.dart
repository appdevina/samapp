part of 'screen.dart';

class ArHomeScreen extends StatelessWidget {
  ArHomeScreen({Key? key}) : super(key: key);
  final homeController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/sam.png',
              ),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }
}
