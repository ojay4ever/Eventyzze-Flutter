import 'package:eventyzze/config/app_font.dart';
import 'package:eventyzze/config/app_images.dart';
import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/constants/enums.dart';
import 'package:eventyzze/customWidgets/app_loading_dialog.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/model/event_model.dart';
import 'package:eventyzze/repositories/eventRepository/event_repository.dart';
import 'package:eventyzze/utils/custom_snack_bar.dart';
import 'package:eventyzze/config/get_it.dart';
import 'package:flutter/material.dart';

class EventPaymentFormScreen extends StatefulWidget {
  final EventModel event;
  final VoidCallback onPaymentSuccess;

  const EventPaymentFormScreen({
    super.key,
    required this.event,
    required this.onPaymentSuccess,
  });

  @override
  State<EventPaymentFormScreen> createState() => _EventPaymentFormScreenState();
}

class _EventPaymentFormScreenState extends State<EventPaymentFormScreen> {
  final EventRepository _eventRepository = getIt<EventRepository>();
  String selectedPaymentMethod = 'My Wallet';
  
  final List<Map<String, String>> paymentMethods = [
    {'name': 'My Wallet', 'icon': 'wallet'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEventDetailsSection(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAmountSection(),
                          const SizedBox(height: 32),
                          _buildPaymentMethodSection(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetailsSection() {
    final imageUrl = widget.event.advertisementUrl != null &&
            widget.event.advertisementUrl!.trim().isNotEmpty
        ? widget.event.advertisementUrl!.trim()
        : (widget.event.organizerProfilePicture != null &&
                widget.event.organizerProfilePicture!.trim().isNotEmpty
            ? widget.event.organizerProfilePicture!.trim()
            : null);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, size: 24,color: Colors.black,),
                ),
                const Spacer(),
                const Text(
                  'Complete Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.inter,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[300],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppImages.confirmation,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      AppImages.confirmation,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.lato,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      widget.event.date,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: AppFonts.inter,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      widget.event.time,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: AppFonts.inter,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount to Pay',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.lato,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.kPrimaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.kPrimaryColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event Ticket',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontFamily: AppFonts.inter,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.event.price} Coins',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.kPrimaryColor,
                  fontFamily: AppFonts.inter,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Show Ticket',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: AppFonts.inter,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.lato,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...paymentMethods.map((method) {
          final isSelected = selectedPaymentMethod == method['name'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedPaymentMethod = method['name']!;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.kPrimaryColor.withValues(alpha: 0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.kPrimaryColor
                        : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        method['icon'] == 'wallet'
                            ? Icons.account_balance_wallet
                            : method['icon'] == 'bank'
                                ? Icons.account_balance
                                : Icons.credit_card,
                        color: AppTheme.kPrimaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        method['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontFamily: AppFonts.inter,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.kPrimaryColor,
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: CustomButton(
        text: 'Pay Now - ${widget.event.price} Coins',
        backgroundColor: AppTheme.kPrimaryColor,
        textColor: Colors.white,
        onTap: _handlePurchase,
      ),
    );
  }

  Future<void> _handlePurchase() async {
    AppLoadingDialog.show(message: 'Purchasing ticket...');
    try {
      final success = await _eventRepository.purchaseTicket(widget.event.id);
      AppLoadingDialog.hide();

      if (success) {
        CustomSnackBar.success(
          title: 'Success',
          message: 'Ticket purchased successfully!',
        );
        widget.onPaymentSuccess();
      } else {
        CustomSnackBar.error(
          title: 'Purchase Failed',
          message: 'Unable to purchase ticket. Please check your wallet balance.',
        );
      }
    } catch (e) {
      AppLoadingDialog.hide();
      CustomSnackBar.error(
        title: 'Error',
        message: e.toString(),
      );
    }
  }
}
