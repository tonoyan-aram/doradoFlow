import 'package:flutter/material.dart';

enum EventType {
  meeting,
  deadline,
  shoot,
  recording,
  exhibition,
  concert,
  other,
}

class Event {
  final String id;
  final String title;
  final String? description;
  final EventType type;
  final DateTime startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String? location;
  final List<String> tags;
  final bool isAllDay;
  final String? notes;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.location,
    required this.tags,
    required this.isAllDay,
    this.notes,
    required this.createdAt,
  });

  Event copyWith({
    String? id,
    String? title,
    String? description,
    EventType? type,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? location,
    List<String>? tags,
    bool? isAllDay,
    String? notes,
    DateTime? createdAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      isAllDay: isAllDay ?? this.isAllDay,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
