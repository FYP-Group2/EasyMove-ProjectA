class NotificationID {
  late int id;

  NotificationID({required this.id});

  NotificationID.fromJson(Map<String, dynamic> json) {
    id = json['noteId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['noteId'] = id;
    return data;
  }
}