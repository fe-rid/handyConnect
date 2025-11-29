import '../../core/models/handyman.dart';
import '../../core/models/enums.dart';

abstract class HandymanRepository {
  Future<List<HandymanProfile>> fetchHandymen({ServiceCategory? category, String? location});
  Future<HandymanProfile?> getById(String id);
  Future<HandymanProfile> upsertProfile(HandymanProfile profile);
}
