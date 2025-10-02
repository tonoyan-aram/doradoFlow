import 'package:flutter/material.dart';

enum ProjectType {
  photography,
  videography,
  music,
  art,
  blogging,
  other,
}

enum ProjectStatus {
  planning,
  inProgress,
  completed,
  onHold,
}

class ChecklistItem {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? completedAt;

  ChecklistItem({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.completedAt,
  });

  ChecklistItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class Project {
  final String id;
  final String title;
  final String description;
  final ProjectType type;
  final ProjectStatus status;
  final DateTime createdAt;
  final DateTime? deadline;
  final double progress;
  final List<ChecklistItem> checklist;
  final List<String> tags;
  final String? locationId;
  final String? notes;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.createdAt,
    this.deadline,
    required this.progress,
    required this.checklist,
    required this.tags,
    this.locationId,
    this.notes,
  });

  Project copyWith({
    String? id,
    String? title,
    String? description,
    ProjectType? type,
    ProjectStatus? status,
    DateTime? createdAt,
    DateTime? deadline,
    double? progress,
    List<ChecklistItem>? checklist,
    List<String>? tags,
    String? locationId,
    String? notes,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      progress: progress ?? this.progress,
      checklist: checklist ?? this.checklist,
      tags: tags ?? this.tags,
      locationId: locationId ?? this.locationId,
      notes: notes ?? this.notes,
    );
  }

  double get completionPercentage {
    if (checklist.isEmpty) return progress;
    final completedItems = checklist.where((item) => item.isCompleted).length;
    return completedItems / checklist.length;
  }
}