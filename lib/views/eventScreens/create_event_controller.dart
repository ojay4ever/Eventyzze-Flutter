import 'dart:io';
import 'dart:math';
import 'package:eventyzze/cache/shared_preferences_helper.dart';
import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/config/get_it.dart';
import 'package:eventyzze/model/event_model.dart';
import 'package:eventyzze/repositories/eventRepository/event_repository.dart';
import 'package:eventyzze/utils/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/src/form_data.dart' as dio;
import 'package:dio/src/multipart_file.dart' as dio_file;

class CreateEventController extends GetxController {
  final EventRepository _eventRepository = getIt<EventRepository>();
  final SharedPrefsHelper _sharedPrefsHelper = getIt<SharedPrefsHelper>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  final RxBool isLoading = false.obs;
  final Rx<File?> selectedAdFile = Rx<File?>(null);
  final RxString selectedDate = ''.obs;
  final RxString selectedTime = ''.obs;
  final RxString selectedDuration = ''.obs;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    durationController.dispose();
    super.onClose();
  }

  String generateRandomChannelName() {
    const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        16,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  Future<void> pickAdFile() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (file != null) {
        selectedAdFile.value = File(file.path);
      }
    } catch (e) {
      CustomSnackBar.error(
        title: 'Error',
        message: 'Failed to pick file: ${e.toString()}',
      );
    }
  }

  Future<void> selectDate(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Date',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CalendarDatePicker(
                  initialDate: selectedDate.value.isNotEmpty
                      ? DateTime.parse(selectedDate.value)
                      : DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (DateTime picked) {
                    selectedDate.value = picked.toString().split(' ')[0];
                    dateController.text = _formatDate(picked);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value.isNotEmpty
          ? _parseTime(selectedTime.value)
          : TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.kPrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedTime.value =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      timeController.text = _formatTime(picked);
    }
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // If parsing fails, return current time
    }
    return TimeOfDay.now();
  }

  Future<void> selectDuration(BuildContext context) async {
    final List<String> durations = [
      '30 mins',
      '1hr',
      '1hr 30mins',
      '2hrs',
      '2hrs 30mins',
      '3hrs',
      '4hrs',
      '5hrs',
    ];

    final String? selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Duration'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: durations.map((duration) {
                return ListTile(
                  title: Text(duration),
                  onTap: () => Navigator.of(context).pop(duration),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      selectedDuration.value = selected;
      durationController.text = selected;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'pm' : 'am';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  Future<EventModel?> createEvent() async {
    // Validation
    if (titleController.text.trim().isEmpty) {
      CustomSnackBar.error(
        title: 'Validation Error',
        message: 'Please enter event title.',
      );
      return null;
    }

    if (descriptionController.text.trim().isEmpty) {
      CustomSnackBar.error(
        title: 'Validation Error',
        message: 'Please enter event description.',
      );
      return null;
    }

    if (selectedDate.value.isEmpty) {
      CustomSnackBar.error(
        title: 'Validation Error',
        message: 'Please select event date.',
      );
      return null;
    }

    if (selectedTime.value.isEmpty) {
      CustomSnackBar.error(
        title: 'Validation Error',
        message: 'Please select event time.',
      );
      return null;
    }

    if (selectedDuration.value.isEmpty) {
      CustomSnackBar.error(
        title: 'Validation Error',
        message: 'Please select event duration.',
      );
      return null;
    }

    try {
      isLoading.value = true;

      final dbId = await _sharedPrefsHelper.getDatabaseId();
      if (dbId.isEmpty) {
        CustomSnackBar.error(
          title: 'Error',
          message: 'User ID not found. Please login again.',
        );
        isLoading.value = false;
        return null;
      }

      // Generate random channel name
      final channelName = generateRandomChannelName();

      // Create FormData
      final formData = dio.FormData.fromMap({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'date': selectedDate.value,
        'time': selectedTime.value,
        'duration': selectedDuration.value,
        'organizerId': dbId,
        'channelName': channelName,
      });

      // Add advertisement file if selected
      if (selectedAdFile.value != null) {
        final file = selectedAdFile.value!;
        final fileName = file.path.split('/').last;
        formData.files.add(
          MapEntry(
            'advertisement',
            await dio_file.MultipartFile.fromFile(
              file.path,
              filename: fileName,
            ),
          ),
        );
      }

      final createdEvent = await _eventRepository.createEvent(formData);

      if (createdEvent != null) {
        // Return the created event - screen will handle success message and navigation
        return createdEvent;
      } else {
        CustomSnackBar.error(
          title: 'Error',
          message: 'Failed to create event. Please try again.',
        );
        return null;
      }
    } catch (e) {
      CustomSnackBar.error(
        title: 'Error',
        message: 'Failed to create event: ${e.toString()}',
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
