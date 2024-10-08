import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/api_service/api_service.dart';
import 'package:untitled/models/common_response.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/users_model.dart';
import 'package:untitled/utilities/params.dart';
import 'package:untitled/utilities/web_service.dart';

class StoryService {
  static var shared = StoryService();

  void fetchStories(Function(List<User> storyUsers) completion) {
    var param = {Param.myUserId: SessionManager.shared.getUserID()};
    ApiService.shared.call(
      url: WebService.fetchStories,
      param: param,
      completion: (response) {
        var data = UsersModel.fromJson(response).data;
        if (data != null) {
          completion(data);
        }
      },
    );
  }

  void viewStory(num storyId, Function() completion) {
    var param = {Param.userId: SessionManager.shared.getUserID(), Param.storyId: storyId};
    ApiService.shared.call(
      url: WebService.viewStory,
      param: param,
      completion: (response) {
        var status = CommonResponse.fromJson(response).status;
        if (status == true) {
          completion();
        }
      },
    );
  }

  void createStory(String fileURL, int type, double duration, Function() completion) {
    var param = {
      Param.userId: SessionManager.shared.getUserID(),
      Param.type: type,
      Param.duration: duration,
    };
    var file = XFile(fileURL);
    ApiService.shared.multiPartCallApi(
      url: WebService.createStory,
      param: param,
      filesMap: {
        Param.content: [file]
      },
      completion: (response) {
        var status = CommonResponse.fromJson(response).status;
        if (status == true) {
          completion();
        }
      },
    );
  }

  void deleteStory(num storyId, Function() completion) {
    var param = {Param.myUserId: SessionManager.shared.getUserID(), Param.storyId: storyId};
    ApiService.shared.call(
      url: WebService.deleteStory,
      param: param,
      completion: (response) {
        var status = CommonResponse.fromJson(response).status;
        if (status == true) {
          completion();
        }
      },
    );
  }
}
