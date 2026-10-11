import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safelink_app/const/colors.dart';
import 'package:safelink_app/const/value_name.dart';
import 'package:safelink_app/services/local_data_manager.dart';
import 'package:safelink_app/services/localization_service.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  late final LocalDataManager _localDataManager;
  List<String> items = [];
  final Set<int> _expandedItems = {};

  @override
  void initState() {
    super.initState();
    _localDataManager = LocalDataManager();
    _loadUrlLog();
  }

  Future<void> _loadUrlLog() async {
    final history =
        await _localDataManager.getStringListData(ValueName.history);
    if (history != null && mounted) {
      setState(() => items = history);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(surfaceTintColor: context.surfaceColor),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child: Text(
                    tr('history_title'),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: context.textColor),
                  ),
                ),
                items.isNotEmpty
                    ? Expanded(
                        child: Stack(children: [
                          ListView.builder(
                            padding: const EdgeInsets.only(top: 12),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final isExpanded = _expandedItems.contains(index);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() {
                                          if (isExpanded) {
                                            _expandedItems.remove(index);
                                          } else {
                                            _expandedItems.add(index);
                                          }
                                        }),
                                        child: Text(
                                          items[index],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: context.textColor),
                                          maxLines: isExpanded ? null : 1,
                                          overflow: isExpanded
                                              ? TextOverflow.visible
                                              : TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.copy_rounded,
                                          color: AppColors.primaryColor,
                                          size: 18),
                                      onPressed: () => Clipboard.setData(
                                          ClipboardData(text: items[index])),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 24,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    context.bgColor,
                                    context.bgColor.withAlpha(0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/404_logo.svg',
                                height: 160),
                            const SizedBox(height: 40),
                            Text(
                              tr('history_empty'),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: context.textSecondaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
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