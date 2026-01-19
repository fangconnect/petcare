import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/disease.dart';
import '../../data/models/disease_template.dart';
import '../../data/models/activity_type.dart';
import '../../data/repository/admin_repository.dart';

/// Provider for AdminRepository
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});

/// Disease list state
final diseasesProvider = FutureProvider<List<Disease>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getAllDiseases();
});

/// Templates for a disease
final templatesProvider = FutureProvider.family<List<DiseaseTemplate>, String>((ref, diseaseId) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getTemplatesByDiseaseId(diseaseId);
});

/// Activity types list
final activityTypesProvider = FutureProvider<List<ActivityType>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getAllActivityTypes();
});

/// Admin state notifier for mutations
class AdminNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminRepository _repo;
  final Ref _ref;

  AdminNotifier(this._repo, this._ref) : super(const AsyncValue.data(null));

  // Disease CRUD
  Future<bool> createDisease(Disease disease) async {
    state = const AsyncValue.loading();
    try {
      await _repo.createDisease(disease);
      _ref.invalidate(diseasesProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateDisease(String id, Disease disease) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateDisease(id, disease);
      _ref.invalidate(diseasesProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteDisease(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteDisease(id);
      _ref.invalidate(diseasesProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Template CRUD
  Future<bool> createTemplate(DiseaseTemplate template) async {
    state = const AsyncValue.loading();
    try {
      await _repo.createTemplate(template);
      _ref.invalidate(templatesProvider(template.diseaseId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateTemplate(String id, DiseaseTemplate template) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateTemplate(id, template);
      _ref.invalidate(templatesProvider(template.diseaseId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteTemplate(String id, String diseaseId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteTemplate(id);
      _ref.invalidate(templatesProvider(diseaseId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> setDefaultTemplate(String id, String diseaseId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.setDefaultTemplate(id);
      _ref.invalidate(templatesProvider(diseaseId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Activity Type CRUD
  Future<bool> createActivityType(ActivityType type) async {
    state = const AsyncValue.loading();
    try {
      await _repo.createActivityType(type);
      _ref.invalidate(activityTypesProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateActivityType(String id, ActivityType type) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateActivityType(id, type);
      _ref.invalidate(activityTypesProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteActivityType(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteActivityType(id);
      _ref.invalidate(activityTypesProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Activity Type with Units
  Future<bool> createActivityTypeWithUnits(ActivityType type, List<String> unitIds) async {
    state = const AsyncValue.loading();
    try {
      await _repo.createActivityTypeWithUnits(type, unitIds);
      _ref.invalidate(activityTypesProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateActivityTypeWithUnits(String id, ActivityType type, List<String> unitIds) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateActivityTypeWithUnits(id, type, unitIds);
      _ref.invalidate(activityTypesProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Unit CRUD
  Future<bool> createUnit({required String name, String? nameEn, String? symbol, String? category}) async {
    state = const AsyncValue.loading();
    try {
      await _repo.createUnit(name: name, nameEn: nameEn, symbol: symbol, category: category);
      _ref.invalidate(unitsProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateUnit(String id, {String? name, String? nameEn, String? symbol, String? category}) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateUnit(id, name: name, nameEn: nameEn, symbol: symbol, category: category);
      _ref.invalidate(unitsProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteUnit(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteUnit(id);
      _ref.invalidate(unitsProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}

/// Units list (for dropdown selection)
final unitsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getAllUnits();
});

final adminNotifierProvider = StateNotifierProvider<AdminNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(adminRepositoryProvider);
  return AdminNotifier(repo, ref);
});

