import 'package:flutter/material.dart';

class ChecklistNotePage extends StatefulWidget {
  final int? noteId;
  const ChecklistNotePage({super.key, this.noteId});

  @override
  State<ChecklistNotePage> createState() => _ChecklistNotePageState();
}

class _ChecklistNotePageState extends State<ChecklistNotePage> {
  final _controller = TextEditingController();
  final List<_Item> _items = [];

  @override
  Widget build(BuildContext context) {
    final done = _items.where((e) => e.checked).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Checklist Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: _items.isEmpty ? 0 : done / _items.length),
            const SizedBox(height: 8),
            Text('$done/${_items.length} completed'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Add checklist item'))),
                IconButton(
                  onPressed: () {
                    if (_controller.text.trim().isEmpty) return;
                    setState(() {
                      _items.add(_Item(_controller.text.trim()));
                      _controller.clear();
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: _items.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = _items.removeAt(oldIndex);
                    _items.insert(newIndex, item);
                  });
                },
                itemBuilder: (_, i) {
                  final item = _items[i];
                  return CheckboxListTile(
                    key: ValueKey('${item.text}-$i'),
                    value: item.checked,
                    title: Text(item.text),
                    onChanged: (v) => setState(() => item.checked = v ?? false),
                    secondary: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => setState(() => _items.removeAt(i)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item {
  String text;
  bool checked;
  _Item(this.text, {this.checked = false});
}
