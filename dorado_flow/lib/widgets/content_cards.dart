import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../models/note.dart';
import '../models/idea.dart';
import '../models/task.dart';
import '../providers/app_provider.dart';

class ContentCards {
  static Widget buildEventCard(Event event, AppProvider appProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getEventTypeColor(event.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getEventTypeIcon(event.type),
                  color: _getEventTypeColor(event.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (event.description != null && event.description!.isNotEmpty)
                      Text(
                        event.description!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => appProvider.deleteEvent(event.id),
                icon: const Icon(Icons.delete_rounded, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatEventDate(event),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (event.location != null && event.location!.isNotEmpty) ...[
                const SizedBox(width: 16),
                Icon(Icons.location_on_rounded, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          if (event.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: event.tags.map((tag) => _buildTag(tag)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  static Widget buildNoteCard(Note note, AppProvider appProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: note.isImportant 
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  note.isImportant ? Icons.priority_high_rounded : Icons.note_rounded,
                  color: note.isImportant ? Colors.orange : Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      note.content,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => appProvider.deleteNote(note.id),
                icon: const Icon(Icons.delete_rounded, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatDate(note.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (note.isImportant) ...[
                const SizedBox(width: 16),
                Icon(Icons.priority_high_rounded, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  'Important',
                  style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
          if (note.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: note.tags.map((tag) => _buildTag(tag)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  static Widget buildIdeaCard(Idea idea, AppProvider appProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      idea.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      idea.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => appProvider.toggleIdeaFavorite(idea.id),
                    icon: Icon(
                      idea.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: idea.isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () => appProvider.deleteIdea(idea.id),
                    icon: const Icon(Icons.delete_rounded, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatDate(idea.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          if (idea.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: idea.tags.map((tag) => _buildTag(tag)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  static Widget buildTaskCard(Task task, AppProvider appProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getTaskPriorityColor(task.priority).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTaskPriorityIcon(task.priority),
                  color: _getTaskPriorityColor(task.priority),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (task.description != null && task.description!.isNotEmpty)
                      Text(
                        task.description!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: task.status == TaskStatus.completed,
                    onChanged: (value) {
                      appProvider.updateTaskStatus(
                        task.id,
                        value == true ? TaskStatus.completed : TaskStatus.pending,
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () => appProvider.deleteTask(task.id),
                    icon: const Icon(Icons.delete_rounded, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatDate(task.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTaskStatusColor(task.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getTaskStatusName(task.status),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getTaskStatusColor(task.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (task.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: task.tags.map((tag) => _buildTag(tag)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  static Color _getEventTypeColor(EventType type) {
    switch (type) {
      case EventType.meeting:
        return Colors.blue;
      case EventType.deadline:
        return Colors.red;
      case EventType.shoot:
        return Colors.purple;
      case EventType.recording:
        return Colors.green;
      case EventType.exhibition:
        return Colors.orange;
      case EventType.concert:
        return Colors.teal;
      case EventType.other:
        return Colors.grey;
    }
  }

  static IconData _getEventTypeIcon(EventType type) {
    switch (type) {
      case EventType.meeting:
        return Icons.people_rounded;
      case EventType.deadline:
        return Icons.schedule_rounded;
      case EventType.shoot:
        return Icons.camera_alt_rounded;
      case EventType.recording:
        return Icons.mic_rounded;
      case EventType.exhibition:
        return Icons.museum_rounded;
      case EventType.concert:
        return Icons.music_note_rounded;
      case EventType.other:
        return Icons.event_rounded;
    }
  }

  static Color _getTaskPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  static IconData _getTaskPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.keyboard_arrow_down_rounded;
      case TaskPriority.medium:
        return Icons.remove_rounded;
      case TaskPriority.high:
        return Icons.keyboard_arrow_up_rounded;
    }
  }

  static Color _getTaskStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  static String _getTaskStatusName(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  static String _formatEventDate(Event event) {
    final date = event.startDate;
    final time = event.startTime;
    
    String dateStr = '${date.day}/${date.month}/${date.year}';
    if (time != null) {
      dateStr += ' ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return dateStr;
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}


