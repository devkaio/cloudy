// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RedactedConfiguration {
  bool autoFillTexts;
  String autoFillText;
  Color? redactedColor = Colors.grey.shade500;
  Duration animationDuration;

  RedactedConfiguration({
    this.autoFillText = "This is a place holder text to fill the space for redaction",
    this.autoFillTexts = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.redactedColor,
  });

  RedactedConfiguration copyWith({
    bool? autoFillTexts,
    String? autoFillText,
    Color? redactedColor,
    Duration? animationDuration,
  }) {
    return RedactedConfiguration(
      autoFillTexts: autoFillTexts ?? this.autoFillTexts,
      autoFillText: autoFillText ?? this.autoFillText,
      redactedColor: redactedColor ?? this.redactedColor,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}
