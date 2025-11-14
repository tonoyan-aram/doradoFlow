import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/content_cards.dart';
import '../models/event.dart';
import '../models/note.dart';
import '../models/idea.dart';
import '../models/task.dart';

const _tabAccent = Color(0xFFFFE066);

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortOption = 'newest';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Content'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: _tabAccent,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Events', icon: Icon(Icons.casino_rounded)),
            Tab(text: 'Notes', icon: Icon(Icons.auto_stories_rounded)),
            Tab(text: 'Ideas', icon: Icon(Icons.lightbulb_rounded)),
            Tab(text: 'Tasks', icon: Icon(Icons.auto_fix_high_rounded)),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            onSelected: (value) {
              setState(() {
                _sortOption = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'newest', child: Text('Newest First')),
              const PopupMenuItem(value: 'oldest', child: Text('Oldest First')),
              const PopupMenuItem(value: 'alphabetical', child: Text('Alphabetical')),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          EventsListTab(sortOption: _sortOption),
          NotesListTab(sortOption: _sortOption),
          IdeasListTab(sortOption: _sortOption),
          TasksListTab(sortOption: _sortOption),
        ],
      ),
    );
  }
}

// EventsListTab
class EventsListTab extends StatelessWidget {
  final String sortOption;
  const EventsListTab({super.key, required this.sortOption});

  List<T> _sortItems<T>(List<T> items, String sortOption) {
    final sorted = List<T>.from(items);
    switch (sortOption) {
      case 'oldest':
        sorted.sort((a, b) => (a as dynamic).createdAt.compareTo((b as dynamic).createdAt));
        break;
      case 'alphabetical':
        sorted.sort((a, b) => (a as dynamic).title.compareTo((b as dynamic).title));
        break;
      case 'newest':
      default:
        sorted.sort((a, b) => (b as dynamic).createdAt.compareTo((a as dynamic).createdAt));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final searchQuery = appProvider.searchQuery.toLowerCase();
        var events = appProvider.events;
        
        if (searchQuery.isNotEmpty) {
          events = events.where((e) => 
            e.title.toLowerCase().contains(searchQuery) ||
            (e.description?.toLowerCase().contains(searchQuery) ?? false)
          ).toList();
        }
        
        events = _sortItems<Event>(events, sortOption);
        
        return events.isEmpty
            ? _buildEmptyState(Icons.event_available_rounded, 'No events yet', 'Create your first event to get started')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return ContentCards.buildEventCard(context, event, appProvider);
                },
              );
      },
    );
  }
}

// NotesListTab
class NotesListTab extends StatelessWidget {
  final String sortOption;
  const NotesListTab({super.key, required this.sortOption});

  List<T> _sortItems<T>(List<T> items, String sortOption) {
    final sorted = List<T>.from(items);
    switch (sortOption) {
      case 'oldest':
        sorted.sort((a, b) => (a as dynamic).createdAt.compareTo((b as dynamic).createdAt));
        break;
      case 'alphabetical':
        sorted.sort((a, b) => (a as dynamic).title.compareTo((b as dynamic).title));
        break;
      case 'newest':
      default:
        sorted.sort((a, b) => (b as dynamic).createdAt.compareTo((a as dynamic).createdAt));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final searchQuery = appProvider.searchQuery.toLowerCase();
        var notes = appProvider.notes;
        
        if (searchQuery.isNotEmpty) {
          notes = notes.where((n) => 
            n.title.toLowerCase().contains(searchQuery) ||
            n.content.toLowerCase().contains(searchQuery)
          ).toList();
        }
        
        notes = _sortItems<Note>(notes, sortOption);
        
        return notes.isEmpty
            ? _buildEmptyState(Icons.note_rounded, 'No notes yet', 'Create your first note to get started')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ContentCards.buildNoteCard(context, note, appProvider);
                },
              );
      },
    );
  }
}

// IdeasListTab
class IdeasListTab extends StatelessWidget {
  final String sortOption;
  const IdeasListTab({super.key, required this.sortOption});

  List<T> _sortItems<T>(List<T> items, String sortOption) {
    final sorted = List<T>.from(items);
    switch (sortOption) {
      case 'oldest':
        sorted.sort((a, b) => (a as dynamic).createdAt.compareTo((b as dynamic).createdAt));
        break;
      case 'alphabetical':
        sorted.sort((a, b) => (a as dynamic).title.compareTo((b as dynamic).title));
        break;
      case 'newest':
      default:
        sorted.sort((a, b) => (b as dynamic).createdAt.compareTo((a as dynamic).createdAt));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final searchQuery = appProvider.searchQuery.toLowerCase();
        var ideas = appProvider.ideas;
        
        if (searchQuery.isNotEmpty) {
          ideas = ideas.where((i) => 
            i.title.toLowerCase().contains(searchQuery) ||
            i.description.toLowerCase().contains(searchQuery)
          ).toList();
        }
        
        ideas = _sortItems<Idea>(ideas, sortOption);
        
        return ideas.isEmpty
            ? _buildEmptyState(Icons.lightbulb_rounded, 'No ideas yet', 'Capture your creative ideas here')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: ideas.length,
                itemBuilder: (context, index) {
                  final idea = ideas[index];
                  return ContentCards.buildIdeaCard(context, idea, appProvider);
                },
              );
      },
    );
  }
}

// TasksListTab
class TasksListTab extends StatelessWidget {
  final String sortOption;
  const TasksListTab({super.key, required this.sortOption});

  List<T> _sortItems<T>(List<T> items, String sortOption) {
    final sorted = List<T>.from(items);
    switch (sortOption) {
      case 'oldest':
        sorted.sort((a, b) => (a as dynamic).createdAt.compareTo((b as dynamic).createdAt));
        break;
      case 'alphabetical':
        sorted.sort((a, b) => (a as dynamic).title.compareTo((b as dynamic).title));
        break;
      case 'newest':
      default:
        sorted.sort((a, b) => (b as dynamic).createdAt.compareTo((a as dynamic).createdAt));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final searchQuery = appProvider.searchQuery.toLowerCase();
        var tasks = appProvider.tasks;
        
        if (searchQuery.isNotEmpty) {
          tasks = tasks.where((t) => 
            t.title.toLowerCase().contains(searchQuery) ||
            (t.description?.toLowerCase().contains(searchQuery) ?? false)
          ).toList();
        }
        
        tasks = _sortItems<Task>(tasks, sortOption);
        
        return tasks.isEmpty
            ? _buildEmptyState(Icons.task_rounded, 'No tasks yet', 'Create your first task to get started')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ContentCards.buildTaskCard(context, task, appProvider);
                },
              );
      },
    );
  }
}

// Helper for empty state
Widget _buildEmptyState(IconData icon, String title, String subtitle) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: Colors.white54),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    ),
  );
}