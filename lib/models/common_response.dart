class CommonResponse {
  CommonResponse({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  CommonResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }
  bool? _status;
  String? _message;
  CommonResponse copyWith({
    bool? status,
    String? message,
  }) =>
      CommonResponse(
        status: status ?? _status,
        message: message ?? _message,
      );
  bool? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }
}
