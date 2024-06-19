interface class IThumbnailEntity {
  late final String thumbnailId;
  late final String thumbnailUrl;
}

class ThumbnailEntity extends IThumbnailEntity {
  @override
  final String thumbnailId;
  @override
  final String thumbnailUrl;

  ThumbnailEntity({
    required this.thumbnailId,
    required this.thumbnailUrl,
  });

  factory ThumbnailEntity.fromJson(Map<String, dynamic> json) {
    return ThumbnailEntity(
      thumbnailId: json['thumbnailId'],
      thumbnailUrl: json['thumbnail'],
    );
  }
}
