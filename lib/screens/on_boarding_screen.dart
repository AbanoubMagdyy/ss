import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:premium_fivver_note_app/components/components.dart';
import 'package:premium_fivver_note_app/screens/create_account_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final TextStyle titleStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 24);

  final PageController controller = PageController();

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentPageIndex = controller.page!.round();
      });
    });
  }

  List<String> titles = [
    'Welcome to the magical world of note-taking!',
    'Categorize your notes  by to your favorite character',
    'Customize your notes with Harry Potter-inspired fonts and colors',
  ];

  List images = [
    'assets/images/on_boarding/Notebook-amico.png',
    'assets/images/on_boarding/Notebook-cuate (1).png',
    'assets/images/on_boarding/Notebook-pana (1).png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// skip
            icon(
              onTap: () {
                navigateAndFinish(context, const CreateAccount());
              },
              widget: const Text(
                'skip',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              top: 25,
              bottom: 0,
            ),



            ///page view
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                        images[index],
                      ),
                    ),
                  ),
                ),
                controller: controller,
                itemCount: 3,
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),

                    ///  text
                    Expanded(
                      child: Center(
                        child: Text(
                          titles[currentPageIndex].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    /// indicator and skip button
                    Row(
                      children: [
                        /// indicator
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 10),
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: 3,
                            effect: const ExpandingDotsEffect(
                              dotWidth: 20,
                              dotHeight: 6,
                              dotColor: Colors.grey,
                              activeDotColor: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                        icon(
                            onTap: () {
                              if(currentPageIndex == 2){
                                navigateAndFinish(context, const CreateAccount());
                              }else{
                                controller.nextPage(
                                    duration: const Duration(milliseconds: 300), curve: Curves.ease);
                              }
                            },
                            widget: const Icon(
                              Icons.arrow_forward_ios,
                              size: 25,
                              color: Colors.white,
                            ),
                            top: 0,
                            bottom: 25),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  icon({
    required Widget widget,
    required double top,
    required double bottom,
    required Function() onTap,
  }) =>
      Container(
        height: 60,
        width: 85,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(top),
            topStart: Radius.circular(bottom),
          ),
        ),
        child: IconButton(onPressed: onTap, icon: widget),
      );
}
