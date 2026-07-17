import 'package:flutter/foundation.dart';
import 'package:dairy_frontend/core/network/api_client.dart';
import 'package:dairy_frontend/core/network/api_exceptions.dart';
import 'package:dairy_frontend/features/dashboard/models/dashboard_models.dart';
import 'package:dairy_frontend/features/dashboard/services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _service;

  DashboardSummary? _summary;
  bool _isLoading = false;
  String? _error;

  DashboardProvider({required ApiClient apiClient})
      : _service = DashboardService(apiClient: apiClient);

  DashboardSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<void> loadSummary() async {
    _setLoading(true);
    _setError(null);
    try {
      _summary = await _service.getSummary();
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Failed to load dashboard data');
    } finally {
      _setLoading(false);
    }
  }
}
