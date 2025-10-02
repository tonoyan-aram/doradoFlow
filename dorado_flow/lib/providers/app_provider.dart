import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/location.dart';
import '../models/knowledge.dart';
import '../models/event.dart';
import '../models/note.dart';
import '../models/idea.dart';
import '../models/task.dart';
import '../services/app_data_service.dart';

class AppProvider extends ChangeNotifier {
  List<Project> _projects = [];
  List<Location> _locations = [];
  List<KnowledgeArticle> _knowledgeArticles = [];
  List<Event> _events = [];
  List<Note> _notes = [];
  List<Idea> _ideas = [];
  List<Task> _tasks = [];
  bool _isLoading = false;

  // Getters
  List<Project> get projects => _projects;
  List<Location> get locations => _locations;
  List<KnowledgeArticle> get knowledgeArticles => _knowledgeArticles;
  List<Event> get events => _events;
  List<Note> get notes => _notes;
  List<Idea> get ideas => _ideas;
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // Project statistics
  int get totalProjects => _projects.length;
  int get completedProjects => _projects.where((p) => p.status == ProjectStatus.completed).length;
  int get inProgressProjects => _projects.where((p) => p.status == ProjectStatus.inProgress).length;
  int get upcomingDeadlines {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    return _projects.where((p) => 
      p.deadline != null && 
      p.deadline!.isAfter(now) && 
      p.deadline!.isBefore(nextWeek) &&
      p.status != ProjectStatus.completed
    ).length;
  }

