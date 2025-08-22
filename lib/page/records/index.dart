import 'dart:collection';
import 'package:calorie/common/icon/index.dart';
import 'package:calorie/common/util/constants.dart';
import 'package:calorie/main.dart';
import 'package:calorie/network/api.dart';
import 'package:calorie/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> with SingleTickerProviderStateMixin,RouteAware{
  List<dynamic> allRecords = [];
  bool isLoading = false;
  bool isLastPage = false;
  int page = 1;
  final int pageSize = 8;
  final ScrollController _scrollController = ScrollController();

  final Map<String, List<dynamic>> groupedRecords = LinkedHashMap();
  final Map<String, bool> sectionExpanded = {
    'TODAY': true,
    'LAST_7_DAYS': true,
    'THIS_MONTH': true,
    'EARLIER': true,
  };

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(_onScroll);
  }
  

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !isLoading &&
        !isLastPage) {
      page++;
      fetchData();
    }
  }

    @override
  void didPopNext() {
    // 从页面B返回后触发
    fetchData(isRefresh: true); // 重新拉取数据
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 注册路由观察者
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  Future<void> fetchData({bool isRefresh = false}) async {
    if (isLoading) return;
    isLoading = true;

    if (isRefresh) {
      page = 1;
      allRecords.clear();
      groupedRecords.clear();
      isLastPage = false;
    }

    final res = await detectionList(page, pageSize);
    int totalPage = res['totalPages'];
    int currentPage = res['number'];
    final List<dynamic> fetched = res['content'];

    if (totalPage <= currentPage) isLastPage = true;

    allRecords.addAll(fetched);
    groupRecords();

    isLoading = false;
    if (mounted) setState(() {});
  }

  void groupRecords() {
    groupedRecords.clear();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d7 = today.subtract(const Duration(days: 7));

    for (var item in allRecords) {
      final createDate = DateTime.parse(item['createDate']);
      final diffDays = now.difference(createDate).inDays;
      String key;
      if (createDate.isAfter(today)) {
        key = 'TODAY';
      } else if (createDate.isAfter(d7)) {
        key = 'LAST_7_DAYS';
      } else if (createDate.year == now.year && createDate.month == now.month) {
        key = 'THIS_MONTH';
      } else {
        key = 'EARLIER';
      }
      groupedRecords.putIfAbsent(key, () => []).add(item);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);

    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MEAL_RECORDS'.tr),
        leading: const BackButton(),
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchData(isRefresh: true),
        child: ListView(
          controller: _scrollController,
          children: [
            for (String key in ['TODAY', 'LAST_7_DAYS', 'THIS_MONTH', 'EARLIER'])
              if (groupedRecords[key]?.isNotEmpty ?? false)
                buildSection(key, groupedRecords[key]!),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (isLastPage && allRecords.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text("No more records")),
              ),
            if (allRecords.isEmpty && !isLoading)
              _buildEmpty(),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String key, List<dynamic> items) {
    final title = key.tr;
    final expanded = sectionExpanded[key] ?? true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: Icon(expanded ? Icons.expand_less : Icons.expand_more),
          onTap: () => setState(() {
            sectionExpanded[key] = !expanded;
          }),
        ),
        if (expanded)
          ...items.map((item) => buildRecordCard(item)).toList(),
      ],
    );
  }

  Widget buildRecordCard(dynamic item) {
    final meal = mealInfoMap[item['mealType']];
    final total = item['detectionResultData']['total'] ?? {};
    final dishName = total['dishName'].isEmpty ? 'UNKNOWN_FOOD'.tr:total['dishName'];
    final calories = total['calories'] ?? 0;
    final fat = total['fat'] ?? 0;
    final protein = total['protein'] ?? 0;
    final carbs = total['carbs'] ?? 0;

    return GestureDetector(
      onTap: () {
        Controller.c.foodDetail(item);
        Navigator.pushNamed(context, '/foodDetail');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 237, 242, 255),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              clipBehavior: Clip.hardEdge,
              child: Image.network(item['sourceImg'], fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SizedBox(
                        width: 140,
                        child: Text(dishName,overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      Row(children: [
                        const Icon(AliIcon.calorie, size: 18, color: Colors.orange),
                        Text("$calories ${'KCAL'.tr}", style: const TextStyle(fontWeight: FontWeight.w600)),
                      ]),
                    ]),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: meal?['color'] ?? Colors.blueAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(meal?['label'] ?? 'DINNER'.tr, style: const TextStyle(fontSize: 10, color: Colors.white,fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(AliIcon.fat, size: 16, color: Colors.amber),
                        Text(" $protein${'G'.tr}", style: const TextStyle(fontSize: 11)),
                        const SizedBox(width: 10),
                        const Icon(AliIcon.dinner4, size: 16, color: Colors.lightBlue),
                        Text(" $carbs${'G'.tr}", style: const TextStyle(fontSize: 11)),
                        const SizedBox(width: 10),
                        const Icon(AliIcon.meat2, size: 16, color: Colors.redAccent),
                        Text(" $fat${'G'.tr}", style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AliIcon.empty1, size: 60, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text('NO_RECORDS'.tr, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
