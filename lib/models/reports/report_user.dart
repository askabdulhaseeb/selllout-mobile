class ReportUser {
  ReportUser({
    required this.reportBy,
    required this.category,
    required this.comment,
    required this.timestamp,
  });

  final String reportBy;
  final String category;
  final String comment;
  final int timestamp;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'report_by': reportBy,
      'category': category,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  // ignore: sort_constructors_first
  factory ReportUser.fromMap(Map<String, dynamic> map) {
    return ReportUser(
      reportBy: map['report_by'] ?? '',
      category: map['category'] ?? '',
      comment: map['comment'] ?? '',
      timestamp: map['timestamp']?.toInt() ?? 0,
    );
  }
}
