import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../segments/expense_track_segment.dart';

class ExpenseStorageService {
  static const String _storageKey = 'user_custom_expenses_v1';

  /// Loads user transactions from SharedPreferences.
  /// If no transactions are saved yet, returns an empty list.
  static Future<List<ExpenseTransaction>> loadTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload(); // Refresh memory cache from disk

      final String? expensesJson = prefs.getString(_storageKey);
      if (expensesJson == null || expensesJson.trim().isEmpty) {
        return [];
      }

      final dynamic decoded = jsonDecode(expensesJson);
      if (decoded is! List) {
        return [];
      }

      final List<ExpenseTransaction> transactions = [];
      for (final item in decoded) {
        try {
          if (item is Map<String, dynamic>) {
            transactions.add(ExpenseTransaction.fromJson(item));
          } else if (item is Map) {
            transactions.add(
              ExpenseTransaction.fromJson(Map<String, dynamic>.from(item)),
            );
          }
        } catch (itemErr) {
          debugPrint('[ExpenseStorageService] Error parsing transaction: $itemErr');
        }
      }

      return transactions;
    } catch (e, stack) {
      debugPrint('[ExpenseStorageService] Error loading transactions: $e\n$stack');
      return [];
    }
  }

  /// Persists transactions to SharedPreferences
  static Future<bool> saveTransactions(
    List<ExpenseTransaction> transactions,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> rawList =
          transactions.map((t) => t.toJson()).toList();
      final String encoded = jsonEncode(rawList);

      final bool success = await prefs.setString(_storageKey, encoded);
      return success;
    } catch (e, stack) {
      debugPrint('[ExpenseStorageService] Error saving transactions: $e\n$stack');
      return false;
    }
  }
}
