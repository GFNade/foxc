import 'package:untitled/common/api_service/api_service.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/models/faq_categories_model.dart';
import 'package:untitled/models/notification_model.dart';
import 'package:untitled/models/setting_model.dart';
import 'package:untitled/models/user_notification_model.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/params.dart';
import 'package:untitled/utilities/web_service.dart';

class CommonService {
  static var shared = CommonService();

  void fetchGlobalSettings(Function(bool) completion) {
    ApiService.shared.call(
      url: WebService.fetchSetting,
      completion: (p0) {
        var setting = SettingModel.fromJson(p0).data;
        if (setting != null) {
          SessionManager.shared.setSettings(setting);
          completion(true);
        }
      },
    );
  }

  void fetchPlatformNotification(int start,
      Function(List<PlatformNotification> notifications) completion) {
    var param = {Param.start: start, Param.limit: Limits.pagination};
    ApiService.shared.call(
      url: WebService.fetchPlatformNotification,
      param: param,
      completion: (response) {
        var notifications = NotificationModel.fromJson(response).data;
        if (notifications != null) {
          completion(notifications);
        }
      },
    );
  }

  void fetchUserNotifications(
      int start, Function(List<UserNotification> notifications) completion) {
    var param = {
      Param.start: start,
      Param.limit: Limits.pagination,
      Param.myUserId: SessionManager.shared.getUserID()
    };
    ApiService.shared.call(
      url: WebService.fetchUserNotification,
      param: param,
      completion: (response) {
        var notifications = UserNotificationModel.fromJson(response).data;
        if (notifications != null) {
          completion(notifications);
        }
      },
    );
  }

  void fetchFAQs(Function(List<FAQsCategory> categories) completion) {
    ApiService.shared.call(
      url: WebService.fetchFAQs,
      completion: (response) {
        var categories = FaqCategoriesModel.fromJson(response).data;
        if (categories != null) {
          completion(categories);
        }
      },
    );
  }
}
