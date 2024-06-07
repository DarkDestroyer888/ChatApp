import 'package:json_annotation/json_annotation.dart';

part 'image_model.g.dart';
@JsonSerializable()

class PixelfordImage {
  String id;
  String filename;
  String? title;

  @JsonKey(name: 'url_full_size')
  String urlFullsize;
  @JsonKey(name: 'url_small_size')
  String urlSmallsize;

  PixelfordImage(
      {required this.id,
      required this.filename,
      this.title,
      required this.urlFullsize,
      required this.urlSmallsize});

  factory PixelfordImage.fromJson(Map<String, dynamic> json) => _$PixelfordImageFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PixelfordImageToJson(this);

}
