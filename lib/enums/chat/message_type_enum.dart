enum MessageTypeEnum {
  text,
  image,
  audio,
  video,
  prodOffer,
  document,
  announcement,
  storyReply,
}

class MessageTypeEnumConvertor {
  static String toJson(MessageTypeEnum type) {
    if (type == MessageTypeEnum.text) {
      return 'text';
    } else if (type == MessageTypeEnum.image) {
      return 'image';
    } else if (type == MessageTypeEnum.audio) {
      return 'audio';
    } else if (type == MessageTypeEnum.video) {
      return 'video';
    } else if (type == MessageTypeEnum.document) {
      return 'document';
    } else if (type == MessageTypeEnum.prodOffer) {
      return 'prod_offer';
    } else if (type == MessageTypeEnum.announcement) {
      return 'announcement';
    } else {
      return 'story_reply';
    }
  }

  static String enumToString(MessageTypeEnum type) {
    if (type == MessageTypeEnum.text) {
      return 'Text';
    } else if (type == MessageTypeEnum.image) {
      return 'Image';
    } else if (type == MessageTypeEnum.audio) {
      return 'Audio';
    } else if (type == MessageTypeEnum.video) {
      return 'Video';
    } else if (type == MessageTypeEnum.document) {
      return 'Document';
    } else if (type == MessageTypeEnum.prodOffer) {
      return 'Product Offer';
    } else if (type == MessageTypeEnum.announcement) {
      return 'Announcement';
    } else {
      return 'Story Reply';
    }
  }

  static MessageTypeEnum toEnum(String type) {
    if (type == 'text') {
      return MessageTypeEnum.text;
    } else if (type == 'image') {
      return MessageTypeEnum.image;
    } else if (type == 'audio') {
      return MessageTypeEnum.audio;
    } else if (type == 'video') {
      return MessageTypeEnum.video;
    } else if (type == 'document') {
      return MessageTypeEnum.document;
    } else if (type == 'announcement') {
      return MessageTypeEnum.announcement;
    } else if (type == 'prod_offer') {
      return MessageTypeEnum.prodOffer;
    } else {
      return MessageTypeEnum.storyReply;
    }
  }
}
