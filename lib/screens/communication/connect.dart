import 'package:flutter/material.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/backend/models/service_booking.dart';
import 'package:gausampada/backend/models/user_model.dart';
import 'package:gausampada/backend/providers/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  bool _isTabControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentProvider>(context, listen: false).initialize();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the user type and set up tab controller accordingly
    final provider = Provider.of<AppointmentProvider>(context);
    final userType = provider.currentUser?.userType;

    if (userType == null)
      return; // Don't proceed if user type is not available yet

    final tabCount = userType == UserType.farmer ? 3 : 2;

    // Ensure current index is valid for the new tab count
    if (_currentIndex >= tabCount) {
      _currentIndex = 0;
    }

    // Dispose previous controller if it exists
    if (_isTabControllerInitialized) {
      _tabController.removeListener(_handleTabChange);
      _tabController.dispose();
    }

    // Create the new controller
    _tabController = TabController(
      length: tabCount,
      vsync: this,
      initialIndex: _currentIndex,
    );

    _tabController.addListener(_handleTabChange);
    _isTabControllerInitialized = true;
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    if (_isTabControllerInitialized) {
      _tabController.removeListener(_handleTabChange);
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, provider, child) {
        // Show loading indicator while initializing
        if (provider.isLoading && provider.currentUser == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final userType = provider.currentUser?.userType;

        // If user type is not known yet, return empty container
        if (userType == null) {
          return const Scaffold(
            body: Center(
              child: Text("User type not found. Please check your account."),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Appointments"),
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              controller: _tabController,
              tabs: _buildTabs(userType.name),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: _buildTabViews(userType.name, provider),
          ),
          floatingActionButton: userType == UserType.farmer &&
                  _currentIndex == 0
              ? FloatingActionButton(
                  onPressed: () => _showBookAppointmentSheet(context, provider),
                  tooltip: 'Book Appointment',
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  // Build tabs based on user type
  List<Widget> _buildTabs(String userType) {
    if (userType == 'farmer') {
      return const [
        Tab(text: "Doctors", icon: Icon(Icons.people)),
        Tab(text: "Current", icon: Icon(Icons.calendar_today)),
        Tab(text: "Previous", icon: Icon(Icons.history)),
      ];
    } else {
      return const [
        Tab(text: "Current", icon: Icon(Icons.calendar_today)),
        Tab(text: "Previous", icon: Icon(Icons.history)),
      ];
    }
  }

  // Build tab views based on user type
  List<Widget> _buildTabViews(String userType, AppointmentProvider provider) {
    if (userType == 'farmer') {
      return [
        _buildDoctorsTab(provider),
        _buildCurrentAppointmentsTab(userType, provider),
        _buildPreviousAppointmentsTab(userType, provider),
      ];
    } else {
      return [
        _buildCurrentAppointmentsTab(userType, provider),
        _buildPreviousAppointmentsTab(userType, provider),
      ];
    }
  }

  // Doctors list tab (only for farmers)
  Widget _buildDoctorsTab(AppointmentProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No doctors available at the moment."),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.refreshData(),
              child: const Text("Refresh"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.refreshData(),
      child: ListView.builder(
        itemCount: provider.doctors.length,
        itemBuilder: (context, index) {
          final doctor = provider.doctors[index];
          return DoctorCard(
            doctor: doctor,
            onBookAppointment: () =>
                _showBookAppointmentDialog(context, provider, doctor),
          );
        },
      ),
    );
  }

  // Current appointments tab
  Widget _buildCurrentAppointmentsTab(
      String userType, AppointmentProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.currentAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No current appointments."),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.refreshData(),
              child: const Text("Refresh"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.refreshData(),
      child: ListView.builder(
        itemCount: provider.currentAppointments.length,
        itemBuilder: (context, index) {
          final appointment = provider.currentAppointments[index];
          return AppointmentCard(
            appointment: appointment,
            userType: userType,
            onUpdateStatus: (status) =>
                _updateAppointmentStatus(provider, appointment.id, status),
          );
        },
      ),
    );
  }

  // Previous appointments tab
  Widget _buildPreviousAppointmentsTab(
      String userType, AppointmentProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.previousAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No previous appointments."),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.refreshData(),
              child: const Text("Refresh"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.refreshData(),
      child: ListView.builder(
        itemCount: provider.previousAppointments.length,
        itemBuilder: (context, index) {
          final appointment = provider.previousAppointments[index];
          return AppointmentCard(
            appointment: appointment,
            userType: userType,
            isPrevious: true,
          );
        },
      ),
    );
  }

  // Method to update appointment status
  Future<void> _updateAppointmentStatus(
      AppointmentProvider provider, String appointmentId, String status) async {
    final success =
        await provider.updateAppointmentStatus(appointmentId, status);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error)),
      );
    }
  }

  // Show dialog to book an appointment
  Future<void> _showBookAppointmentDialog(
    BuildContext context,
    AppointmentProvider provider,
    UserModel doctor,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (pickedDate == null || !mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (pickedTime == null || !mounted) return;

    // Combine date and time
    final DateTime appointmentDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Show notes dialog
    final TextEditingController notesController = TextEditingController();
    final bool? proceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Additional Notes'),
        content: TextField(
          controller: notesController,
          decoration: const InputDecoration(
            hintText: 'Enter any notes for the doctor (optional)',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Book'),
          ),
        ],
      ),
    );

    if (proceed != true || !mounted) return;

    // Book the appointment
    final success = await provider.createAppointment(
      doctorId: doctor.uid,
      doctorName: doctor.name,
      appointmentDate: appointmentDateTime,
      notes: notesController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Appointment booked successfully!' : provider.error,
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      // Switch to current appointments tab if booking was successful
      if (success) {
        _tabController.animateTo(1);
      }
    }
  }

  // Show bottom sheet to book appointment
  void _showBookAppointmentSheet(
      BuildContext context, AppointmentProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select a Doctor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: provider.doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = provider.doctors[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(doctor.name[0]),
                        ),
                        title: Text(doctor.name),
                        subtitle: Text('General'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.pop(context);
                          _showBookAppointmentDialog(context, provider, doctor);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Doctor Card Widget
class DoctorCard extends StatelessWidget {
  final UserModel doctor;
  final VoidCallback onBookAppointment;

  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.onBookAppointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    doctor.name[0],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'General',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (doctor.location != null)
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: Colors.grey.shade700),
                            const SizedBox(width: 4),
                            Text(
                              doctor.location!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Show contact details or additional info
                  },
                  child: const Text('View'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onBookAppointment,
                  child: const Text('Book Appointment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Appointment Card Widget
class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final String userType;
  final Function(String)? onUpdateStatus;
  final bool isPrevious;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.userType,
    this.onUpdateStatus,
    this.isPrevious = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('EEE, MMM d, yyyy');
    final DateFormat timeFormat = DateFormat('h:mm a');

    // Choose the person's name to display based on user type
    final String personName =
        userType == 'farmer' ? appointment.doctorName : appointment.farmerName;

    // Choose the person's role to display
    final String personRole = userType == 'farmer' ? 'Doctor' : 'Farmer';

    // Get status color
    Color statusColor;
    if (appointment.status == 'scheduled') {
      statusColor = Colors.blue;
    } else if (appointment.status == 'completed') {
      statusColor = Colors.green;
    } else {
      statusColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(appointment.appointmentDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Chip(
                  label: Text(
                    appointment.status.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  timeFormat.format(appointment.appointmentDate),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Text(personName[0]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$personRole: $personName',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (appointment.notes.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Notes:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(appointment.notes),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (!isPrevious && onUpdateStatus != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => onUpdateStatus!('cancelled'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => onUpdateStatus!('completed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Complete'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
