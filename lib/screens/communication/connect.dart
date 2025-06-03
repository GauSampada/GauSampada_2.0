import 'package:flutter/material.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/backend/models/service_booking.dart';
import 'package:gausampada/backend/models/user_model.dart';
import 'package:gausampada/backend/providers/booking_provider.dart';
import 'package:gausampada/screens/communication/widgets/chat.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

const Color themeColor = Color(0xFF0A7643);
const Color backgroundColor = Colors.white;
const Color blackColor = Colors.black;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentProvider>(context, listen: false).initialize();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<AppointmentProvider>(context);
    final userType = provider.currentUser?.userType;

    if (userType == null) return;

    final tabCount = userType == UserType.farmer ? 3 : 2;

    if (_currentIndex >= tabCount) {
      _currentIndex = 0;
    }

    if (_isTabControllerInitialized) {
      _tabController.removeListener(_handleTabChange);
      _tabController.dispose();
    }

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
        if (provider.isLoading && provider.currentUser == null) {
          return const Scaffold(
            backgroundColor: backgroundColor,
            body: Center(child: CircularProgressIndicator(color: themeColor)),
          );
        }

        final userType = provider.currentUser?.userType;

        if (userType == null) {
          return const Scaffold(
            backgroundColor: backgroundColor,
            body: Center(
              child: Text(
                "User type not found. Please check your account.",
                style: TextStyle(color: blackColor),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: themeColor,
            title: const Text(
              "Appointments",
              style: TextStyle(color: Colors.white),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
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
                  backgroundColor: themeColor,
                  onPressed: () => _showBookAppointmentSheet(context, provider),
                  tooltip: 'Book Appointment',
                  child: const Icon(Icons.add, color: Colors.white),
                )
              : null,
        );
      },
    );
  }

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

  Widget _buildDoctorsTab(AppointmentProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: themeColor));
    }

    if (provider.doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "No doctors available at the moment.",
              style: TextStyle(color: blackColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: themeColor),
              onPressed: () => provider.refreshData(),
              child:
                  const Text("Refresh", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: themeColor,
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

  Widget _buildCurrentAppointmentsTab(
      String userType, AppointmentProvider provider) {
    return StreamBuilder<List<Appointment>>(
      stream: provider.streamCurrentAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: themeColor));
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: blackColor),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                  onPressed: () => provider.refreshData(),
                  child: const Text("Retry",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        final appointments = snapshot.data ?? [];
        if (appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No current appointments.",
                    style: TextStyle(color: blackColor)),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                  onPressed: () => provider.refreshData(),
                  child: const Text("Refresh",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: themeColor,
          onRefresh: () => provider.refreshData(),
          child: ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return AppointmentCard(
                appointment: appointment,
                userType: userType,
                onUpdateStatus: (status) =>
                    _updateAppointmentStatus(provider, appointment.id, status),
                onChat: () {
                  if (mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AppointmentChatScreen(
                            appointmentId: appointment.id,
                          ),
                        ),
                      );
                    });
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPreviousAppointmentsTab(
      String userType, AppointmentProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: themeColor));
    }

    if (provider.previousAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No previous appointments.",
                style: TextStyle(color: blackColor)),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: themeColor),
              onPressed: () => provider.refreshData(),
              child:
                  const Text("Refresh", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: themeColor,
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

  Future<void> _updateAppointmentStatus(
      AppointmentProvider provider, String appointmentId, String status) async {
    final success =
        await provider.updateAppointmentStatus(appointmentId, status);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primaryColor: themeColor,
            colorScheme: ColorScheme.light(primary: themeColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primaryColor: themeColor,
            colorScheme: ColorScheme.light(primary: themeColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null || !mounted) return;

    final DateTime appointmentDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final TextEditingController notesController = TextEditingController();
    final bool? proceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        title:
            const Text('Additional Notes', style: TextStyle(color: blackColor)),
        content: TextField(
          controller: notesController,
          decoration: const InputDecoration(
            hintText: 'Enter any notes for the doctor (optional)',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: themeColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Book', style: TextStyle(color: themeColor)),
          ),
        ],
      ),
    );

    if (proceed != true || !mounted) return;

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
          backgroundColor: success ? themeColor : Colors.red,
        ),
      );

      if (success) {
        _tabController.animateTo(1);
      }
    }
  }

  void _showBookAppointmentSheet(
      BuildContext context, AppointmentProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
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
                        color: blackColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: blackColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(color: themeColor),
                Expanded(
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: provider.doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = provider.doctors[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: themeColor.withOpacity(0.1),
                            child: Text(
                              doctor.name[0],
                              style: const TextStyle(color: themeColor),
                            ),
                          ),
                          title: Text(doctor.name,
                              style: const TextStyle(color: blackColor)),
                          subtitle: const Text('General',
                              style: TextStyle(color: Colors.grey)),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 16, color: themeColor),
                          onTap: () {
                            Navigator.pop(context);
                            _showBookAppointmentDialog(
                                context, provider, doctor);
                          },
                        );
                      }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

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
      color: backgroundColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: themeColor.withOpacity(0.1),
                  child: Text(
                    doctor.name[0],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
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
                          color: blackColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'General',
                        style: TextStyle(color: Colors.grey),
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
                              style: TextStyle(color: Colors.grey.shade700),
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
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: themeColor,
                    side: const BorderSide(color: themeColor),
                  ),
                  child: const Text('View'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onBookAppointment,
                  style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                  child: const Text('Book Appointment',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final String userType;
  final Function(String)? onUpdateStatus;
  final VoidCallback? onChat;
  final bool isPrevious;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.userType,
    this.onUpdateStatus,
    this.onChat,
    this.isPrevious = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('EEE, MMM d, yyyy');
    final DateFormat timeFormat = DateFormat('h:mm a');

    final String personName =
        userType == 'farmer' ? appointment.doctorName : appointment.farmerName;
    final String personRole = userType == 'farmer' ? 'Doctor' : 'Farmer';

    Color statusColor;
    switch (appointment.status) {
      case 'scheduled':
        statusColor = Colors.blue;
        break;
      case 'completed':
        statusColor = themeColor;
        break;
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: backgroundColor,
      elevation: 2,
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
                    color: blackColor,
                  ),
                ),
                Chip(
                  label: Text(
                    appointment.status.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: themeColor.withOpacity(0.1),
                  child: Text(
                    personName[0],
                    style: const TextStyle(color: themeColor),
                  ),
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
                          color: blackColor,
                        ),
                      ),
                      if (appointment.notes.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Notes:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: blackColor),
                        ),
                        const SizedBox(height: 4),
                        Text(appointment.notes,
                            style: const TextStyle(color: blackColor)),
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
                  if (userType == 'doctor' && appointment.status == 'pending')
                    ElevatedButton(
                      onPressed: () => onUpdateStatus!('approved'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: themeColor),
                      child: const Text('Approve',
                          style: TextStyle(color: Colors.white)),
                    ),
                  if (appointment.status != 'approved' &&
                      appointment.status != 'completed')
                    const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => onUpdateStatus!('cancelled'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Cancel'),
                  ),
                  if (appointment.status == 'approved') ...[
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onChat,
                      style:
                          ElevatedButton.styleFrom(backgroundColor: themeColor),
                      child: const Text('Chat',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  if (userType == 'doctor' &&
                      appointment.status == 'approved') ...[
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => onUpdateStatus!('completed'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: themeColor),
                      child: const Text('Complete',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
