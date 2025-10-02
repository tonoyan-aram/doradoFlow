import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/app_provider.dart';

class CreateEventScreen extends StatefulWidget {
  final EventType? preselectedType;
  
  const CreateEventScreen({super.key, this.preselectedType});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();

  EventType _selectedType = EventType.other;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isAllDay = false;
  bool _hasEndDate = false;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    if (widget.preselectedType != null) {
      _selectedType = widget.preselectedType!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveEvent,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildEventTypeSection(),
            const SizedBox(height: 24),
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildDateTimeSection(),
            const SizedBox(height: 24),
            _buildLocationSection(),
            const SizedBox(height: 24),
            _buildTagsSection(),
            const SizedBox(height: 24),
            _buildNotesSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTypeSection() {
    return Container(
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
          const Text(
            'Event Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: EventType.values.map((type) {
              final isSelected = _selectedType == type;
              return GestureDetector(
                onTap: () => setState(() => _selectedType = type),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? _getEventTypeColor(type).withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected 
                          ? _getEventTypeColor(type)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getEventTypeIcon(type),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getEventTypeName(type),
                        style: TextStyle(
                          color: isSelected 
                              ? _getEventTypeColor(type)
                              : Colors.grey[600],
                          fontWeight: isSelected 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
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
          const Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Event Title *',
              hintText: 'Enter event title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter event title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter event description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Container(
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
          const Text(
            'Date & Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('All Day Event'),
            value: _isAllDay,
            onChanged: (value) => setState(() => _isAllDay = value),
            activeColor: _getEventTypeColor(_selectedType),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.calendar_today, color: _getEventTypeColor(_selectedType)),
            title: const Text('Start Date'),
            subtitle: Text(_formatDate(_selectedDate)),
            onTap: _selectStartDate,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
          ),
          if (!_isAllDay) ...[
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.access_time, color: _getEventTypeColor(_selectedType)),
              title: const Text('Start Time'),
              subtitle: Text(_formatTime(_selectedTime)),
              onTap: _selectStartTime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Has End Date/Time'),
            value: _hasEndDate,
            onChanged: (value) => setState(() {
              _hasEndDate = value;
              if (value) {
                _endDate = _selectedDate;
                _endTime = _selectedTime;
              } else {
                _endDate = null;
                _endTime = null;
              }
            }),
            activeColor: _getEventTypeColor(_selectedType),
          ),
          if (_hasEndDate) ...[
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.calendar_today, color: _getEventTypeColor(_selectedType)),
              title: const Text('End Date'),
              subtitle: Text(_endDate != null ? _formatDate(_endDate!) : 'Select end date'),
              onTap: _selectEndDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
            ),
            if (!_isAllDay) ...[
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.access_time, color: _getEventTypeColor(_selectedType)),
                title: const Text('End Time'),
                subtitle: Text(_endTime != null ? _formatTime(_endTime!) : 'Select end time'),
                onTap: _selectEndTime,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
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
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              hintText: 'Enter event location',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return Container(
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
          const Text(
            'Tags',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tagsController,
            decoration: const InputDecoration(
              labelText: 'Tags',
              hintText: 'Enter tags separated by commas',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.tag),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Example: photography, portrait, studio',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
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
          const Text(
            'Notes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Additional Notes',
              hintText: 'Enter any additional notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _saveEvent,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getEventTypeColor(_selectedType),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Create Event',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _selectedDate,
      firstDate: _selectedDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      setState(() => _endDate = date);
    }
  }

  Future<void> _selectEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _endTime ?? _selectedTime,
    );
    if (time != null) {
      setState(() => _endTime = time);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Color _getEventTypeColor(EventType type) {
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
        return Colors.pink;
      case EventType.other:
        return Colors.grey;
    }
  }

  String _getEventTypeIcon(EventType type) {
    switch (type) {
      case EventType.meeting:
        return '🤝';
      case EventType.deadline:
        return '⏰';
      case EventType.shoot:
        return '📸';
      case EventType.recording:
        return '🎵';
      case EventType.exhibition:
        return '🎨';
      case EventType.concert:
        return '🎤';
      case EventType.other:
        return '📅';
    }
  }

  String _getEventTypeName(EventType type) {
    switch (type) {
      case EventType.meeting:
        return 'Meeting';
      case EventType.deadline:
        return 'Deadline';
      case EventType.shoot:
        return 'Shoot';
      case EventType.recording:
        return 'Recording';
      case EventType.exhibition:
        return 'Exhibition';
      case EventType.concert:
        return 'Concert';
      case EventType.other:
        return 'Other';
    }
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      // Parse tags
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      // Create event
      final event = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty 
            ? _descriptionController.text.trim() 
            : null,
        type: _selectedType,
        startDate: _selectedDate,
        endDate: _hasEndDate ? _endDate : null,
        startTime: _isAllDay ? null : _selectedTime,
        endTime: (_isAllDay || !_hasEndDate) ? null : _endTime,
        location: _locationController.text.trim().isNotEmpty 
            ? _locationController.text.trim() 
            : null,
        tags: tags,
        isAllDay: _isAllDay,
        notes: _notesController.text.trim().isNotEmpty 
            ? _notesController.text.trim() 
            : null,
        createdAt: DateTime.now(),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event "${event.title}" created successfully!'),
          backgroundColor: _getEventTypeColor(_selectedType),
        ),
      );

      // Navigate back
      Navigator.pop(context, event);
    }
  }
}
