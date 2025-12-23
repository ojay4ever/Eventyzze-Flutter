import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/constants/enums.dart';
import 'package:eventyzze/customWidgets/app_loading_dialog.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/utils/custom_snack_bar.dart';
import 'package:eventyzze/views/eventScreens/create_event_controller.dart';
import 'package:eventyzze/views/homeScreens/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../helper/navigation_helper.dart';
import 'event_confirmation_screen.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final CreateEventController _controller = Get.put(CreateEventController());

  String _titleError = '';
  String _descriptionError = '';
  String _dateError = '';
  String _timeError = '';
  String _durationError = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _controller.dateController.text =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    _controller.selectedDate.value = now.toString().split(' ')[0];
    final currentTime = TimeOfDay.now();
    _controller.timeController.text = _formatTime(currentTime);
    _controller.selectedTime.value =
        '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '$hour:$minute $period';
  }

  void _validateFields() {
    setState(() {
      _titleError = '';
      _descriptionError = '';
      _dateError = '';
      _timeError = '';
      _durationError = '';

      if (_controller.titleController.text.trim().isEmpty) {
        _titleError = 'Event title is required';
      } else if (_controller.titleController.text.trim().length < 3) {
        _titleError = 'Title must be at least 3 characters';
      }

      if (_controller.descriptionController.text.trim().isEmpty) {
        _descriptionError = 'Event description is required';
      } else if (_controller.descriptionController.text.trim().length < 10) {
        _descriptionError = 'Description must be at least 10 characters';
      }

      if (_controller.dateController.text.trim().isEmpty ||
          _controller.selectedDate.value.isEmpty) {
        _dateError = 'Date is required';
      }

      if (_controller.timeController.text.trim().isEmpty ||
          _controller.selectedTime.value.isEmpty) {
        _timeError = 'Time is required';
      }

      if (_controller.durationController.text.trim().isEmpty ||
          _controller.selectedDuration.value.isEmpty) {
        _durationError = 'Duration is required';
      }
    });
  }
  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now();
    if (_controller.dateController.text.isNotEmpty) {
      try {
        final parts = _controller.dateController.text.split('-');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (e) {
        initialDate = DateTime.now();
      }
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.kPrimaryColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppTheme.kPrimaryColor,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                  ),
                  child: CalendarDatePicker(
                    initialDate: initialDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 2),
                    onDateChanged: (DateTime date) {
                      setState(() {
                        _controller.dateController.text =
                            "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
                        _controller.selectedDate.value = date.toString().split(
                          ' ',
                        )[0];
                        _dateError = '';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Confirm Date',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _selectTime() async {
    TimeOfDay initialTime = TimeOfDay.now();
    if (_controller.timeController.text.isNotEmpty) {
      try {
        final timeText = _controller.timeController.text.toLowerCase();
        final isAm = timeText.contains('am');
        final isPm = timeText.contains('pm');

        final parts = timeText.replaceAll(RegExp(r'[^\d:]'), '').split(':');
        if (parts.length == 2) {
          int hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          if (isPm && hour != 12) {
            hour += 12;
          } else if (isAm && hour == 12) {
            hour = 0;
          }

          initialTime = TimeOfDay(hour: hour, minute: minute);
        }
      } catch (e) {
        initialTime = TimeOfDay.now();
      }
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.kPrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
              surface: Colors.white,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteColor: AppTheme.kPrimaryColor.withValues(alpha: 0.1),
              hourMinuteTextColor: AppTheme.kPrimaryColor,
              dayPeriodColor: AppTheme.kPrimaryColor.withValues(alpha: 0.1),
              dayPeriodTextColor: AppTheme.kPrimaryColor,
              dialHandColor: AppTheme.kPrimaryColor,
              dialBackgroundColor: AppTheme.kPrimaryColor.withValues(alpha: 0.05),
              dialTextColor: Colors.black,
              entryModeIconColor: AppTheme.kPrimaryColor,
              dayPeriodTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              hourMinuteTextStyle: TextStyle(
                color: AppTheme.kPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _controller.timeController.text = _formatTime(picked);
        _controller.selectedTime.value =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        _timeError = '';
      });
    }
  }

  Future<void> _selectDuration() async {
    final List<Map<String, String>> durations = [
      {'value': '30mins', 'display': '30 minutes'},
      {'value': '1hr', 'display': '1 hour'},
      {'value': '1hr 30mins', 'display': '1 hour 30 minutes'},
      {'value': '2hr', 'display': '2 hours'},
      {'value': '3hr', 'display': '3 hours'},
      {'value': '4hr', 'display': '4 hours'},
      {'value': 'All day', 'display': 'All day'},
    ];

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 400,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Duration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.kPrimaryColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: durations.length,
                  itemBuilder: (context, index) {
                    final duration = durations[index];
                    return ListTile(
                      title: Text(
                        duration['display']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _controller.durationController.text =
                              duration['value']!;
                          _controller.selectedDuration.value =
                              duration['value']!;
                          _durationError = '';
                        });
                        Navigator.pop(context);
                      },
                      trailing:
                          _controller.durationController.text ==
                              duration['value']
                          ? Icon(Icons.check, color: AppTheme.kPrimaryColor)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAdFile() async {
    await _controller.pickAdFile();
  }

  Future<void> _createEvent() async {
    _validateFields();

    if (_titleError.isNotEmpty ||
        _descriptionError.isNotEmpty ||
        _dateError.isNotEmpty ||
        _timeError.isNotEmpty ||
        _durationError.isNotEmpty) {
      return;
    }

    AppLoadingDialog.show(message: 'Creating event...');
    try {
      final createdEvent = await _controller.createEvent();

      AppLoadingDialog.hide();

      // Small delay to ensure dialog is fully closed before navigation
      await Future.delayed(const Duration(milliseconds: 200));

      if (createdEvent != null && mounted) {
        CustomSnackBar.success(
          title: 'Success',
          message: 'Event created successfully!',
        );

        final homeController = Get.isRegistered<HomeController>()
            ? Get.find<HomeController>()
            : null;
        homeController?.fetchTrendingEvents();
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            NavigationHelper.goToNavigatorScreen(
              context,
              EventConfirmationScreen(event: createdEvent),
            );
          }
        });
      }
    } catch (e) {
      AppLoadingDialog.hide();
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        CustomSnackBar.error(
          title: 'Error',
          message: 'Failed to create event: ${e.toString()}',
        );
      }
    }
  }

  void _previewEvent() {
    _validateFields();

    if (_titleError.isNotEmpty ||
        _descriptionError.isNotEmpty ||
        _dateError.isNotEmpty ||
        _timeError.isNotEmpty ||
        _durationError.isNotEmpty) {
      return;
    }

    Get.snackbar(
      'Preview',
      'Preview functionality coming soon!',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
             SafeArea(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create Event',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      _buildSectionTitle('Event Title'),
                      const SizedBox(height: 8),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _controller.titleController,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'Event Title *',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      if (_titleError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 8),
                          child: Text(
                            _titleError,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Event Description'),
                      const SizedBox(height: 8),
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _controller.descriptionController,
                          maxLines: 6,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'Description *',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      if (_descriptionError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 8),
                          child: Text(
                            _descriptionError,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Date'),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: _selectDate,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Text(
                                              _controller
                                                      .dateController
                                                      .text
                                                      .isEmpty
                                                  ? 'Select Date *'
                                                  : _controller
                                                        .dateController
                                                        .text,
                                              style: TextStyle(
                                                color:
                                                    _controller
                                                        .dateController
                                                        .text
                                                        .isEmpty
                                                    ? Colors.grey[400]
                                                    : Colors.black87,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.grey[600],
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_dateError.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      left: 8,
                                    ),
                                    child: Text(
                                      _dateError,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Upload Ad.'),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: _pickAdFile,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Obx(
                                              () => Text(
                                                _controller
                                                            .selectedAdFile
                                                            .value !=
                                                        null
                                                    ? _controller
                                                          .selectedAdFile
                                                          .value!
                                                          .path
                                                          .split('/')
                                                          .last
                                                    : 'Select File (Optional)',
                                                style: TextStyle(
                                                  color:
                                                      _controller
                                                              .selectedAdFile
                                                              .value !=
                                                          null
                                                      ? Colors.black87
                                                      : Colors.grey[400],
                                                  fontSize: 15,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Duration'),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: _selectDuration,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Text(
                                              _controller
                                                      .durationController
                                                      .text
                                                      .isEmpty
                                                  ? 'Select Duration *'
                                                  : _controller
                                                        .durationController
                                                        .text,
                                              style: TextStyle(
                                                color:
                                                    _controller
                                                        .durationController
                                                        .text
                                                        .isEmpty
                                                    ? Colors.grey[400]
                                                    : Colors.black87,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.grey[600],
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_durationError.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      left: 8,
                                    ),
                                    child: Text(
                                      _durationError,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Time'),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: _selectTime,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Text(
                                              _controller
                                                      .timeController
                                                      .text
                                                      .isEmpty
                                                  ? 'Select Time *'
                                                  : _controller
                                                        .timeController
                                                        .text,
                                              style: TextStyle(
                                                color:
                                                    _controller
                                                        .timeController
                                                        .text
                                                        .isEmpty
                                                    ? Colors.grey[400]
                                                    : Colors.black87,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.grey[600],
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_timeError.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      left: 8,
                                    ),
                                    child: Text(
                                      _timeError,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Event Price (Min. 20 Coins)'),
                      const SizedBox(height: 8),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _controller.priceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'Enter Price *',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(Icons.monetization_on, color: AppTheme.kPrimaryColor, size: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomButton(text: 'Preview',
                      borderColor: AppTheme.kPrimaryColor,
                      onTap: _previewEvent,
                        backgroundColor: Colors.white,
                      ),
              
                          const SizedBox(height: 12),
                          CustomButton(text: 'Continue',
                          onTap: _createEvent,
                          ),
              
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
            ),

    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}
