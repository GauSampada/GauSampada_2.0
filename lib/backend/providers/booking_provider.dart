// lib/providers/appointment_provider.dart

import 'package:flutter/material.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/backend/models/service_booking.dart';
import 'package:gausampada/backend/services/booking_services.dart';
import '../models/user_model.dart';

class AppointmentProvider extends ChangeNotifier {
  // AppointmentProvider() {
  //   initialize();
  // }
  final FirebaseService _firebaseService = FirebaseService();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  List<UserModel> _doctors = [];
  List<UserModel> get doctors => _doctors;

  List<Appointment> _currentAppointments = [];
  List<Appointment> get currentAppointments => _currentAppointments;

  List<Appointment> _previousAppointments = [];
  List<Appointment> get previousAppointments => _previousAppointments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  // Initialize provider and load user data
  Future<void> initialize() async {
    _setLoading(true);
    try {
      _currentUser = await _firebaseService.getCurrentUser();
      if (_currentUser != null) {
        await _loadData();
      }
      _error = '';
    } catch (e) {
      _error = 'Failed to initialize: $e';
      print(_error);
    }
    _setLoading(false);
  }

  // Load appropriate data based on user type
  Future<void> _loadData() async {
    if (_currentUser == null) return;

    try {
      // Load appointments for both user types
      await Future.wait([
        _loadCurrentAppointments(),
        _loadPreviousAppointments(),
      ]);

      // Load doctors list only for farmers
      if (_currentUser!.userType == UserType.farmer) {
        await _loadDoctors();
      }

      _error = '';
    } catch (e) {
      _error = 'Failed to load data: $e';
      print(_error);
    }
  }

  // Load doctors list
  Future<void> _loadDoctors() async {
    try {
      _doctors = await _firebaseService.getAllDoctors();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load doctors: $e';
      print(_error);
    }
  }

  // Load current appointments
  Future<void> _loadCurrentAppointments() async {
    if (_currentUser == null) return;

    try {
      _currentAppointments = await _firebaseService
          .getCurrentAppointments(_currentUser!.userType.name);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load current appointments: $e';
      print(_error);
    }
  }

  // Load previous appointments
  Future<void> _loadPreviousAppointments() async {
    if (_currentUser == null) return;

    try {
      _previousAppointments = await _firebaseService
          .getPreviousAppointments(_currentUser!.userType.name);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load previous appointments: $e';
      print(_error);
    }
  }

  // Create new appointment
  Future<bool> createAppointment({
    required String doctorId,
    required String doctorName,
    required DateTime appointmentDate,
    String notes = '',
  }) async {
    _setLoading(true);
    bool success = false;

    try {
      success = await _firebaseService.createAppointment(
        doctorId: doctorId,
        doctorName: doctorName,
        appointmentDate: appointmentDate,
        notes: notes,
      );

      if (success) {
        await _loadCurrentAppointments();
        _error = '';
      } else {
        _error = 'Failed to create appointment';
      }
    } catch (e) {
      _error = 'Failed to create appointment: $e';
      print(_error);
    }

    _setLoading(false);
    return success;
  }

  // Update appointment status
  Future<bool> updateAppointmentStatus(
      String appointmentId, String status) async {
    _setLoading(true);
    bool success = false;

    try {
      success =
          await _firebaseService.updateAppointmentStatus(appointmentId, status);

      if (success) {
        // Reload appointments after status change
        await Future.wait([
          _loadCurrentAppointments(),
          _loadPreviousAppointments(),
        ]);
        _error = '';
      } else {
        _error = 'Failed to update appointment status';
      }
    } catch (e) {
      _error = 'Failed to update appointment status: $e';
      print(_error);
    }

    _setLoading(false);
    return success;
  }

  // Refresh all data
  Future<void> refreshData() async {
    _setLoading(true);
    await _loadData();
    _setLoading(false);
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
