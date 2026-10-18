import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../segments/keep_note_segment.dart';

class NoteStorageService {
  static const String _storageKey = 'user_custom_notes_v1';

  /// Loads only user-created notes from SharedPreferences.
  /// If the user hasn't added any notes yet, returns an empty list.
  static Future<List<NoteItem>> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload(); // Refresh memory cache from disk

      final String? notesJson = prefs.getString(_storageKey);
      if (notesJson == null || notesJson.trim().isEmpty) {
        return [];
      }

      final dynamic decoded = jsonDecode(notesJson);
      if (decoded is! List) {
        return [];
      }

      final List<NoteItem> notes = [];
      for (final item in decoded) {
        try {
          if (item is Map<String, dynamic>) {
            notes.add(NoteItem.fromJson(item));
          } else if (item is Map) {
            notes.add(NoteItem.fromJson(Map<String, dynamic>.from(item)));
          }
        } catch (itemErr) {
          debugPrint('[NoteStorageService] Error parsing note: $itemErr');
        }
      }

      return notes;
    } catch (e, stack) {
      debugPrint('[NoteStorageService] Error loading notes: $e\n$stack');
      return [];
    }
  }

  /// Persists user-created notes to SharedPreferences
  static Future<bool> saveNotes(List<NoteItem> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> rawList =
          notes.map((n) => n.toJson()).toList();
      final String encoded = jsonEncode(rawList);

      final bool success = await prefs.setString(_storageKey, encoded);
      return success;
    } catch (e, stack) {
      debugPrint('[NoteStorageService] Error saving notes: $e\n$stack');
      return false;
    }
  }
}
