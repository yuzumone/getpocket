// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      itemId: json['item_id'] as String,
      resolvedId: json['resolved_id'] as String,
      givenUrl: json['given_url'] as String,
      givenTitle: json['given_title'] as String?,
      favorite: json['favorite'] as String,
      status: json['status'] as String,
      timeAdded: json['time_added'] as String,
      timeUpdated: json['time_updated'] as String,
      timeRead: json['time_read'] as String,
      timeFavorited: json['time_favorited'] as String,
      sortId: json['sort_id'] as int,
      resolvedTitle: json['resolved_title'] as String?,
      resolvedUrl: json['resolved_url'] as String?,
      excerpt: json['excerpt'] as String?,
      isAaricle: json['is_article'] as String?,
      isIndex: json['is_index'] as String?,
      hasVideo: json['has_video'] as String?,
      hasImage: json['has_image'] as String?,
      wordCount: json['word_count'] as String?,
      lang: json['lang'] as String?,
      domainMetadata: json['domain_metadata'] as Map<String, dynamic>?,
      topImageUrl: json['top_image_url'] as String?,
      listenDurationEstimate: json['listen_duration_estimate'] as int,
    );
