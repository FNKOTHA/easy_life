import 'package:flutter/material.dart';

class NoteItem {
  final String id;
  String title;
  String content;
  String category;
  DateTime date;
  Color tagColor;

  NoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    required this.tagColor,
  });
}

class KeepNoteSegment extends StatefulWidget {
  const KeepNoteSegment({super.key});

  @override
  State<KeepNoteSegment> createState() => _KeepNoteSegmentState();
}

class _KeepNoteSegmentState extends State<KeepNoteSegment> {
  final List<NoteItem> _notes = [
    NoteItem(
      id: '1',
      title: 'Exchange Rate Target 🎯',
      content:
          'Monitor USD to BDT. If rate crosses 122.50, initiate transfer for overseas investment.',
      category: 'Finance',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      tagColor: Colors.deepPurple,
    ),
    NoteItem(
      id: '2',
      title: 'Monthly Budget Limits 📋',
      content:
          'Groceries: \$450 max\nDining Out: \$150 max\nEmergency savings deposit: \$500',
      category: 'Budget',
      date: DateTime.now().subtract(const Duration(days: 1)),
      tagColor: Colors.teal,
    ),
    NoteItem(
      id: '3',
      title: 'Upcoming Travel Currency ✈️',
      content:
          'Withdraw 50,000 JPY at airport exchange counter or use zero-fee travel card.',
      category: 'Travel',
      date: DateTime.now().subtract(const Duration(days: 3)),
      tagColor: Colors.amber.shade800,
    ),
  ];

  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['All', 'Finance', 'Budget', 'Travel', 'Personal'];

  final List<Color> _availableColors = [
    Colors.deepPurple,
    Colors.teal,
    Colors.blueAccent,
    Colors.orange,
    Colors.pinkAccent,
  ];

  List<NoteItem> get _filteredNotes {
    return _notes.where((note) {
      final matchesCategory =
          _selectedCategory == 'All' || note.category == _selectedCategory;
      final query = _searchController.text.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showAddNoteDialog([NoteItem? existingNote]) {
    final titleController =
        TextEditingController(text: existingNote?.title ?? '');
    final contentController =
        TextEditingController(text: existingNote?.content ?? '');
    String selectedCat = existingNote?.category ?? 'Finance';
    Color selectedColor = existingNote?.tagColor ?? Colors.deepPurple;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          existingNote == null ? 'Create New Note' : 'Edit Note',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(modalContext),
                          icon: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Note Title',
                        hintText: 'e.g. Holiday Budget',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.title_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: contentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Description / Details',
                        hintText: 'Write down details, numbers or reminders...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _categories
                          .where((c) => c != 'All')
                          .map((category) {
                        final isSelected = selectedCat == category;
                        return ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          selectedColor: Colors.deepPurple.shade100,
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() => selectedCat = category);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tag Color',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: _availableColors.map((color) {
                        final isSelected = selectedColor == color;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() => selectedColor = color);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black87
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 18)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final title = titleController.text.trim();
                          final content = contentController.text.trim();
                          if (title.isEmpty && content.isEmpty) return;

                          setState(() {
                            if (existingNote == null) {
                              _notes.insert(
                                0,
                                NoteItem(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  title: title.isEmpty ? 'Untitled Note' : title,
                                  content: content,
                                  category: selectedCat,
                                  date: DateTime.now(),
                                  tagColor: selectedColor,
                                ),
                              );
                            } else {
                              existingNote.title =
                                  title.isEmpty ? 'Untitled Note' : title;
                              existingNote.content = content;
                              existingNote.category = selectedCat;
                              existingNote.tagColor = selectedColor;
                            }
                          });

                          Navigator.pop(modalContext);
                        },
                        child: Text(
                          existingNote == null ? 'Save Note' : 'Update Note',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((item) => item.id == id);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotes;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'keep_note_fab',
        onPressed: () => _showAddNoteDialog(),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Note'),
      ),
      body: Column(
        children: [
          // Search & Filter header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Category Chips
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.deepPurple,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: isSelected ? Colors.deepPurple : Colors.black12,
                      ),
                    ),
                    showCheckmark: false,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Notes List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No notes found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap the button below to add your first note',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 80),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final note = filtered[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _showAddNoteDialog(note),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: note.tagColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E2238),
                                        ),
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      onSelected: (val) {
                                        if (val == 'edit') {
                                          _showAddNoteDialog(note);
                                        } else if (val == 'delete') {
                                          _deleteNote(note.id);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, size: 16),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete,
                                                  size: 16, color: Colors.red),
                                              SizedBox(width: 8),
                                              Text('Delete',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (note.content.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    note.content,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: note.tagColor.withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        note.category,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: note.tagColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${note.date.day}/${note.date.month}/${note.date.year}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
