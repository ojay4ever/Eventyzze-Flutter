// lib/model/report_model.dart
class ReportResponse {
  final bool success;
  final String message;
  final String? reportId;

  ReportResponse({
    required this.success,
    required this.message,
    this.reportId,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      reportId: json['reportId']?.toString(),
    );
  }
}