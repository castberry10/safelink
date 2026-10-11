import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safelink_app/components/button.dart';
import 'package:safelink_app/const/colors.dart';
import 'package:safelink_app/const/value_name.dart';
import 'package:safelink_app/services/local_data_manager.dart';
import 'package:safelink_app/services/localization_service.dart';
import 'package:safelink_app/services/platform_channel_service.dart';

class SettingBrowserScreen extends StatefulWidget {
  final String? useBrowser;
  const SettingBrowserScreen({super.key, this.useBrowser});

  @override
  State<SettingBrowserScreen> createState() => _SettingBrowserScreenState();
}

class _SettingBrowserScreenState extends State<SettingBrowserScreen> {
  late final LocalDataManager _localDataManager;
  late final PlatformChannelService _platformChannelService;

  List<dynamic> _browserData = [];
  List<String> browserNames = [];
  List<String> browserPackNames = [];
  String? selectedBrowser;
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    _localDataManager = LocalDataManager();
    _platformChannelService = PlatformChannelService();
    _loadBrowser();
  }

  Future<void> _loadBrowser() async {
    try {
      _browserData = await _platformChannelService.getInstalledBrowsers();
      _browserData =
          _browserData.where((item) => item["name"] != "SafeLink").toList();

      final browserList = _browserData
          .whereType<Map<Object?, Object?>>()
          .map((item) => item.cast<String, String>())
          .toList();

      setState(() {
        browserPackNames =
            browserList.map((item) => item["packageName"]!).toList();
        browserNames = browserList.map((item) => item["name"]!).toList();

        int index =
            browserNames.indexWhere((name) => name == widget.useBrowser);
        if (index == -1) index = 0;
        selectIndex = index;
        selectedBrowser = browserNames.isNotEmpty ? browserNames[index] : null;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to load browser list: $e');
    }
  }

  Future<void> _saveSetting() async {
    try {
      await _localDataManager.setStringData(
          ValueName.useBrowserPackageName, browserPackNames[selectIndex]);
      await _localDataManager.setStringData(
          ValueName.useBrowser, browserNames[selectIndex]);
    } catch (e) {
      debugPrint('Failed to save browser setting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 80, bottom: 20),
                      child: Text(
                        tr('browser_select_title'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: context.textColor),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        // Extra bottom padding prevents the last item from hiding under the button
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: browserNames.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              browserNames[index],
                              style: TextStyle(
                                  fontSize: 20, color: context.textColor),
                            ),
                            trailing: Radio<String>(
                              value: browserNames[index],
                              groupValue: selectedBrowser,
                              onChanged: (value) {
                                setState(() {
                                  selectedBrowser = value;
                                  selectIndex = index;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: customButton(
                onPressed: () {
                  _saveSetting();
                  Navigator.pop(context, browserNames[selectIndex]);
                },
                text: tr('common_next'),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}