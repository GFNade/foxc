import 'package:flutter/material.dart';
import 'package:untitled/common/api_service/room_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/models/invitations_model.dart';

class InvitationController extends BaseController {
  List<Invitation> invitations = [];
  ScrollController scrollController = ScrollController();

  @override
  void onReady() {
    getInvitations();
    scrollController.addListener(
      () {
        if (scrollController.offset ==
            scrollController.position.maxScrollExtent) {
          if (!isLoading) {
            getInvitations();
          }
        }
      },
    );
    super.onReady();
  }

  void getInvitations() {
    if (invitations.isEmpty) {
      startLoading();
    }
    isLoading = true;
    RoomService.shared.getInvitationList(
      invitations.length,
      (invitations) {
        if (this.invitations.isEmpty) {
          stopLoading();
        }
        isLoading = false;
        this.invitations.addAll(invitations);
        update();
      },
    );
  }

  void acceptInvitation(Invitation invitation) {
    startLoading();
    RoomService.shared.acceptInvitation(invitation.roomId ?? 0, () {
      stopLoading();
      removeFromList(invitation);
    });
  }

  void rejectInvitation(Invitation invitation) {
    startLoading();
    RoomService.shared.rejectInvitation(invitation.roomId ?? 0, () {
      stopLoading();
      removeFromList(invitation);
    });
  }

  void removeFromList(Invitation invitation) {
    invitations.removeWhere((element) => element.id == invitation.id);
    update();
  }
}
