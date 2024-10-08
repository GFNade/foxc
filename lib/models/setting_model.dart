class SettingModel {
  SettingModel({
    bool? status,
    String? message,
    Settings? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  SettingModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Settings.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  Settings? _data;

  SettingModel copyWith({
    bool? status,
    String? message,
    Settings? data,
  }) =>
      SettingModel(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get status => _status;

  String? get message => _message;

  Settings? get data => _data;
}

class Settings {
  Settings({
    num? id,
    String? currency,
    num? isAdmobOn,
    num? minuteLimitInCreatingStory,
    num? minuteLimitInChoosingVideoForStory,
    num? minuteLimitInChoosingVideoForPost,
    num? maxImagesCanBeUploadedInOnePost,
    num? maximumMinUsersLive,
    num? messagePrice,
    num? reverseSwipePrice,
    num? liveWatchingPrice,
    num? forDatingApp,
    String? adBannerAndroid,
    String? adInterstitialAndroid,
    String? adBannerIOS,
    String? adInterstitialIOS,
    String? createdAt,
    String? updatedAt,
    List<Interest>? interests,
    List<Interest>? reportReasons,
    List<Interest>? documentType,
  }) {
    _id = id;
    _minuteLimitInCreatingStory = minuteLimitInCreatingStory;
    _minuteLimitInChoosingVideoForStory = minuteLimitInChoosingVideoForStory;
    _minuteLimitInChoosingVideoForPost = minuteLimitInChoosingVideoForPost;
    _maxImagesCanBeUploadedInOnePost = maxImagesCanBeUploadedInOnePost;
    _adBannerAndroid = adBannerAndroid;
    _adInterstitialAndroid = adInterstitialAndroid;
    _adBannerIOS = adBannerIOS;
    _adInterstitialIOS = adInterstitialIOS;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _interests = interests;
  }

  Settings.fromJson(dynamic json) {
    _id = json['id'];
    _isAdmobOn = json['is_admob_on'];
    _minuteLimitInCreatingStory = json['minute_limit_in_creating_story'];
    _minuteLimitInChoosingVideoForStory = json['minute_limit_in_choosing_video_for_story'];
    _minuteLimitInChoosingVideoForPost = json['minute_limit_in_choosing_video_for_post'];
    _maxImagesCanBeUploadedInOnePost = json['max_images_can_be_uploaded_in_one_post'];
    _adBannerAndroid = json['ad_banner_android'];
    _adInterstitialAndroid = json['ad_interstitial_android'];
    _adBannerIOS = json['ad_banner_iOS'];
    _adInterstitialIOS = json['ad_interstitial_iOS'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['interests'] != null) {
      _interests = [];
      json['interests'].forEach((v) {
        _interests?.add(Interest.fromJson(v));
      });
    }
    if (json['documentType'] != null) {
      _documentType = [];
      json['documentType'].forEach((v) {
        _documentType?.add(Interest.fromJson(v));
      });
    }
    if (json['reportReasons'] != null) {
      _reportReasons = [];
      json['reportReasons'].forEach((v) {
        _reportReasons?.add(Interest.fromJson(v));
      });
    }
  }

  num? _id;
  num? _isAdmobOn;
  num? _minuteLimitInCreatingStory;
  num? _minuteLimitInChoosingVideoForStory;
  num? _minuteLimitInChoosingVideoForPost;
  num? _maxImagesCanBeUploadedInOnePost;
  String? _adBannerAndroid;
  String? _adInterstitialAndroid;
  String? _adBannerIOS;
  String? _adInterstitialIOS;
  String? _createdAt;
  String? _updatedAt;
  List<Interest>? _interests;
  List<Interest>? _documentType;
  List<Interest>? _reportReasons;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['is_admob_on'] = _isAdmobOn;
    map['minute_limit_in_creating_story'] = _minuteLimitInCreatingStory;
    map['minute_limit_in_choosing_video_for_story'] = _minuteLimitInChoosingVideoForStory;

    map['minute_limit_in_choosing_video_for_post'] = _minuteLimitInChoosingVideoForPost;

    map['max_images_can_be_uploaded_in_one_post'] = _maxImagesCanBeUploadedInOnePost;
    map['ad_banner_android'] = _adBannerAndroid;
    map['ad_interstitial_android'] = _adInterstitialAndroid;
    map['ad_banner_iOS'] = _adBannerIOS;
    map['ad_interstitial_iOS'] = _adInterstitialIOS;
    map['created_at'] = _createdAt;
    _updatedAt = map['updated_at'];
    if (_interests != null) {
      map['interest'] = _interests?.map((v) => v.toJson()).toList();
    }
    if (_documentType != null) {
      map['documentType'] = _documentType?.map((v) => v.toJson()).toList();
    }
    if (_reportReasons != null) {
      map['reportReasons'] = _reportReasons?.map((v) => v.toJson()).toList();
    }

    return map;
  }

  num? get id => _id;

  num? get minuteLimitInCreatingStory => _minuteLimitInCreatingStory;

  num? get minuteLimitInChoosingVideoForStory => _minuteLimitInChoosingVideoForStory;

  num? get minuteLimitInChoosingVideoForPost => _minuteLimitInChoosingVideoForPost;

  num? get maxImagesCanBeUploadedInOnePost => _maxImagesCanBeUploadedInOnePost;

  String? get adBannerAndroid => _adBannerAndroid;

  num? get isAdmobOn => _isAdmobOn;

  String? get adInterstitialAndroid => _adInterstitialAndroid;

  String? get adBannerIOS => _adBannerIOS;

  String? get adInterstitialIOS => _adInterstitialIOS;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  List<Interest>? get interests => _interests;

  List<Interest>? get documentType => _documentType;

  List<Interest>? get reportReasons => _reportReasons;
}

class Interest {
  Interest({num? id, String? title, String? createdAt, String? updatedAt, num? totalRoomOfInterest}) {
    _id = id;
    _title = title;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _totalRoomOfInterest = totalRoomOfInterest;
  }

  Interest.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _totalRoomOfInterest = json['totalRoomOfInterest'];
  }

  num? _id;
  String? _title;
  String? _createdAt;
  String? _updatedAt;
  num? _totalRoomOfInterest;

  Interest copyWith({
    num? id,
    String? title,
    String? createdAt,
    String? updatedAt,
  }) =>
      Interest(
        id: id ?? _id,
        title: title ?? _title,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  num? get id => _id;

  String? get title => _title;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  num? get totalRoomOfInterest => _totalRoomOfInterest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['totalRoomOfInterest'] = _totalRoomOfInterest;
    return map;
  }
}
