import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:safelink_app/components/button.dart';
import 'package:safelink_app/components/tag.dart';
import 'package:safelink_app/components/toast.dart';
import 'package:safelink_app/const/colors.dart';
import 'package:safelink_app/const/value_name.dart';
import 'package:safelink_app/screens/setting_screen.dart';
import 'package:safelink_app/services/local_data_manager.dart';
import 'package:safelink_app/services/localization_service.dart';
import 'package:safelink_app/services/platform_channel_service.dart';
import 'package:safelink_app/services/safelink_service.dart';
import 'package:safelink_app/utils/analyze_result.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends StatefulWidget {
  final String url;
  const ResultScreen({super.key, required this.url});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final String url;

  // Settings
  bool _logging = true;
  bool _autoOpen = true;
  String _browser = 'none';

  // Scan progress
  bool _scanning = true;
  bool _pageCheckDone = false;
  bool _didAutoOpen = false;

  // URL display
  bool _urlExpanded = false;

  // Scan result — 0: init, 1: safe, 2: caution, 3: danger, 4: error
  int _safeState = 0;
  String _summary = '';
  String _detail = '';

  late final SafeLinkService _service;
  late final PlatformChannelService _platform;
  late final LocalDataManager _storage;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    url = widget.url;
    _service = SafeLinkService();
    _platform = PlatformChannelService();
    _storage = LocalDataManager();
    Future.microtask(_init);
  }

  Future<void> _init() async {
    await _loadSettings();
    if (_logging) await _storage.addVisitedUrl(url);
    await _runScan(url);
  }

  // ── Settings ───────────────────────────────────────────────────────────────

  Future<void> _loadSettings() async {
    final values = await Future.wait<dynamic>([
      _storage.getStringData(ValueName.useBrowserPackageName),
      _storage.getBoolData(ValueName.logging),
      _storage.getBoolData(ValueName.autoOpen),
    ]);

    if (!mounted) return;
    setState(() {
      _browser  = (values[0] as String?) ?? _browser;
      _logging  = (values[1] as bool?)   ?? _logging;
      _autoOpen = (values[2] as bool?)   ?? _autoOpen;
      _summary  = tr('scan_summary_error');
      _detail   = tr('toast_check_error');
    });
  }

  // ── Scan logic ─────────────────────────────────────────────────────────────

  Future<void> _runScan(String url) async {
    if (mounted) setState(() => _scanning = true);

    try {
      final pageResult = await Future.any([
        _fetchPage(url),
        Future.delayed(
          const Duration(seconds: 30),
          () => throw TimeoutException('Scan timed out'),
        ),
      ]);

      final analysis = analyzeResult(
        llmScore: pageResult['result'] as int,
        google: 0,
        llmText: (pageResult['message'] as List<dynamic>)
            .whereType<String>()
            .join('\n'),
      );

      if (!mounted) return;

      final state      = analysis['state'] as int;
      final detail     = analysis['text']  as String;
      final summary    = _labelForState(state);
      final shouldOpen = state == 1 && _autoOpen && !_didAutoOpen;

      setState(() {
        _safeState = state;
        _detail    = state == 0 ? tr('toast_check_error') : detail;
        _summary   = summary;
        _scanning  = false;
        if (shouldOpen) _didAutoOpen = true;
      });

      if (shouldOpen) _openInBrowser(url);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _pageCheckDone = true;
        _scanning  = false;
        _safeState = 4;
        _summary = tr('scan_summary_error');
        _detail  = tr('toast_check_error');
      });
      showToast(tr('toast_server_error'));
    }
  }

  Future<Map<String, dynamic>> _fetchPage(String url) async {
    final result = await _service.checkPage(urlData: url);
    if (mounted) setState(() => _pageCheckDone = true);
    return result;
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _openInBrowser(String url) async {
    if (_browser == 'none') {
      showToast(tr('toast_browser_not_set'));
      return;
    }
    if (!await canLaunchUrl(Uri.parse(url))) {
      showToast(tr('toast_invalid_url_open'));
      return;
    }
    try {
      await _platform.openOtherBrowser(url, _browser);
    } catch (_) {
      showToast(tr('toast_cannot_open'));
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _labelForState(int state) => switch (state) {
    1 => tr('scan_summary_safe'),
    2 => tr('scan_summary_caution'),
    3 => tr('scan_summary_danger'),
    _ => tr('scan_summary_error'),
  };

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomScrollView(
                  slivers: [
                    _buildAppBar(),
                    _buildStatusLabel(),
                    _buildUrlRow(),
                    _buildProgressCard(),
                    _buildResultCard(),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                ),
                if (!_scanning) _buildOpenButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 260,
      collapsedHeight: 100,
      floating: false,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 100),
          child: Lottie.asset(
            'assets/animations/logo_animation.json',
            repeat: _scanning,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingScreen()),
          ),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildStatusLabel() {
    return SliverToBoxAdapter(
      child: Center(
        child: Text(
          _scanning ? tr('scan_scanning') : tr('scan_finished'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildUrlRow() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Clipboard.setData(ClipboardData(text: url)),
              child: const Icon(Icons.copy_rounded, color: AppColors.primaryColor, size: 18),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: GestureDetector(
                onTap: () => setState(() => _urlExpanded = !_urlExpanded),
                child: Text(
                  url,
                  overflow: _urlExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  maxLines: _urlExpanded ? null : 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: context.textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildProgressCard() {
    if (!_scanning) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.cardColor,
        ),
        child: Column(
          children: [
            _buildProgressRow(tr('scan_page'), _pageCheckDone),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildResultCard() {
    if (_scanning) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr('scan_result_title'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                _buildResultTag(),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                _detail.isNotEmpty ? _detail : _summary,
                style: TextStyle(color: context.textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildOpenButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.bgColor.withAlpha(0),
              context.bgColor,
              context.bgColor,
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        child: _safeState == 3
            ? _buildBlockedNotice()
            : customButton(
                onPressed: () {
                  setState(() => _didAutoOpen = true);
                  _openInBrowser(url);
                },
                text: tr('scan_btn_open'),
              ),
      ),
    );
  }

  Widget _buildBlockedNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tr('scan_blocked'),
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildProgressRow(String label, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: context.textColor),
            ),
          ),
          SizedBox(
            width: 24,
            height: 24,
            child: isDone
                ? const Icon(Icons.check_box,
                    color: AppColors.primaryColor, size: 24)
                : CircularProgressIndicator(
                    color: context.textSecondaryColor, strokeWidth: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTag() => switch (_safeState) {
    3 => redTag(text: tr('scan_tag_danger')),
    2 => yellowTag(text: tr('scan_tag_caution')),
    1 => greenTag(text: tr('scan_tag_safe')),
    _ => otherTag(text: tr('scan_tag_error')),
  };
}
