import 'package:flutter/material.dart';

Widget categoryCard(
  String title,
  String range,
  Color color, {
  bool isSelected = false,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 8),
    elevation: isSelected ? 3 : 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isSelected ? color : Colors.transparent,
        width: isSelected ? 2 : 1,
      ),
    ),
    color: isSelected ? color.withValues(alpha: 0.08) : null,
    child: ListTile(
      dense: true,
      leading: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          color: isSelected ? color : null,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          range,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: color,
          ),
        ),
      ),
    ),
  );
}