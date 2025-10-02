import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/content_cards.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Events, Notes, Ideas, Tasks
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Events', icon: Icon(Icons.event_rounded)),
            Tab(text: 'Notes', icon: Icon(Icons.note_rounded)),
            Tab(text: 'Ideas', icon: Icon(Icons.lightbulb_rounded)),
            Tab(text: 'Tasks', icon: Icon(Icons.task_rounded)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          EventsListTab(),
          NotesListTab(),
          IdeasListTab(),
          TasksListTab(),
        ],
      ),
    );
  }
}

// EventsListTab
class EventsListTab extends StatelessWidget {
  const EventsListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        print('EventsListTab build: ${appProvider.events.length} events');
        return appProvider.events.isEmpty
            ? _buildEmptyState(Icons.event_available_rounded, 'No events yet', 'Create your first event to get started')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: appProvider.events.length,
                itemBuilder: (context, index) {
                  final event = appProvider.events[index];
                  print('Building event card: ${event.title}');
                  return ContentCards.buildEventCard(event, appProvider);
                },
              );
      },
    );
  }
}

// NotesListTab
class NotesListTab extends StatelessWidget {
  const NotesListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return appProvider.notes.isEmpty
            ? _buildEmptyState(Icons.note_rounded, 'No notes yet', 'Create your first note to get started')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: appProvider.notes.length,
                itemBuilder: (context, index) {
                  final note = appProvider.notes[index];
                  return ContentCards.buildNoteCard(note, appProvider);
                },
              );
      },
    );
  }
}

// IdeasListTab
class IdeasListTab extends StatelessWidget {
  const IdeasListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return appProvider.ideas.isEmpty
            ? _buildEmptyState(Icons.lightbulb_rounded, 'No ideas yet', 'Capture your creative ideas here')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: appProvider.ideas.length,
                itemBuilder: (context, index) {
                  final idea = appProvider.ideas[index];
                  return ContentCards.buildIdeaCard(idea, appProvider);
                },
              );
      },
    );
  }
}

// TasksListTab
class TasksListTab extends StatelessWidget {
  const TasksListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return appProvider.tasks.isEmpty
            ? _buildEmptyState(Icons.task_rounded, 'No tasks yet', 'Create your first task to get started')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: appProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = appProvider.tasks[index];
                  return ContentCards.buildTaskCard(task, appProvider);
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
        Icon(icon, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    ),
  );
}