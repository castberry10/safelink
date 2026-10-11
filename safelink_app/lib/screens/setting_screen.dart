import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safelink_app/components/toast.dart';
import 'package:safelink_app/components/warning.dart';
import 'package:safelink_app/const/colors.dart';
import 'package:safelink_app/const/value_name.dart';
import 'package:safelink_app/screens/setting_browser_screen.dart';
import 'package:safelink_app/screens/splash_screen.dart';
import 'package:safelink_app/services/local_data_manager.dart';
import 'package:safelink_app/services/localization_service.dart';
import 'package:safelink_app/services/platform_channel_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late final LocalDataManager _localDataManager;
  late final PlatformChannelService _platformChannelService;

  String useBrowser = "none";
  bool defaultBrowser = false;
  bool isLogging = false;
  bool isAutoOpen = false;
  bool isLoadSetting = false;

  @override
  void initState() {
    super.initState();
    _platformChannelService = PlatformChannelService();
    _localDataManager = LocalDataManager();
    _loadSetting();
  }

  Future<void> _loadSetting() async {
    try {
      final useBrowserValue =
          await _localDataManager.getStringData(ValueName.useBrowser);
      final defaultBrowserValue =
          await _localDataManager.getBoolData(ValueName.defaultBrowser);
      final isAutoOpenValue =
          await _localDataManager.getBoolData(ValueName.autoOpen);
      final isLoggingValue =
          await _localDataManager.getBoolData(ValueName.logging);

      if (!mounted) return;

      setState(() {
        defaultBrowser = defaultBrowserValue ?? false;
        isAutoOpen = isAutoOpenValue ?? false;
        isLogging = isLoggingValue ?? false;
        useBrowser = useBrowserValue ?? useBrowser;
        isLoadSetting = true;
      });
    } catch (e) {
      await LocalDataManager.initData();
      if (!mounted) return;
      setState(() {
        defaultBrowser = false;
        isAutoOpen = false;
        isLogging = false;
        useBrowser = "none";
        isLoadSetting = true;
      });
    }
  }

  Future<void> _saveSetting() async {
    await _localDataManager.setBoolData(ValueName.defaultBrowser, defaultBrowser);
    await _localDataManager.setBoolData(ValueName.autoOpen, isAutoOpen);
    await _localDataManager.setBoolData(ValueName.logging, isLogging);
  }

  Future<void> _setAsDefaultBrowser() async {
    try {
      await _platformChannelService.setAsDefaultBrowser();
    } on PlatformException catch (e) {
      debugPrint('Failed to set as default browser: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(surfaceTintColor: context.surfaceColor),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 8, bottom: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  tr('settings_title'),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: !isLoadSetting
                        ? SliverChildListDelegate([])
                        : SliverChildListDelegate([
                            // ── Browser settings ─────────────────────
                            _section(
                              label: tr('settings_browser_section'),
                              children: [
                                _arrowTile(
                                  label: tr('settings_set_default_browser'),
                                  onTap: _setAsDefaultBrowser,
                                ),
                                _arrowTileWithValue(
                                  label: tr('settings_select_browser'),
                                  value: useBrowser == 'none'
                                      ? '-'
                                      : useBrowser,
                                  onTap: () async {
                                    final result =
                                        await Navigator.push<String>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SettingBrowserScreen(
                                                useBrowser: useBrowser ==
                                                        'none'
                                                    ? null
                                                    : useBrowser),
                                      ),
                                    );
                                    if (result != null) {
                                      setState(
                                          () => useBrowser = result);
                                      _saveSetting();
                                    }
                                  },
                                ),
                              ],
                            ),
                            _divider(),

                            // ── Other settings ─────────────────────────
                            _section(
                              label: tr('settings_other_section'),
                              children: [
                                SwitchListTile(
                                  title: Text(
                                    tr('settings_logging'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                      tr('settings_logging_desc')),
                                  value: isLogging,
                                  onChanged: (v) {
                                    setState(() => isLogging = v);
                                    _saveSetting();
                                  },
                                ),
                                SwitchListTile(
                                  title: Text(
                                    tr('settings_auto_open'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                      tr('settings_auto_open_desc')),
                                  value: isAutoOpen,
                                  onChanged: (v) {
                                    setState(() => isAutoOpen = v);
                                    _saveSetting();
                                  },
                                ),
                              ],
                            ),
                            _divider(),

                            // ── History / reset ─────────────────────────
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showConfirmDialog(
                                        context: context,
                                        title: tr(
                                            'dialog_clear_history_title'),
                                        content: tr(
                                            'dialog_clear_history_content'),
                                        onConfirm: () {
                                          _localDataManager
                                              .deleteVisitedUrl();
                                          showToast(tr(
                                              'toast_history_cleared'));
                                        },
                                      );
                                    },
                                    child: Text(
                                      tr('settings_clear_history'),
                                      style: TextStyle(
                                          color: context.textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showConfirmDialog(
                                        context: context,
                                        title: tr(
                                            'dialog_reset_data_title'),
                                        content: tr(
                                            'dialog_reset_data_content'),
                                        onConfirm: () {
                                          LocalDataManager.initData();
                                          showToast(
                                              tr('toast_data_reset'));
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const SplashScreen()),
                                            (route) => false,
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      tr('settings_reset_data'),
                                      style: const TextStyle(
                                          color: AppColors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(
      {required String label, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 13, color: context.textSecondaryColor),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(height: 8, color: context.cardColor);

  Widget _arrowTile(
      {required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: TextButton(
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: context.textColor, fontSize: 16),
            ),
            Icon(Icons.arrow_forward_ios_outlined,
                color: context.textColor, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _arrowTileWithValue({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: TextButton(
        onPressed: onTap,
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: context.textColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: context.textColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}