  List<Project> get recentProjects => _projects
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt))
    ..take(3)
    ..toList();

  List<Project> get projectsByStatus {
    final Map<ProjectStatus, List<Project>> grouped = {};
    for (final status in ProjectStatus.values) {
      grouped[status] = _projects.where((p) => p.status == status).toList();
    }
    return grouped.values.expand((x) => x).toList();
  }

  // Location statistics
  int get totalLocations => _locations.length;

  // Knowledge statistics
  int get totalKnowledgeArticles => _knowledgeArticles.length;
  int get favoriteArticles => _knowledgeArticles.where((a) => a.isFavorite).length;
  int get bookmarkedArticles => _knowledgeArticles.where((a) => a.isBookmarked).length;

  // Event statistics
  int get totalEvents => _events.length;
  List<Event> get upcomingEvents {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    return _events.where((e) => 
      e.startDate.isAfter(now) && 
      e.startDate.isBefore(nextWeek)
    ).toList();
  }

  // Initialize app data
  Future<void> initializeApp() async {
    _setLoading(true);
    try {
      await Future.wait([
        loadProjects(),
        loadLocations(),
        loadKnowledgeArticles(),
        loadEvents(),
        loadNotes(),
        loadIdeas(),
        loadTasks(),
      ]);
    } finally {
      _setLoading(false);
    }
  }

  // Project methods
  Future<void> loadProjects() async {
    _projects = await AppDataService.getProjects();
    notifyListeners();
  }

  Future<void> addProject(Project project) async {
    await AppDataService.addProject(project);
    _projects.add(project);
    notifyListeners();
  }

  Future<void> updateProject(Project project) async {
    await AppDataService.updateProject(project);
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      notifyListeners();
    }
  }

  Future<void> deleteProject(String projectId) async {
    await AppDataService.deleteProject(projectId);
    _projects.removeWhere((p) => p.id == projectId);
    notifyListeners();
  }

  Future<void> toggleChecklistItem(String projectId, String checklistItemId) async {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final updatedChecklist = project.checklist.map((item) {
      if (item.id == checklistItemId) {
        return item.copyWith(
          isCompleted: !item.isCompleted,
          completedAt: !item.isCompleted ? DateTime.now() : null,
        );
      }
      return item;
    }).toList();

    final updatedProject = project.copyWith(
      checklist: updatedChecklist,
      progress: _calculateProjectProgress(updatedChecklist),
    );

    await updateProject(updatedProject);
  }

  Future<void> addChecklistItem(String projectId, String title) async {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final newItem = ChecklistItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
    );

    final updatedChecklist = [...project.checklist, newItem];
    final updatedProject = project.copyWith(
      checklist: updatedChecklist,
      progress: _calculateProjectProgress(updatedChecklist),
    );

    await updateProject(updatedProject);
  }

  double _calculateProjectProgress(List<ChecklistItem> checklist) {
    if (checklist.isEmpty) return 0.0;
    final completedItems = checklist.where((item) => item.isCompleted).length;
    return completedItems / checklist.length;
  }

  // Location methods
  Future<void> loadLocations() async {
    _locations = await AppDataService.getLocations();
    notifyListeners();
  }

  Future<void> addLocation(Location location) async {
    await AppDataService.addLocation(location);
    _locations.add(location);
    notifyListeners();
  }

  // Knowledge methods
  Future<void> loadKnowledgeArticles() async {
    _knowledgeArticles = await AppDataService.getKnowledgeArticles();
    notifyListeners();
  }

  Future<void> addKnowledgeArticle(KnowledgeArticle article) async {
    await AppDataService.addKnowledgeArticle(article);
    _knowledgeArticles.add(article);
    notifyListeners();
  }

  Future<void> deleteKnowledgeArticle(String articleId) async {
    await AppDataService.deleteKnowledgeArticle(articleId);
    _knowledgeArticles.removeWhere((a) => a.id == articleId);
    notifyListeners();
  }

  // Load methods for new data types
  Future<void> loadEvents() async {
    _events = await AppDataService.getEvents();
    notifyListeners();
  }

  Future<void> loadNotes() async {
    _notes = await AppDataService.getNotes();
    notifyListeners();
  }

  Future<void> loadIdeas() async {
    _ideas = await AppDataService.getIdeas();
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _tasks = await AppDataService.getTasks();
    notifyListeners();
  }

  // Event methods
  Future<void> addEvent(Event event) async {
    await AppDataService.addEvent(event);
    _events.add(event);
    notifyListeners();
  }

  Future<void> deleteEvent(String eventId) async {
    await AppDataService.deleteEvent(eventId);
    _events.removeWhere((e) => e.id == eventId);
    notifyListeners();
  }

  // Note methods
  Future<void> addNote(Note note) async {
    await AppDataService.addNote(note);
    _notes.add(note);
    notifyListeners();
  }

  Future<void> deleteNote(String noteId) async {
    await AppDataService.deleteNote(noteId);
    _notes.removeWhere((n) => n.id == noteId);
    notifyListeners();
  }

  // Idea methods
  Future<void> addIdea(Idea idea) async {
    await AppDataService.addIdea(idea);
    _ideas.add(idea);
    notifyListeners();
  }

  Future<void> deleteIdea(String ideaId) async {
    await AppDataService.deleteIdea(ideaId);
    _ideas.removeWhere((i) => i.id == ideaId);
    notifyListeners();
  }

  Future<void> toggleIdeaFavorite(String ideaId) async {
    final index = _ideas.indexWhere((i) => i.id == ideaId);
    if (index != -1) {
      _ideas[index] = _ideas[index].copyWith(
        isFavorite: !_ideas[index].isFavorite,
      );
      await AppDataService.saveIdeas(_ideas);
      notifyListeners();
    }
  }

  // Task methods
  Future<void> addTask(Task task) async {
    await AppDataService.addTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    await AppDataService.deleteTask(taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        status: status,
        completedAt: status == TaskStatus.completed ? DateTime.now() : null,
      );
      await AppDataService.updateTask(_tasks[index]);
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String articleId) async {
    final index = _knowledgeArticles.indexWhere((a) => a.id == articleId);
    if (index != -1) {
      _knowledgeArticles[index] = _knowledgeArticles[index].copyWith(
        isFavorite: !_knowledgeArticles[index].isFavorite,
      );
      await AppDataService.saveKnowledgeArticles(_knowledgeArticles);
      notifyListeners();
    }
  }

  Future<void> toggleBookmark(String articleId) async {
    final index = _knowledgeArticles.indexWhere((a) => a.id == articleId);
    if (index != -1) {
      _knowledgeArticles[index] = _knowledgeArticles[index].copyWith(
        isBookmarked: !_knowledgeArticles[index].isBookmarked,
      );
      await AppDataService.saveKnowledgeArticles(_knowledgeArticles);
      notifyListeners();
    }
  }

  Future<void> markAsRead(String articleId) async {
    final index = _knowledgeArticles.indexWhere((a) => a.id == articleId);
    if (index != -1) {
      _knowledgeArticles[index] = _knowledgeArticles[index].copyWith(
        readCount: _knowledgeArticles[index].readCount + 1,
      );
      await AppDataService.saveKnowledgeArticles(_knowledgeArticles);
      notifyListeners();
    }
  }

  // Filter methods
  List<Project> getProjectsByType(ProjectType type) {
    return _projects.where((p) => p.type == type).toList();
  }

  List<Project> getProjectsByStatus(ProjectStatus status) {
    return _projects.where((p) => p.status == status).toList();
  }

  List<KnowledgeArticle> getKnowledgeByCategory(KnowledgeCategory category) {
    return _knowledgeArticles.where((a) => a.category == category).toList();
  }

  List<KnowledgeArticle> getFavoriteKnowledge() {
    return _knowledgeArticles.where((a) => a.isFavorite).toList();
  }

  List<KnowledgeArticle> getBookmarkedKnowledge() {
    return _knowledgeArticles.where((a) => a.isBookmarked).toList();
  }

  // Search methods
  List<Project> searchProjects(String query) {
    if (query.isEmpty) return _projects;
    final lowercaseQuery = query.toLowerCase();
    return _projects.where((p) => 
      p.title.toLowerCase().contains(lowercaseQuery) ||
      p.description.toLowerCase().contains(lowercaseQuery) ||
      p.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))
    ).toList();
  }

  List<Location> searchLocations(String query) {
    if (query.isEmpty) return _locations;
    final lowercaseQuery = query.toLowerCase();
    return _locations.where((l) => 
      l.name.toLowerCase().contains(lowercaseQuery) ||
      (l.address?.toLowerCase().contains(lowercaseQuery) ?? false) ||
      l.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))
    ).toList();
  }

  List<KnowledgeArticle> searchKnowledge(String query) {
    if (query.isEmpty) return _knowledgeArticles;
    final lowercaseQuery = query.toLowerCase();
    return _knowledgeArticles.where((a) => 
      a.title.toLowerCase().contains(lowercaseQuery) ||
      (a.summary?.toLowerCase().contains(lowercaseQuery) ?? false) ||
      a.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))
    ).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
