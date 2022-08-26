class ProductURL {
  ProductURL({
    required this.url,
    required this.isVideo,
    required this.index,
  });

  final String url;
  final bool isVideo;
  final int index;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'is_video': isVideo,
      'index': index,
    };
  }

  // ignore: sort_constructors_first
  factory ProductURL.fromMap(Map<String, dynamic> map) {
    return ProductURL(
      url: map['url'] ?? '',
      isVideo: map['is_video'] ?? false,
      index: map['index']?.toInt() ?? 0,
    );
  }
}
