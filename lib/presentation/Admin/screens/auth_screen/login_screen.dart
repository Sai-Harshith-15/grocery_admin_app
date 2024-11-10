import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../routes/routes.dart';
import '../../../widgets/mytext.dart';
import '../../../widgets/responsive.dart';
import '../../../widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Wrap(
          runSpacing: 0, //vertically
          spacing: 30, // hor
          runAlignment: WrapAlignment.center, //vertical

          crossAxisAlignment: WrapCrossAlignment.center, //hor
          alignment: WrapAlignment.center, //hor
          direction: Responsive.isDesktop(context) ||
                  Responsive.isDesktopLarge(context)
              ? Axis.horizontal
              : Axis.vertical,
          children: [
            //logo
            Responsive.isDesktop(context) || Responsive.isDesktopLarge(context)
                ? SizedBox(
                    height: Responsive.isDesktop(context) ||
                            Responsive.isDesktopLarge(context)
                        ? MediaQuery.of(context).size.height * 0.3
                        : MediaQuery.of(context).size.height,
                    width: Responsive.isDesktop(context) ||
                            Responsive.isDesktopLarge(context)
                        ? MediaQuery.of(context).size.width * 0.5
                        : MediaQuery.of(context).size.width * 0.9,
                    child: Center(
                      child: Container(
                        height: 200,
                        width: 600,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/Logo.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            //textfields
            SizedBox(
              width: Responsive.isDesktop(context) ||
                      Responsive.isDesktopLarge(context)
                  ? MediaQuery.of(context).size.width * 0.35
                  : MediaQuery.of(context).size.width * 1,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isDesktop(context) ||
                          Responsive.isDesktopLarge(context)
                      ? 0
                      : 10,
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: Responsive.isDesktop(context) ||
                            Responsive.isDesktopLarge(context)
                        ? MediaQuery.of(context).size.height * .1
                        : Responsive.isMobile(context) ||
                                Responsive.isMobileLarge(context)
                            ? 50
                            : 0,
                  ),
                  decoration: BoxDecoration(
                    // color: const Color.fromARGB(255, 214, 213, 213),
                    border: Border.all(
                      color: AppColors.primaryBlack,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Responsive.isDesktop(context) ||
                                Responsive.isDesktopLarge(context)
                            ? const SizedBox.shrink()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 300,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/Logo.png"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ||
                                  Responsive.isDesktopLarge(context)
                              ? 30
                              : 50,
                        ),
                        HeadText(
                          text: "Login",
                          textSize: 25,
                          textWeight: FontWeight.w800,
                          textColor: AppColors.primaryBlack,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        HeadText(
                          text: "Enter your Eamil and Password",
                          textSize: 14,
                          textWeight: FontWeight.w400,
                          textColor: AppColors.primaryBlack,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        HeadText(
                          text: "Email",
                          textSize: Responsive.isDesktop(context) ||
                                  Responsive.isDesktopLarge(context)
                              ? 16
                              : 14,
                        ),
                        CustomTextField(),
                        const SizedBox(
                          height: 40,
                        ),
                        HeadText(
                          text: "Password",
                          textSize: Responsive.isDesktop(context) ||
                                  Responsive.isDesktopLarge(context)
                              ? 16
                              : 14,
                        ),
                        CustomTextField(
                          isObsecre: true,
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.visibility_off,
                                color: AppColors.primaryBlack,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: HeadText(
                            textSize: 14,
                            textWeight: FontWeight.w500,
                            text: "forgot password?",
                            textColor: AppColors.primaryBlack,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: MaterialButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.sidebarScreen);
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 25,
                                  horizontal:
                                      MediaQuery.of(context).size.width * .1),
                              color: AppColors.primaryGreen,
                              child: HeadText(
                                text: "Login",
                                textSize: 20,
                                textWeight: FontWeight.w800,
                                textColor: AppColors.background,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HeadText(
                              textSize: 14,
                              textWeight: FontWeight.w500,
                              text: "Don't have an account?",
                              textColor: AppColors.primaryBlack,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            HeadText(
                              textSize: 14,
                              textWeight: FontWeight.w900,
                              text: "Register",
                              textColor: AppColors.primaryBlack,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
