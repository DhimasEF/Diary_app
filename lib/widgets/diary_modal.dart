import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class DiaryModal extends StatefulWidget {
  final DateTime date;
  final Map<String, dynamic>? diary;
  final VoidCallback onRefresh;

  DiaryModal({required this.date, this.diary, required this.onRefresh});

  @override
  State<DiaryModal> createState() => _DiaryModalState();
}

class _DiaryModalState extends State<DiaryModal> {
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.diary != null) {
      titleCtrl.text = widget.diary!['title'];
      contentCtrl.text = widget.diary!['content'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDiary = widget.diary != null;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMMM yyyy').format(widget.date),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 12),

              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentCtrl,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 4,
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (hasDiary)
                    TextButton(
                      onPressed: () async {
                        await ApiService.deleteDiary(int.parse(widget.diary!['id'].toString()));
                        widget.onRefresh();
                        Navigator.pop(context);
                      },
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),

                  ElevatedButton(
                    onPressed: () async {
                      if (titleCtrl.text.isEmpty || contentCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Title & content wajib diisi')),
                        );
                        return;
                      }

                      bool success;

                      if (hasDiary) {
                        success = await ApiService.updateDiary(
                          int.parse(widget.diary!['id'].toString()),
                          titleCtrl.text,
                          contentCtrl.text,
                        );
                      } else {
                        success = await ApiService.createDiary(
                          titleCtrl.text,
                          contentCtrl.text,
                          widget.date, // ⬅️ INI PENTING
                        );
                      }

                      if (success) {
                        widget.onRefresh(); // reload calendar
                        Navigator.pop(context);
                      }
                    },
                    child: Text(hasDiary ? 'Update' : 'Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}
