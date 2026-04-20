import 'package:flutter/material.dart';
import 'package:noteflow/features/notes/domain/entities/note_entity.dart';

class NoteCard extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback? onTap;

  const NoteCard({super.key, required this.note, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: Color(note.color),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    note.title.trim().isEmpty ? 'Untitled note' : note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (note.isPinned) const Icon(Icons.push_pin_rounded, size: 18),
              ]),
              const SizedBox(height: 8),
              Text(note.content, maxLines: 4, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
