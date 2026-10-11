import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:safelink_app/components/animation_text.dart';
import 'package:safelink_app/components/button.dart';
import 'package:safelink_app/components/toast.dart';
import 'package:safelink_app/const/colors.dart';
import 'package:safelink_app/const/value_name.dart';
import 'package:safelink_app/screens/home_screen.dart';
import 'package:safelink_app/screens/setting_browser_screen.dart';
import 'package:safelink_app/services/local_data_manager.dart';
import 'package:safelink_app/services/localization_service.dart';
import 'package:safelink_app/services/platform_channel_service.dart';
import 'package:safelink_app/utils/utils.dart';
import '../services/safelink_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SafeLinkService _safeLinkService;
  late final LocalDataManager _localDataManager;
  late final PlatformChannelService _platformChannelService;

  final PageController _pageController = PageController();
  int pageCnt = 0;
  bool isDefaultBrowser = false;
  bool isSettingUseBrowser = false;

  @override
  void initState() {
    super.initState();
    _platformChannelService = PlatformChannelService();
    _safeLinkService = SafeLinkService();
    _localDataManager = LocalDataManager();
    _signIn();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final connected = await hasInternetConnection();
    if (!connected) {
      showToast(tr('toast_no_internet'));
      return;
    }

    final username = "user_${generateRandomSixDigitValue()}";
    await _localDataManager.setStringData(ValueName.username, username);

    final signUpStatus = await _safeLinkService.signUp(username);
    final signInStatus = await _safeLinkService.signIn(username);

    if (signUpStatus['status'] >= 400) {
      showToast("${tr('toast_signup_failed')}${signUpStatus['message']}");
    }

    if (signInStatus['status'] < 300) {
      showToast(tr('toast_login_success'));
    } else if (signInStatus['status'] == 401) {
      showToast(tr('toast_server_response_error'));
    } else {
      showToast(tr('toast_login_failed'));
    }
  }

  Future<void> _setDefaultBrowser() async {
    try {
      await _platformChannelService.setAsDefaultBrowser();
    } catch (e) {
      showToast(tr('toast_default_browser_failed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => pageCnt = index),
              children: [
                Scaffold(
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: SizedBox.expand(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 52,
                              child: Lottie.asset(
                                  'assets/animations/logo_animation.json'),
                            ),
                            DelayedSlideText(
                              text: tr('onboarding_intro_line0'),
                              size: 24,
                              color: AppColors.primaryColor,
                              delay: Duration.zero,
                            ),
                            const SizedBox(height: 4),
                            DelayedSlideText(
                              text: "${tr('onboarding_intro_line1')} ${tr('onboarding_intro_line2')} ${tr('onboarding_intro_line3')}",
                              size: 24,
                              color: context.textColor,
                              delay: const Duration(milliseconds: 600),
                            ),
                            const SizedBox(height: 100,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: SizedBox.expand(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DelayedSlideText(
                              text: "${tr('onboarding_browser_title1')} ${tr('onboarding_browser_title2')}",
                              size: 24,
                              color: context.textColor,
                              delay: Duration.zero,
                            ),
                            const SizedBox(height: 16),
                            DelayedSlideText(
                              text: tr('onboarding_browser_desc'),
                              size: 16,
                              color: context.textColor,
                              delay: const Duration(milliseconds: 200),
                              isBorder: false,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: SizedBox.expand(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DelayedSlideText(
                              text: tr('onboarding_select_title1'),
                              size: 24,
                              color: context.textColor,
                              delay: Duration.zero,
                            ),
                            DelayedSlideText(
                              text: tr('onboarding_select_title2'),
                              size: 24,
                              color: context.textColor,
                              delay: Duration.zero,
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 16),
                            DelayedSlideText(
                              text: tr('onboarding_select_desc'),
                              size: 16,
                              color: context.textColor,
                              delay: const Duration(milliseconds: 200),
                              isBorder: false,
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pageCnt == index
                          ? AppColors.primaryColor
                          : context.textSecondaryColor.withAlpha(80),
                    ),
                  );
                }),
              ),
            ),

            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: pageCnt == 1
                      ? isDefaultBrowser
                          ? customButton(
                              onPressed: () => _pageController.nextPage(
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              ),
                              text: tr('common_next'),
                            )
                          : customButton(
                              onPressed: () {
                                setState(
                                    () => isDefaultBrowser = true);
                                _setDefaultBrowser();
                              },
                              text: tr('onboarding_btn_set_default'),
                            )
                      : pageCnt < 2
                          ? customButton(
                              onPressed: () => _pageController.nextPage(
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              ),
                              text: tr('common_next'),
                            )
                          : isSettingUseBrowser
                              ? customButton(
                                  onPressed: () =>
                                      Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const SafeLinkHomePage()),
                                    (route) => false,
                                  ),
                                  text: tr('onboarding_btn_start'),
                                )
                              : customButton(
                                  text: tr('onboarding_btn_select_browser'),
                                  onPressed: () {
                                    setState(
                                        () => isSettingUseBrowser = true);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const SettingBrowserScreen()),
                                    );
                                  },
                                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}