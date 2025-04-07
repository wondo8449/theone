import 'invitation_api.dart';

class InvitationRepository {
  final InvitationApi invitationApi;

  InvitationRepository(this.invitationApi);

  Future<List<Map<String, dynamic>>> showInvitationList() async {
    return await invitationApi.showInvitationList();
  }

  Future<void> editInvitation(int invitationId, Map<String, dynamic> dto) async {
    await invitationApi.editInvitation(invitationId, dto);
  }
}