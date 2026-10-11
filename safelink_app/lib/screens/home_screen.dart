import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:safelink_app/components/app_bar.dart';
import 'package:safelink_app/components/button.dart';
import 'package:safelink_app/components/toast.dart';
import 'package:safelink_app/const/colors.dart';
import 'package:safelink_app/screens/log_screen.dart';
import 'package:safelink_app/screens/result_screen.dart';
import 'package:safelink_app/services/localization_service.dart';
import 'package:safelink_app/utils/utils.dart';

class SafeLinkHomePage extends StatefulWidget {
  const SafeLinkHomePage({super.key});

  @override
  State<SafeLinkHomePage> createState() => _SafeLinkHomePageState();
}

class _SafeLinkHomePageState extends State<SafeLinkHomePage> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final AppLinks _appLinks;

  bool click = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _initAppLinks();
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _initAppLinks() {
    _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri == null) return;
      final link = uri.toString();
      if (link.isNotEmpty) goToCheck(link);
    });
  }

  void goToCheck(String url) async {
    if (url.isEmpty) {
      showToast(tr('toast_url_empty'));
      return;
    }
    _focusNode.unfocus();

    final connected = await hasInternetConnection();
    if (!connected) {
      showToast(tr('toast_no_internet'));
      return;
    }

    if (!url.startsWith('https://') && !url.startsWith('http://')) {
      url = 'https://$url';
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: safeLinkAppBar(context),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Expanded(flex: 1, child: SizedBox(height: 12)),
                        const SizedBox(height: 12),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () => setState(() => click = true),
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Lottie.asset(
                                'assets/animations/logo_animation.json',
                                repeat: false,
                                animate: click,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          tr('home_input_hint'),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const Expanded(flex: 1, child: SizedBox(height: 12)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextButton(
                          onPressed: () {
                            _focusNode.unfocus();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LogScreen()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tr('home_view_history'),
                                style: TextStyle(
                                    color: context.textColor, fontSize: 16),
                              ),
                              Icon(Icons.arrow_forward_ios_outlined,
                                  color: context.textColor),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 0),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: context.textColor),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: tr('home_url_placeholder'),
                            hintStyle: TextStyle(
                                color: context.textSecondaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      customButton(
                        onPressed: () {
                          final url = _controller.text;
                          if (isValidUrl(url)) {
                            _controller.clear();
                            goToCheck(url);
                          } else {
                            showToast(tr('toast_invalid_url'));
                          }
                        },
                        text: tr('home_btn_scan'),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}