import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  http.Client? client = http.Client();
  var header = {'apikey': '123'};
  static var shared = ApiService();

  void call(
      {required String url,
      Map<String, dynamic>? param,
      required Function(Object response) completion}) {
    Map<String, String> params = {};
    param?.forEach((key, value) {
      params[key] = "$value";
    });
    if (kDebugMode) {
      print("URL: $url");
      print("parameters: $params");
    }
    http.post(Uri.parse(url), headers: header, body: params).then((value) {
      var response = jsonDecode(value.body);
      if (kDebugMode) {
        print(value.body);
      }

      completion(response);
    });
  }

  void multiPartCallApi(
      {required String url,
      Map<String, dynamic>? param,
      required Map<String, List<XFile?>> filesMap,
      required Function(Object response) completion,
      Function(double percentage)? onProgress}) {
    var request = MultipartRequest(
      'POST',
      Uri.parse(url),
      onProgress: (bytes, totalBytes) {
        if (onProgress != null) {
          onProgress(bytes / totalBytes);
        }
      },
    );

    Map<String, String> params = {};
    param?.forEach((key, value) {
      params[key] = "$value";
    });

    request.fields.addAll(params);
    request.headers.addAll(header);

    filesMap.forEach((keyName, files) {
      for (var xFile in files) {
        if (xFile != null && xFile.path.isNotEmpty) {
          File file = File(xFile.path);
          var multipartFile = http.MultipartFile(
              keyName, file.readAsBytes().asStream(), file.lengthSync(),
              filename: xFile.name);
          request.files.add(multipartFile);
        }
      }
    });
    print(param);
    request.send().then((value) {
      print('${value.statusCode}');
      value.stream.bytesToString().then((respStr) {
        var response = jsonDecode(respStr);
        if (kDebugMode) {
          print(respStr);
        }

        completion(response);
      });
    });
  }
}

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
    super.method,
    super.url, {
    this.onProgress,
  });

  final void Function(int bytes, int totalBytes)? onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    // if (onProgress == null) return byteStream;

    final total = contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        if (onProgress != null) {
          onProgress!(bytes, total);
        }
        if (total >= bytes) {
          sink.add(data);
        }
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
