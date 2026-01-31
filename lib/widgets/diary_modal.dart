import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class DiaryModal extends StatefulWidget {
  final DateTime date;
  final Map<String, dynamic>? diary;

  const DiaryModal({super.key, required this.date, this.diary});

  @override
  State<DiaryModal> createState() => _DiaryModalState();
}

class _DiaryModalState extends State<DiaryModal> {
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.diary != null) {
      titleCtrl.text = widget.diary!['title'];
      contentCtrl.text = widget.diary!['content'];
    }
  }

  Future<void> _submit() async {
    if (titleCtrl.text.isEmpty || contentCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title & content wajib diisi')),
      );
      return;
    }

    setState(() => isLoading = true);

    bool success;
    if (widget.diary != null) {
      success = await ApiService.updateDiary(
        int.parse(widget.diary!['id'].toString()),
        titleCtrl.text,
        contentCtrl.text,
      );
    } else {
      success = await ApiService.createDiary(
        titleCtrl.text,
        contentCtrl.text,
        widget.date,
      );
    }

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _delete() async {
    setState(() => isLoading = true);
    await ApiService.deleteDiary(
      int.parse(widget.diary!['id'].toString()),
    );
    setState(() => isLoading = false);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final hasDiary = widget.diary != null;

    return GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Material(
      color: Colors.black38, // lebih soft
      child: Center(
        child: GestureDetector(
          onTap: () {}, // ⛔ cegah klik ke modal ikut nutup
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        const Icon(Icons.book_rounded, size: 28),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('dd MMMM yyyy').format(widget.date),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              hasDiary ? 'Edit diary' : 'New diary',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// TITLE
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        hintText: 'Diary title',
                        prefixIcon: const Icon(Icons.title),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// CONTENT
                    TextField(
                      controller: contentCtrl,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Write your story...',
                        prefixIcon: const Icon(Icons.edit_note),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ACTION BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (hasDiary)
                          TextButton.icon(
                            onPressed: isLoading ? null : _delete,
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: isLoading ? null : _submit,
                          icon: const Icon(Icons.check),
                          label: Text(hasDiary ? 'Update' : 'Save'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// LOADING OVERLAY
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
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
