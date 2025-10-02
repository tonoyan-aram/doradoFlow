import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/app_provider.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  ProjectType? _selectedType;
  ProjectStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        List<Project> filteredProjects = appProvider.projects;

        if (_selectedType != null) {
          filteredProjects = filteredProjects
              .where((p) => p.type == _selectedType)
              .toList();
        }

        if (_selectedStatus != null) {
          filteredProjects = filteredProjects
              .where((p) => p.status == _selectedStatus)
              .toList();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Projects'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Column(
            children: [
              _buildFilterChips(),
              Expanded(
                child: filteredProjects.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredProjects.length,
                        itemBuilder: (context, index) {
                          final project = filteredProjects[index];
                          return _buildProjectCard(project, appProvider);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All Types', null, _selectedType == null),
          const SizedBox(width: 8),
          ...ProjectType.values.map(
            (type) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                _getTypeName(type),
                type,
                _selectedType == type,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ProjectType? type, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = selected ? type : null;
        });
      },
      selectedColor: Colors.blue.withOpacity(0.2),
      checkmarkColor: Colors.blue,
    );
  }

  String _getTypeName(ProjectType type) {
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No projects found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first project to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Project project, AppProvider appProvider) {
    final progress = project.completionPercentage;
    final color = _getProjectTypeColor(project.type);

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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getProjectTypeIcon(project.type),
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      project.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    // TODO: Navigate to edit screen
                  } else if (value == 'delete') {
                    _showDeleteDialog(context, project, appProvider);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}% complete',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(project.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(project.status),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStatusColor(project.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (project.deadline != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Deadline: ${_formatDate(project.deadline!)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ],
      ),
    );
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

  IconData _getProjectTypeIcon(ProjectType type) {
    switch (type) {
      case ProjectType.photography:
        return Icons.camera_alt_rounded;
      case ProjectType.videography:
        return Icons.videocam_rounded;
      case ProjectType.music:
        return Icons.music_note_rounded;
      case ProjectType.art:
        return Icons.palette_rounded;
      case ProjectType.blogging:
        return Icons.article_rounded;
      case ProjectType.other:
        return Icons.folder_rounded;
    }
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.planning:
        return Colors.orange;
      case ProjectStatus.inProgress:
        return Colors.blue;
      case ProjectStatus.completed:
        return Colors.green;
      case ProjectStatus.onHold:
        return Colors.red;
    }
  }

  String _getStatusText(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.planning:
        return 'Planning';
      case ProjectStatus.inProgress:
        return 'In Progress';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.onHold:
        return 'On Hold';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteDialog(
    BuildContext context,
    Project project,
    AppProvider appProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text('Are you sure you want to delete "${project.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appProvider.deleteProject(project.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Project deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}


