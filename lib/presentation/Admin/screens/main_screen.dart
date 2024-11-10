import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../widgets/mytext.dart';
import '../../widgets/responsive.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        // appBar: MyAppBar(title: 'Main Screen'),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: Responsive.isDesktop(context) ||
                      Responsive.isDesktopLarge(context)
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: HeadText(
                      text: "Dashboard",
                      textSize: 20,
                      textWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: Responsive.isDesktop(context) ||
                              Responsive.isDesktopLarge(context)
                          ? MediaQuery.of(context).size.width * .2
                          : MediaQuery.of(context).size.width * .9,
                      child: Card(
                        color: AppColors.background,
                        elevation: 5,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HeadText(text: "Total Sales"),
                              HeadText(text: "\$ 100000"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: Responsive.isDesktop(context) ||
                              Responsive.isDesktopLarge(context)
                          ? MediaQuery.of(context).size.width * .2
                          : MediaQuery.of(context).size.width * .9,
                      child: Card(
                        color: AppColors.background,
                        elevation: 5,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HeadText(text: "Total Sales"),
                              HeadText(text: "\$ 100000"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: Responsive.isDesktop(context) ||
                              Responsive.isDesktopLarge(context)
                          ? MediaQuery.of(context).size.width * .2
                          : MediaQuery.of(context).size.width * .9,
                      child: Card(
                        color: AppColors.background,
                        elevation: 5,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HeadText(text: "Total Sales"),
                              HeadText(text: "\$ 100000"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: Responsive.isDesktop(context) ||
                              Responsive.isDesktopLarge(context)
                          ? MediaQuery.of(context).size.width * .2
                          : MediaQuery.of(context).size.width * .9,
                      child: Card(
                        color: AppColors.background,
                        elevation: 5,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HeadText(text: "Total Sales"),
                              HeadText(text: "\$ 100000"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //bar chart
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .5,
                      width: Responsive.isDesktop(context) ||
                              Responsive.isDesktopLarge(context)
                          ? MediaQuery.of(context).size.width * .5
                          : MediaQuery.of(context).size.width * .9,
                      child: Card(
                        color: AppColors.background,
                        elevation: 5,
                        child: const HeadText(text: "Bar Graph"),
                      ),
                    ),
                    //pie chart
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .5,
                      width: Responsive.isDesktop(context) ||
                              Responsive.isDesktopLarge(context)
                          ? MediaQuery.of(context).size.width * .315
                          : MediaQuery.of(context).size.width * .9,
                      child: Card(
                        color: AppColors.background,
                        elevation: 5,
                        child: const HeadText(text: "Pie Chart"),
                      ),
                    ),
                    //orders details
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .5,
                      width: Responsive.isDesktop(context) ||
                              Responsive.isDesktopLarge(context)
                          ? MediaQuery.of(context).size.width * .5
                          : MediaQuery.of(context).size.width * .9,
                      child: Card(
                        color: AppColors.background,
                        elevation: 5,
                        child: const HeadText(text: "Order details"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
