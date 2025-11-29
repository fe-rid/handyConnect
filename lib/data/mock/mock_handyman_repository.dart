import '../../core/models/enums.dart';
import '../../core/models/handyman.dart';
import '../repositories/handyman_repository.dart';
import 'mock_data.dart';

class MockHandymanRepository implements HandymanRepository {
  List<HandymanProfile> _items = List.of(MockData.handymen);

  @override
  Future<List<HandymanProfile>> fetchHandymen({ServiceCategory? category, String? location}) async {
    return _items.where((h) {
      final catOk = category == null || h.serviceType == category;
      final locOk = location == null || (h.location?.toLowerCase().contains(location.toLowerCase()) ?? false);
      return catOk && locOk;
    }).toList();
  }

  @override
  Future<HandymanProfile?> getById(String id) async {
    return _items.where((e) => e.id == id).cast<HandymanProfile?>().firstOrNull;
  }

  @override
  Future<HandymanProfile> upsertProfile(HandymanProfile profile) async {
    final idx = _items.indexWhere((e) => e.id == profile.id);
    if (idx >= 0) {
      _items[idx] = profile;
    } else {
      _items.add(profile);
    }
    return profile;
  }
}

extension FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
