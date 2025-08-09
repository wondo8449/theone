import 'package:theone/features/sharing/data/sharing_api.dart';

class SharingRepository {
  final SharingApi sharingApi;

  SharingRepository(this.sharingApi);

  Future<List<Map<String, dynamic>>> getQTSharingList({int page = 1, String? searchValue}) {
    return sharingApi.getQTSharingList(page: page, searchValue: searchValue);
  }

  Future<List<Map<String, dynamic>>> getInvitationSharingList({int page = 1, String? searchValue}) {
    return sharingApi.getInvitationSharingList(page: page, searchValue: searchValue);
  }

  Future<Map<String, dynamic>> createSharing(Map<String, dynamic> data) {
    return sharingApi.createSharing(data);
  }

  Future<Map<String, dynamic>> getSharingDetail(int id) {
    return sharingApi.getSharingDetail(id);
  }

  Future<Map<String, dynamic>> modifySharing(int id, Map<String, dynamic> data) {
    return sharingApi.modifySharing(id, data);
  }

  Future<void> deleteSharing(int id) {
    return sharingApi.deleteSharing(id);
  }

  Future<void> declarationSharing(int id) {
    return sharingApi.declarationSharing(id);
  }
}