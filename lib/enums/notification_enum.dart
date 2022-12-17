enum NotificationType {
  message('message'),
  order('order'),
  offer('offer');

  const NotificationType(this.json);
  final String json;
}

class NotificationTypeConvertor {
  static NotificationType toEnum(String type) {
    switch (type) {
      case 'message':
        return NotificationType.message;
      case 'order':
        return NotificationType.order;
      case 'offer':
        return NotificationType.offer;
      default:
        return NotificationType.message;
    }
  }
}
