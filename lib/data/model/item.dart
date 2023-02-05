import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable(createToJson: false)
class Item {
  @JsonKey(name: 'item_id')
  String itemId;
  @JsonKey(name: 'resolved_id')
  String resolvedId;
  @JsonKey(name: 'given_url')
  String givenUrl;
  @JsonKey(name: 'given_title')
  String? givenTitle;
  String favorite;
  String status;
  @JsonKey(name: 'time_added')
  String timeAdded;
  @JsonKey(name: 'time_updated')
  String timeUpdated;
  @JsonKey(name: 'time_read')
  String timeRead;
  @JsonKey(name: 'time_favorited')
  String timeFavorited;
  @JsonKey(name: 'sort_id')
  int sortId;
  @JsonKey(name: 'resolved_title')
  String? resolvedTitle;
  @JsonKey(name: 'resolved_url')
  String resolvedUrl;
  String excerpt;
  @JsonKey(name: 'is_article')
  String isAaricle;
  @JsonKey(name: 'is_index')
  String isIndex;
  @JsonKey(name: 'has_video')
  String hasVideo;
  @JsonKey(name: 'has_image')
  String hasImage;
  @JsonKey(name: 'word_count')
  String wordCount;
  String lang;
  @JsonKey(name: 'domain_metadata')
  Map<String, dynamic>? domainMetadata;
  @JsonKey(name: 'top_image_url')
  String? topImageUrl;
  @JsonKey(name: 'listen_duration_estimate')
  int listenDurationEstimate;

  Item({
    required this.itemId,
    required this.resolvedId,
    required this.givenUrl,
    required this.givenTitle,
    required this.favorite,
    required this.status,
    required this.timeAdded,
    required this.timeUpdated,
    required this.timeRead,
    required this.timeFavorited,
    required this.sortId,
    required this.resolvedTitle,
    required this.resolvedUrl,
    required this.excerpt,
    required this.isAaricle,
    required this.isIndex,
    required this.hasVideo,
    required this.hasImage,
    required this.wordCount,
    required this.lang,
    this.domainMetadata,
    this.topImageUrl,
    required this.listenDurationEstimate,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
