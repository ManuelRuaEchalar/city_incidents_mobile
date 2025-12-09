class StatusModel {
  final int statusId;
  final String name;
  final String description;
  final int incidentCount;

  StatusModel({
    required this.statusId,
    required this.name,
    required this.description,
    required this.incidentCount,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      statusId: json['status_id'],
      name: json['name'],
      description: json['description'],
      incidentCount: json['_count']['incidents'],
    );
  }
}
