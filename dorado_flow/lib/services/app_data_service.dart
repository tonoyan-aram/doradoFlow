import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../models/location.dart';
import '../models/knowledge.dart';
import '../models/event.dart';
import '../models/note.dart';
import '../models/idea.dart';
import '../models/task.dart';

class AppDataService {
  static const String _projectsKey = 'projects';
  static const String _locationsKey = 'locations';
  static const String _knowledgeKey = 'knowledge';
  static const String _eventsKey = 'events';
  static const String _notesKey = 'notes';
  static const String _ideasKey = 'ideas';
  static const String _tasksKey = 'tasks';

  // Projects
  static Future<List<Project>> getProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = prefs.getString(_projectsKey);
      
      if (projectsJson == null) {
        // Return sample data if no data exists
        return _getSampleProjects();
      }
      
      final List<dynamic> projectsList = json.decode(projectsJson);
      return projectsList.map((json) => _projectFromJson(json)).toList();
    } catch (e) {
      print('Error loading projects: $e');
      return _getSampleProjects();
    }
  }

  static Future<void> saveProjects(List<Project> projects) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = json.encode(projects.map((p) => _projectToJson(p)).toList());
      await prefs.setString(_projectsKey, projectsJson);
    } catch (e) {
      print('Error saving projects: $e');
    }
  }

  static Future<void> addProject(Project project) async {
    final projects = await getProjects();
    projects.add(project);
    await saveProjects(projects);
  }

  static Future<void> updateProject(Project project) async {
    final projects = await getProjects();
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projects[index] = project;
      await saveProjects(projects);
    }
  }

  static Future<void> deleteProject(String projectId) async {
    final projects = await getProjects();
    projects.removeWhere((p) => p.id == projectId);
    await saveProjects(projects);
  }

  // Locations
  static Future<List<Location>> getLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = prefs.getString(_locationsKey);
      
      if (locationsJson == null) {
        return _getSampleLocations();
      }
      
      final List<dynamic> locationsList = json.decode(locationsJson);
      return locationsList.map((json) => _locationFromJson(json)).toList();
    } catch (e) {
      print('Error loading locations: $e');
      return _getSampleLocations();
    }
  }

  static Future<void> saveLocations(List<Location> locations) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = json.encode(locations.map((l) => _locationToJson(l)).toList());
      await prefs.setString(_locationsKey, locationsJson);
    } catch (e) {
      print('Error saving locations: $e');
    }
  }

  static Future<void> addLocation(Location location) async {
    final locations = await getLocations();
    locations.add(location);
    await saveLocations(locations);
  }

  // Knowledge
  static Future<List<KnowledgeArticle>> getKnowledgeArticles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final knowledgeJson = prefs.getString(_knowledgeKey);
      
      if (knowledgeJson == null) {
        return _getSampleKnowledge();
      }
      
      final List<dynamic> knowledgeList = json.decode(knowledgeJson);
      return knowledgeList.map((json) => _knowledgeFromJson(json)).toList();
    } catch (e) {
      print('Error loading knowledge: $e');
      return _getSampleKnowledge();
    }
  }

  static Future<void> saveKnowledgeArticles(List<KnowledgeArticle> articles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final knowledgeJson = json.encode(articles.map((a) => _knowledgeToJson(a)).toList());
      await prefs.setString(_knowledgeKey, knowledgeJson);
    } catch (e) {
      print('Error saving knowledge: $e');
    }
  }

  static Future<void> addKnowledgeArticle(KnowledgeArticle article) async {
    final articles = await getKnowledgeArticles();
    articles.add(article);
    await saveKnowledgeArticles(articles);
  }

  static Future<void> deleteKnowledgeArticle(String articleId) async {
    final articles = await getKnowledgeArticles();
    articles.removeWhere((a) => a.id == articleId);
    await saveKnowledgeArticles(articles);
  }

  // Events
  static Future<List<Event>> getEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = prefs.getString(_eventsKey);
      
      if (eventsJson == null) {
        return [];
      }
      
      final List<dynamic> eventsList = json.decode(eventsJson);
      return eventsList.map((json) => _eventFromJson(json)).toList();
    } catch (e) {
      print('Error loading events: $e');
      return [];
    }
  }

  static Future<void> saveEvents(List<Event> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = json.encode(events.map((e) => _eventToJson(e)).toList());
      await prefs.setString(_eventsKey, eventsJson);
    } catch (e) {
      print('Error saving events: $e');
    }
  }

  static Future<void> addEvent(Event event) async {
    final events = await getEvents();
    events.add(event);
    await saveEvents(events);
  }

  static Future<void> deleteEvent(String eventId) async {
    final events = await getEvents();
    events.removeWhere((e) => e.id == eventId);
    await saveEvents(events);
  }

  // Notes
  static Future<List<Note>> getNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = prefs.getString(_notesKey);
      
      if (notesJson == null) {
        return [];
      }
      
      final List<dynamic> notesList = json.decode(notesJson);
      return notesList.map((json) => _noteFromJson(json)).toList();
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  static Future<void> saveNotes(List<Note> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = json.encode(notes.map((n) => _noteToJson(n)).toList());
      await prefs.setString(_notesKey, notesJson);
    } catch (e) {
      print('Error saving notes: $e');
    }
  }

  static Future<void> addNote(Note note) async {
    final notes = await getNotes();
    notes.add(note);
    await saveNotes(notes);
  }

  static Future<void> deleteNote(String noteId) async {
    final notes = await getNotes();
    notes.removeWhere((n) => n.id == noteId);
    await saveNotes(notes);
  }

  // Ideas
  static Future<List<Idea>> getIdeas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ideasJson = prefs.getString(_ideasKey);
      
      if (ideasJson == null) {
        return [];
      }
      
      final List<dynamic> ideasList = json.decode(ideasJson);
      return ideasList.map((json) => _ideaFromJson(json)).toList();
    } catch (e) {
      print('Error loading ideas: $e');
      return [];
    }
  }

  static Future<void> saveIdeas(List<Idea> ideas) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ideasJson = json.encode(ideas.map((i) => _ideaToJson(i)).toList());
      await prefs.setString(_ideasKey, ideasJson);
    } catch (e) {
      print('Error saving ideas: $e');
    }
  }

  static Future<void> addIdea(Idea idea) async {
    final ideas = await getIdeas();
    ideas.add(idea);
    await saveIdeas(ideas);
  }

  static Future<void> deleteIdea(String ideaId) async {
    final ideas = await getIdeas();
    ideas.removeWhere((i) => i.id == ideaId);
    await saveIdeas(ideas);
  }

  // Tasks
  static Future<List<Task>> getTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);
      
      if (tasksJson == null) {
        return [];
      }
      
      final List<dynamic> tasksList = json.decode(tasksJson);
      return tasksList.map((json) => _taskFromJson(json)).toList();
    } catch (e) {
      print('Error loading tasks: $e');
      return [];
    }
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = json.encode(tasks.map((t) => _taskToJson(t)).toList());
      await prefs.setString(_tasksKey, tasksJson);
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  static Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  static Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == taskId);
    await saveTasks(tasks);
  }

  static Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }

  // Sample data
  static List<Project> _getSampleProjects() {
    return [
      Project(
        id: '1',
        title: 'Wedding Photography',
        description: 'Beautiful wedding photography session',
        type: ProjectType.photography,
        status: ProjectStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        deadline: DateTime.now().add(const Duration(days: 10)),
        progress: 0.75,
        checklist: [
          ChecklistItem(id: '1', title: 'Prepare camera equipment', isCompleted: true),
          ChecklistItem(id: '2', title: 'Charge batteries', isCompleted: true),
          ChecklistItem(id: '3', title: 'Check lenses', isCompleted: false),
          ChecklistItem(id: '4', title: 'Prepare props', isCompleted: false),
        ],
        tags: ['wedding', 'photography', 'portrait'],
      ),
      Project(
        id: '2',
        title: 'Music Video',
        description: 'Creative music video production',
        type: ProjectType.videography,
        status: ProjectStatus.planning,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        deadline: DateTime.now().add(const Duration(days: 20)),
        progress: 0.25,
        checklist: [
          ChecklistItem(id: '1', title: 'Write script', isCompleted: true),
          ChecklistItem(id: '2', title: 'Find location', isCompleted: false),
          ChecklistItem(id: '3', title: 'Prepare equipment', isCompleted: false),
        ],
        tags: ['music', 'video', 'creative'],
      ),
      Project(
        id: '3',
        title: 'Art Exhibition',
        description: 'Contemporary art exhibition',
        type: ProjectType.art,
        status: ProjectStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        deadline: DateTime.now().subtract(const Duration(days: 5)),
        progress: 1.0,
        checklist: [
          ChecklistItem(id: '1', title: 'Create artworks', isCompleted: true),
          ChecklistItem(id: '2', title: 'Find gallery', isCompleted: true),
          ChecklistItem(id: '3', title: 'Setup exhibition', isCompleted: true),
        ],
        tags: ['art', 'exhibition', 'contemporary'],
      ),
    ];
  }

  static List<Location> _getSampleLocations() {
    return [
      Location(
        id: '1',
        name: 'Central Park Studio',
        address: '123 Creative Street, New York',
        description: 'Beautiful studio with natural light',
        photos: [],
        contacts: [],
        tags: ['studio', 'photography'],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Location(
        id: '2',
        name: 'Beach Location',
        address: 'Sunset Beach, California',
        description: 'Perfect for outdoor shoots',
        photos: [],
        contacts: [],
        tags: ['outdoor', 'beach', 'natural'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  static List<KnowledgeArticle> _getSampleKnowledge() {
    return [
      KnowledgeArticle(
        id: '1',
        title: 'Photography Composition Tips',
        content: 'Learn the rule of thirds, leading lines, and other composition techniques...',
        summary: 'Essential composition techniques for better photography',
        category: KnowledgeCategory.photography,
        tags: ['photography', 'composition', 'tips'],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        isFavorite: true,
        isBookmarked: false,
        readCount: 15,
      ),
      KnowledgeArticle(
        id: '2',
        title: 'Video Editing Workflow',
        content: 'Step-by-step guide to efficient video editing workflow...',
        summary: 'Professional video editing workflow tips',
        category: KnowledgeCategory.videography,
        tags: ['video', 'editing', 'workflow'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isFavorite: false,
        isBookmarked: true,
        readCount: 8,
      ),
    ];
  }

  // JSON conversion methods
  static Map<String, dynamic> _projectToJson(Project project) {
    return {
      'id': project.id,
      'title': project.title,
      'description': project.description,
      'type': project.type.index,
      'status': project.status.index,
      'createdAt': project.createdAt.toIso8601String(),
      'deadline': project.deadline?.toIso8601String(),
      'progress': project.progress,
      'checklist': project.checklist.map((c) => {
        'id': c.id,
        'title': c.title,
        'isCompleted': c.isCompleted,
        'completedAt': c.completedAt?.toIso8601String(),
      }).toList(),
      'tags': project.tags,
      'locationId': project.locationId,
      'notes': project.notes,
    };
  }

  static Project _projectFromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ProjectType.values[json['type']],
      status: ProjectStatus.values[json['status']],
      createdAt: DateTime.parse(json['createdAt']),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      progress: json['progress'].toDouble(),
      checklist: (json['checklist'] as List).map((c) => ChecklistItem(
        id: c['id'],
        title: c['title'],
        isCompleted: c['isCompleted'],
        completedAt: c['completedAt'] != null ? DateTime.parse(c['completedAt']) : null,
      )).toList(),
      tags: List<String>.from(json['tags']),
      locationId: json['locationId'],
      notes: json['notes'],
    );
  }

  static Map<String, dynamic> _locationToJson(Location location) {
    return {
      'id': location.id,
      'name': location.name,
      'address': location.address,
      'description': location.description,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'photos': location.photos,
      'contacts': location.contacts.map((c) => {
        'id': c.id,
        'name': c.name,
        'phone': c.phone,
        'email': c.email,
        'role': c.role,
        'notes': c.notes,
      }).toList(),
      'tags': location.tags,
      'createdAt': location.createdAt.toIso8601String(),
      'notes': location.notes,
    };
  }

  static Location _locationFromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      photos: List<String>.from(json['photos']),
      contacts: (json['contacts'] as List).map((c) => Contact(
        id: c['id'],
        name: c['name'],
        phone: c['phone'],
        email: c['email'],
        role: c['role'],
        notes: c['notes'],
      )).toList(),
      tags: List<String>.from(json['tags']),
      createdAt: DateTime.parse(json['createdAt']),
      notes: json['notes'],
    );
  }

  static Map<String, dynamic> _knowledgeToJson(KnowledgeArticle article) {
    return {
      'id': article.id,
      'title': article.title,
      'content': article.content,
      'summary': article.summary,
      'category': article.category.index,
      'tags': article.tags,
      'author': article.author,
      'source': article.source,
      'url': article.url,
      'createdAt': article.createdAt.toIso8601String(),
      'updatedAt': article.updatedAt?.toIso8601String(),
      'isFavorite': article.isFavorite,
      'isBookmarked': article.isBookmarked,
      'readCount': article.readCount,
    };
  }

  static KnowledgeArticle _knowledgeFromJson(Map<String, dynamic> json) {
    return KnowledgeArticle(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      summary: json['summary'],
      category: KnowledgeCategory.values[json['category']],
      tags: List<String>.from(json['tags']),
      author: json['author'],
      source: json['source'],
      url: json['url'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isFavorite: json['isFavorite'],
      isBookmarked: json['isBookmarked'],
      readCount: json['readCount'],
    );
  }

  // Event JSON conversion
  static Map<String, dynamic> _eventToJson(Event event) {
    return {
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'type': event.type.index,
      'startDate': event.startDate.toIso8601String(),
      'endDate': event.endDate?.toIso8601String(),
      'startTime': event.startTime != null ? '${event.startTime!.hour}:${event.startTime!.minute}' : null,
      'endTime': event.endTime != null ? '${event.endTime!.hour}:${event.endTime!.minute}' : null,
      'isAllDay': event.isAllDay,
      'location': event.location,
      'tags': event.tags,
      'createdAt': event.createdAt.toIso8601String(),
    };
  }

  static Event _eventFromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTime(String? timeStr) {
      if (timeStr == null) return null;
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: EventType.values[json['type']],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      startTime: parseTime(json['startTime']),
      endTime: parseTime(json['endTime']),
      isAllDay: json['isAllDay'] ?? false,
      location: json['location'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  // Note JSON conversion
  static Map<String, dynamic> _noteToJson(Note note) {
    return {
      'id': note.id,
      'title': note.title,
      'content': note.content,
      'createdAt': note.createdAt.toIso8601String(),
      'updatedAt': note.updatedAt?.toIso8601String(),
      'tags': note.tags,
      'isImportant': note.isImportant,
    };
  }

  static Note _noteFromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      tags: List<String>.from(json['tags'] ?? []),
      isImportant: json['isImportant'] ?? false,
    );
  }

  // Idea JSON conversion
  static Map<String, dynamic> _ideaToJson(Idea idea) {
    return {
      'id': idea.id,
      'title': idea.title,
      'description': idea.description,
      'createdAt': idea.createdAt.toIso8601String(),
      'updatedAt': idea.updatedAt?.toIso8601String(),
      'tags': idea.tags,
      'isFavorite': idea.isFavorite,
      'category': idea.category,
    };
  }

  static Idea _ideaFromJson(Map<String, dynamic> json) {
    return Idea(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      tags: List<String>.from(json['tags'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
      category: json['category'],
    );
  }

  // Task JSON conversion
  static Map<String, dynamic> _taskToJson(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'priority': task.priority.index,
      'status': task.status.index,
      'createdAt': task.createdAt.toIso8601String(),
      'dueDate': task.dueDate?.toIso8601String(),
      'completedAt': task.completedAt?.toIso8601String(),
      'tags': task.tags,
      'projectId': task.projectId,
    };
  }

  static Task _taskFromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: TaskPriority.values[json['priority']],
      status: TaskStatus.values[json['status']],
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      tags: List<String>.from(json['tags'] ?? []),
      projectId: json['projectId'],
    );
  }
}
