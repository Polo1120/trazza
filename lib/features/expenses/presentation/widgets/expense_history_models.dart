import 'package:flutter/material.dart';

class ExpenseItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final String paymentMethod;
  final int amountCents;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final bool hasOcrReceipt;

  const ExpenseItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.paymentMethod,
    required this.amountCents,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.hasOcrReceipt = false,
  });
}

class ExpenseGroup {
  final String dateLabel;
  final String formattedTotal;
  final bool isToday;
  final List<ExpenseItem> items;

  const ExpenseGroup({
    required this.dateLabel,
    required this.formattedTotal,
    this.isToday = false,
    required this.items,
  });
}
