// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserFeedback _$UserFeedbackFromJson(Map<String, dynamic> json) =>
    _UserFeedback(
      id: json['id'] as String,
      category: $enumDecode(_$FeedbackCategoryEnumMap, json['category']),
      message: json['message'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$UserFeedbackToJson(_UserFeedback instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': _$FeedbackCategoryEnumMap[instance.category]!,
      'message': instance.message,
      'createdAt': instance.createdAt,
    };

const _$FeedbackCategoryEnumMap = {
  FeedbackCategory.BUG: 'BUG',
  FeedbackCategory.FEATURE_REQUEST: 'FEATURE_REQUEST',
  FeedbackCategory.GENERAL: 'GENERAL',
  FeedbackCategory.COMPLAINT: 'COMPLAINT',
};
