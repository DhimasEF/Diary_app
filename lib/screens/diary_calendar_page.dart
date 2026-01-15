import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/api_service.dart';
import '../widgets/diary_modal.dart';
import '../themes/vocaloid_theme.dart';
import 'package:intl/intl.dart';

class DiaryCalendarPage extends StatefulWidget {
  @override
  State<DiaryCalendarPage> createState() => _DiaryCalendarPageState();
}

class _DiaryCalendarPageState extends State<DiaryCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, dynamic> diaryByDate = {};
  double sheetSize = 0.18;

  @override
  void initState() {
    super.initState();
    loadDiaries();
  }

  void loadDiaries() async {
    final data = await ApiService.getDiaries();
    diaryByDate = {
      for (var d in data)
        d['diary_date']: d
    };
    setState(() {});
  }

  List<Map<String, dynamic>> getDiariesByMonth() {
    final year = _focusedDay.year;
    final month = _focusedDay.month;

    return diaryByDate.entries
        .where((entry) {
          final date = DateTime.parse(entry.key);
          return date.year == year && date.month == month;
        })
        .map((e) => e.value as Map<String, dynamic>)
        .toList()
      ..sort((a, b) =>
          b['diary_date'].compareTo(a['diary_date']));
  }

  @override
  Widget build(BuildContext context) {
    final month = _focusedDay.month;

    print('Focused month: $month');
    print('Theme bg: ${monthThemes[month]?.bg}');

    // 🎶 THEME PER BULAN + FALLBACK
    final theme = monthThemes[month] ??
        VocaloidTheme(
          bg: 'assets/themes/miku/nov_bg.jpg',
          sticker: 'assets/themes/miku/miku.png',
          accent: Colors.pinkAccent,
        );

    final accentColor = theme.accent;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(
                'assets/avatar/default.jpg', // ganti nanti
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Dhimas',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Diary Calendar',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // 🖼️ BACKGROUND
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(theme.bg),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            color: Colors.black.withOpacity(0.45), // 👈 ATUR OPACITY
          ),

          // 📅 CALENDAR
          Padding(
            padding: const EdgeInsets.all(8),
            child: TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),

              enabledDayPredicate: (day) {
                return !day.isAfter(
                  DateTime.now().subtract(const Duration(days: 1)),
                );
              },

              // ⭐ INI KUNCI UTAMA
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },

              selectedDayPredicate: (day) =>
                  isSameDay(day, _selectedDay),

              onDaySelected: (selected, focused) {
                final today = DateTime.now();

                if (selected.isAfter(
                  DateTime(today.year, today.month, today.day),
                )) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tidak bisa menulis diary untuk tanggal yang belum terjadi'),
                    ),
                  );
                  return;
                }

                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });

                final key = DateFormat('yyyy-MM-dd').format(selected);
                final diary = diaryByDate[key];

                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: "Diary",
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionDuration: Duration(milliseconds: 300),
                  pageBuilder: (context, anim1, anim2) {
                    return Center(
                      child: DiaryModal(
                        date: selected,
                        diary: diary,
                        onRefresh: loadDiaries,
                      ),
                    );
                  },
                  transitionBuilder: (context, anim1, anim2, child) {
                    return Transform.scale(
                      scale: Curves.easeOutBack.transform(anim1.value),
                      child: Opacity(
                        opacity: anim1.value,
                        child: child,
                      ),
                    );
                  },
                );
              },

              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                defaultTextStyle:
                    const TextStyle(color: Colors.white),
                weekendTextStyle:
                    const TextStyle(color: Colors.white70),
              ),

              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                leftChevronIcon:
                    const Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon:
                    const Icon(Icons.chevron_right, color: Colors.white),
              ),

              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  final key = DateFormat('yyyy-MM-dd').format(date);
                  final hasDiary = diaryByDate.containsKey(key);

                  return Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: hasDiary
                          ? accentColor.withOpacity(0.6)
                          : Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: hasDiary
                            ? accentColor
                            : Colors.white24,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: hasDiary
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },

                // ⭐ STICKER PENANDA DIARY
                markerBuilder: (context, date, _) {
                  final key = DateFormat('yyyy-MM-dd').format(date);
                  if (diaryByDate.containsKey(key)) {
                    return Positioned(
                      top: 2,
                      right: 2,
                      child: Image.asset(
                        theme.sticker,
                        width: 48,
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * sheetSize,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  sheetSize -= details.primaryDelta! / 600;
                  sheetSize = sheetSize.clamp(0.12, 0.75);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // handle
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    Text(
                      DateFormat('MMMM yyyy').format(_focusedDay),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: getDiariesByMonth().length,
                        itemBuilder: (context, i) {
                          final d = getDiariesByMonth()[i];
                          final date = DateTime.parse(d['diary_date']);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: theme.accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        d['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd MMM yyyy', 'en_US').format(date),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        d['content'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Image.asset(
                                      theme.sticker,
                                      width: 48,
                                    ),
                                  ],
                                ),
                              ],
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

        ],
      ),
    );
  }
}
