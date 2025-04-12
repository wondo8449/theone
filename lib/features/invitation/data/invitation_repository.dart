import 'invitation_api.dart';

class InvitationRepository {
  final InvitationApi invitationApi;

  InvitationRepository(this.invitationApi);

  Future<List<Map<String, dynamic>>> showInvitationList() async {
    return await invitationApi.showInvitationList();
  }

  Future<Map<String, dynamic>> getInvitationDetail(int id) {
    return invitationApi.getInvitationDetail(id);
  }

  Future<Map<String, dynamic>> updateInvitation(int invitationId, Map<String, dynamic> dto) {
    return invitationApi.editInvitation(invitationId, dto);
  }

  Future<Map<String, dynamic>> deleteInvitation(int id) {
    return invitationApi.deleteInvitation(id);
  }

}