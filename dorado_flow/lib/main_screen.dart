import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/project.dart';
import 'models/location.dart';
import 'models/event.dart';
import 'models/note.dart';
import 'models/idea.dart';
import 'models/task.dart';
import 'models/knowledge.dart';
import 'providers/app_provider.dart';
import 'screens/create_event_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/content_screen.dart';
import 'screens/locations_screen.dart';
import 'screens/knowledge_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ProjectsScreen(),
    const ContentScreen(),
    const LocationsScreen(),
    const KnowledgeScreen(),
  ];

  void _onFabTap(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        _showQuickAddDialog(context);
        break;
      case 1:
        _showCreateProjectDialog(context);
        break;
      case 2:
        _showQuickAddDialog(context);
        break;
      case 3:
        _showCreateLocationDialog(context);
        break;
      case 4:
        _showCreateKnowledgeDialog(context);
        break;
    }
  }

  void _showQuickAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Add',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAddOption(
                    icon: Icons.event_rounded,
                    title: 'Event',
                    color: Colors.blue,
                    onTap: () => _createEvent(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickAddOption(
                    icon: Icons.note_add_rounded,
                    title: 'Note',
                    color: Colors.green,
                    onTap: () => _createNote(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAddOption(
                    icon: Icons.lightbulb_rounded,
                    title: 'Idea',
                    color: Colors.orange,
                    onTap: () => _createIdea(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickAddOption(
                    icon: Icons.task_rounded,
                    title: 'Task',
                    color: Colors.purple,
                    onTap: () => _createTask(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context) {
    _showCreateProjectQuickDialog(context);
  }

  void _showCreateLocationDialog(BuildContext context) {
    _showCreateLocationQuickDialog(context);
  }

  void _showSearchDialog(BuildContext context) {
    _showSearchQuickDialog(context);
  }

  void _createEvent(BuildContext context) async {
    // Get provider reference before any async operations
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    Navigator.pop(context); // Close Quick Add dialog
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateEventScreen()),
    );
    
    if (result != null && result is Event && mounted) {
      // Add event to provider
      await appProvider.addEvent(result);
      print('Event added to provider: ${result.title}');
      print('Total events now: ${appProvider.events.length}');
    }
  }

  void _createNote(BuildContext context) {
    Navigator.pop(context); // Close Quick Add dialog
    _showCreateNoteDialog(context);
  }

  void _createIdea(BuildContext context) {
    Navigator.pop(context); // Close Quick Add dialog
    _showCreateIdeaDialog(context);
  }

  void _createTask(BuildContext context) {
    Navigator.pop(context); // Close Quick Add dialog
    _showCreateTaskDialog(context);
  }

  void _showCreateNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Note Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Note Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                autofocus: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty &&
                  contentController.text.trim().isNotEmpty) {
                // Create new note
                final newNote = Note(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  createdAt: DateTime.now(),
                  tags: [],
                  isImportant: false,
                );

                // Add to provider
                Provider.of<AppProvider>(
                  context,
                  listen: false,
                ).addNote(newNote);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Note created: "${titleController.text.trim()}"',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCreateIdeaDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Idea'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Idea Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Idea Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                autofocus: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty &&
                  descriptionController.text.trim().isNotEmpty) {
                // Create new idea
                final newIdea = Idea(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  createdAt: DateTime.now(),
                  tags: [],
                  isFavorite: false,
                );

                // Add to provider
                Provider.of<AppProvider>(
                  context,
                  listen: false,
                ).addIdea(newIdea);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Idea saved: "${titleController.text.trim()}"',
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.medium;
    DateTime? selectedDueDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskPriority>(
                value: selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: TaskPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(_getTaskPriorityName(priority)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedPriority = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Due Date'),
                subtitle: Text(
                  selectedDueDate != null
                      ? _formatDate(selectedDueDate!)
                      : 'No due date',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    selectedDueDate = date;
                    (context as Element).markNeedsBuild();
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                // Create new task
                final newTask = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim().isNotEmpty
                      ? descriptionController.text.trim()
                      : null,
                  priority: selectedPriority,
                  status: TaskStatus.pending,
                  createdAt: DateTime.now(),
                  dueDate: selectedDueDate,
                  tags: [],
                );

                // Add to provider
                Provider.of<AppProvider>(
                  context,
                  listen: false,
                ).addTask(newTask);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Task created: "${titleController.text.trim()}"',
                    ),
                    backgroundColor: Colors.purple,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCreateProjectQuickDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    ProjectType selectedType = ProjectType.photography;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Project Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ProjectType>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Project Type',
                  border: OutlineInputBorder(),
                ),
                items: ProjectType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getProjectTypeName(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedType = value;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                // Create new project
                final newProject = Project(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim().isNotEmpty
                      ? descriptionController.text.trim()
                      : 'No description',
                  type: selectedType,
                  status: ProjectStatus.planning,
                  createdAt: DateTime.now(),
                  deadline: DateTime.now().add(const Duration(days: 30)),
                  progress: 0.0,
                  checklist: [
                    ChecklistItem(
                      id: '1',
                      title: 'Plan project details',
                      isCompleted: false,
                    ),
                  ],
                  tags: [],
                );

                // Add to provider
                Provider.of<AppProvider>(
                  context,
                  listen: false,
                ).addProject(newProject);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Project created: "${titleController.text.trim()}"',
                    ),
                    backgroundColor: _getProjectTypeColor(selectedType),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showCreateLocationQuickDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Location'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Location Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                // Create new location
                final newLocation = Location(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.trim(),
                  address: addressController.text.trim().isNotEmpty
                      ? addressController.text.trim()
                      : null,
                  description: descriptionController.text.trim().isNotEmpty
                      ? descriptionController.text.trim()
                      : null,
                  photos: [],
                  contacts: [],
                  tags: [],
                  createdAt: DateTime.now(),
                );

                // Add to provider
                Provider.of<AppProvider>(
                  context,
                  listen: false,
                ).addLocation(newLocation);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Location added: "${nameController.text.trim()}"',
                    ),
                    backgroundColor: Colors.blue,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showSearchQuickDialog(BuildContext context) {
    final searchController = TextEditingController();
    String selectedCategory = 'All';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search query',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: ['All', 'Projects', 'Locations', 'Knowledge'].map((
                category,
              ) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedCategory = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (searchController.text.trim().isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Searching for "${searchController.text.trim()}" in $selectedCategory',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  String _getProjectTypeName(ProjectType type) {
    switch (type) {
      case ProjectType.photography:
        return 'Photography';
      case ProjectType.videography:
        return 'Videography';
      case ProjectType.music:
        return 'Music';
      case ProjectType.art:
        return 'Art';
      case ProjectType.blogging:
        return 'Blogging';
      case ProjectType.other:
        return 'Other';
    }
  }

  Color _getProjectTypeColor(ProjectType type) {
    switch (type) {
      case ProjectType.photography:
        return Colors.blue;
      case ProjectType.videography:
        return Colors.purple;
      case ProjectType.music:
        return Colors.green;
      case ProjectType.art:
        return Colors.orange;
      case ProjectType.blogging:
        return Colors.teal;
      case ProjectType.other:
        return Colors.grey;
    }
  }

  String _getTaskPriorityName(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCreateKnowledgeDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final summaryController = TextEditingController();
    final authorController = TextEditingController();
    final sourceController = TextEditingController();
    final urlController = TextEditingController();
    final tagsController = TextEditingController();
    KnowledgeCategory selectedCategory = KnowledgeCategory.photography;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Knowledge Article'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Article Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<KnowledgeCategory>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: KnowledgeCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(_getKnowledgeCategoryName(category)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: summaryController,
                decoration: const InputDecoration(
                  labelText: 'Summary',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Author (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: sourceController,
                decoration: const InputDecoration(
                  labelText: 'Source (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty &&
                  contentController.text.trim().isNotEmpty) {
                // Parse tags
                final tags = tagsController.text
                    .split(',')
                    .map((tag) => tag.trim())
                    .where((tag) => tag.isNotEmpty)
                    .toList();

                // Create new knowledge article
                final newArticle = KnowledgeArticle(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  summary: summaryController.text.trim().isNotEmpty
                      ? summaryController.text.trim()
                      : null,
                  category: selectedCategory,
                  tags: tags,
                  author: authorController.text.trim().isNotEmpty
                      ? authorController.text.trim()
                      : null,
                  source: sourceController.text.trim().isNotEmpty
                      ? sourceController.text.trim()
                      : null,
                  url: urlController.text.trim().isNotEmpty
                      ? urlController.text.trim()
                      : null,
                  createdAt: DateTime.now(),
                  isFavorite: false,
                  isBookmarked: false,
                  readCount: 0,
                );

                // Add to provider
                Provider.of<AppProvider>(
                  context,
                  listen: false,
                ).addKnowledgeArticle(newArticle);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Article added: "${titleController.text.trim()}"',
                    ),
                    backgroundColor: Colors.purple,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _getKnowledgeCategoryName(KnowledgeCategory category) {
    switch (category) {
      case KnowledgeCategory.photography:
        return 'Photography';
      case KnowledgeCategory.videography:
        return 'Videography';
      case KnowledgeCategory.music:
        return 'Music';
      case KnowledgeCategory.art:
        return 'Art';
      case KnowledgeCategory.business:
        return 'Business';
      case KnowledgeCategory.marketing:
        return 'Marketing';
      case KnowledgeCategory.technical:
        return 'Technical';
      case KnowledgeCategory.inspiration:
        return 'Inspiration';
      case KnowledgeCategory.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_special_rounded),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy_rounded),
            label: 'Content',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_rounded),
            label: 'Locations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Knowledge',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFabTap(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

