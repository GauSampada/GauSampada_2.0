import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/backend/models/appoinments_chat_model.dart';
import 'package:gausampada/backend/models/service_booking.dart';
import 'package:gausampada/backend/providers/appoinment_chat_provider.dart';
import 'package:gausampada/backend/providers/booking_provider.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/screens/communication/widgets/call.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentChatScreen extends StatefulWidget {
  final String appointmentId;

  const AppointmentChatScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentChatScreen> createState() => _AppointmentChatScreenState();
}

class _AppointmentChatScreenState extends State<AppointmentChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _chatId;
  final List<AppoinmentsChatModel> _pendingMessages = [];

  @override
  void initState() {
    super.initState();
    _loadChatId();
  }

  Future<void> _loadChatId() async {
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    final appointments = [
      ...appointmentProvider.currentAppointments,
      ...appointmentProvider.previousAppointments
    ];
    final appointment = appointments.firstWhere(
      (app) => app.id == widget.appointmentId,
      orElse: () => Appointment(
        id: '',
        doctorId: '',
        farmerId: '',
        doctorName: '',
        farmerName: '',
        appointmentDate: DateTime.now(),
        status: '',
        createdAt: DateTime.now(),
      ),
    );
    if (appointment.chatId != null) {
      setState(() {
        _chatId = appointment.chatId;
      });
      // Defer loadMessages until after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Provider.of<AppoinmentChatProvider>(context, listen: false)
              .loadMessages(appointment.chatId!);
        }
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No chat associated with this appointment'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickAndSendMedia(MessageType type, ImageSource source) async {
    try {
      final XFile? file = type == MessageType.image
          ? await _picker.pickImage(source: source)
          : await _picker.pickVideo(source: source);
      if (file == null) return;

      final chatProvider =
          Provider.of<AppoinmentChatProvider>(context, listen: false);
      final appointmentProvider =
          Provider.of<AppointmentProvider>(context, listen: false);

      // Create a temporary message for display
      final tempMessage = AppoinmentsChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: _chatId!,
        senderId: appointmentProvider.currentUser!.uid,
        senderName: appointmentProvider.currentUser!.name,
        content: type == MessageType.image
            ? 'Uploading image...'
            : 'Uploading video...',
        type: type,
        timestamp: DateTime.now(),
        isRead: false,
      );

      setState(() {
        _pendingMessages.add(tempMessage);
      });

      final url = await chatProvider.uploadMedia(file.path, type);
      if (url != null && mounted) {
        final success = await chatProvider.sendMessage(
          chatId: _chatId!,
          senderId: appointmentProvider.currentUser!.uid,
          senderName: appointmentProvider.currentUser!.name,
          content: url,
          type: type,
        );
        if (success) {
          setState(() {
            _pendingMessages.remove(tempMessage);
          });
        } else {
          setState(() {
            _pendingMessages.remove(tempMessage);
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(chatProvider.error.isNotEmpty
                    ? chatProvider.error
                    : 'Failed to send media'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        setState(() {
          _pendingMessages.remove(tempMessage);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(chatProvider.error.isNotEmpty
                  ? chatProvider.error
                  : 'Failed to upload media'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _pendingMessages.removeWhere((msg) =>
            msg.id == DateTime.now().millisecondsSinceEpoch.toString());
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading media: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendTextMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final chatProvider =
        Provider.of<AppoinmentChatProvider>(context, listen: false);
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);

    // Create a temporary message for display
    final tempMessage = AppoinmentsChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: _chatId!,
      senderId: appointmentProvider.currentUser!.uid,
      senderName: appointmentProvider.currentUser!.name,
      content: _messageController.text.trim(),
      type: MessageType.text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _pendingMessages.add(tempMessage);
      _messageController.clear();
    });

    final success = await chatProvider.sendMessage(
      chatId: _chatId!,
      senderId: appointmentProvider.currentUser!.uid,
      senderName: appointmentProvider.currentUser!.name,
      content: tempMessage.content,
      type: MessageType.text,
    );

    if (success) {
      setState(() {
        _pendingMessages.remove(tempMessage);
      });
    } else {
      setState(() {
        _pendingMessages.remove(tempMessage);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(chatProvider.error.isNotEmpty
                ? chatProvider.error
                : 'Failed to send message'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showMediaListDialog(List<AppoinmentsChatModel> messages) {
    final mediaMessages = messages
        .where((msg) =>
            msg.type == MessageType.image || msg.type == MessageType.video)
        .toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      builder: (context) => Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Photos & Videos',
                    style: TextStyle(
                      fontSize: 18,
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
                child: mediaMessages.isEmpty
                    ? const Center(
                        child: Text(
                          'No photos or videos.',
                          style: TextStyle(color: blackColor),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: mediaMessages.length,
                        itemBuilder: (context, index) {
                          final message = mediaMessages[index];
                          return GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Viewing ${message.type == MessageType.image ? 'image' : 'video'}')),
                              );
                            },
                            child: message.type == MessageType.image
                                ? Image.network(
                                    message.content,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.network(
                                        message.content,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.play_circle_fill,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ],
                                  ),
                          );
                        },
                      ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final chatProvider = Provider.of<AppoinmentChatProvider>(context);

    if (_chatId == null) {
      return const Scaffold(
        backgroundColor: backgroundColor,
        body: Center(child: CircularProgressIndicator(color: themeColor)),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: themeColor,
          title: Text(
            appointmentProvider.currentUser?.userType == UserType.farmer
                ? appointmentProvider.currentAppointments
                    .firstWhere((app) => app.id == widget.appointmentId,
                        orElse: () => Appointment(
                              id: '',
                              doctorId: '',
                              farmerId: '',
                              doctorName: 'Doctor',
                              farmerName: '',
                              appointmentDate: DateTime.now(),
                              status: '',
                              createdAt: DateTime.now(),
                            ))
                    .doctorName
                : appointmentProvider.currentAppointments
                    .firstWhere((app) => app.id == widget.appointmentId,
                        orElse: () => Appointment(
                              id: '',
                              doctorId: '',
                              farmerId: '',
                              doctorName: '',
                              farmerName: 'Farmer',
                              appointmentDate: DateTime.now(),
                              status: '',
                              createdAt: DateTime.now(),
                            ))
                    .farmerName,
            style: const TextStyle(color: backgroundColor),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: backgroundColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              onPressed: () => makePhoneCall(context, '6303642297'),
              icon: const Icon(Icons.phone, color: backgroundColor),
            ),
            IconButton(
              onPressed: () => generateGoogleMeetLink(context),
              icon:
                  const Icon(Icons.video_call_outlined, color: backgroundColor),
            ),
            IconButton(
              icon: const Icon(Icons.photo_library, color: backgroundColor),
              onPressed: () => _showMediaListDialog(chatProvider.messages),
              tooltip: 'View Photos & Videos',
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: StreamBuilder<List<AppoinmentsChatModel>>(
                  stream: chatProvider.getMessagesStream(_chatId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator(color: themeColor));
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: const TextStyle(color: blackColor)),
                      );
                    }
                    final messages = snapshot.data ?? [];
                    final allMessages = [...messages, ..._pendingMessages];
                    allMessages
                        .sort((a, b) => b.timestamp.compareTo(a.timestamp));
                    return ListView.builder(
                      reverse: true,
                      itemCount: allMessages.length,
                      itemBuilder: (context, index) {
                        final message = allMessages[index];
                        final isMe = message.senderId ==
                            appointmentProvider.currentUser?.uid;
                        final isPending = _pendingMessages.contains(message);
                        if (!isMe && !message.isRead && !isPending) {
                          chatProvider.markMessageAsRead(_chatId!, message.id);
                        }
                        return _buildMessageBubble(message, isMe, isPending);
                      },
                    );
                  },
                ),
              ),
              _buildMessageInput(chatProvider),
            ],
          ),
          if (chatProvider.isUploadingMedia)
            const Positioned(
              top: 10,
              right: 10,
              child: CircularProgressIndicator(color: themeColor),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
      AppoinmentsChatModel message, bool isMe, bool isPending) {
    final DateFormat timeFormat = DateFormat('h:mm a');
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? themeColor.withOpacity(0.1) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Text(
                //   message.senderName,
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //     color: blackColor,
                //     fontSize: 12,
                //   ),
                // ),
                // const SizedBox(height: 4),
                if (message.type == MessageType.text)
                  Text(
                    message.content,
                    style: const TextStyle(color: blackColor),
                  ),
                if (message.type == MessageType.image && !isPending)
                  Image.network(
                    message.content,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                if (message.type == MessageType.image && isPending)
                  const Text(
                    'Uploading image...',
                    style: TextStyle(color: blackColor),
                  ),
                if (message.type == MessageType.video && !isPending)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        message.content,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Text(
                          'Failed to load video',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      const Icon(
                        Icons.play_circle_fill,
                        color: backgroundColor,
                        size: 50,
                      ),
                    ],
                  ),
                if (message.type == MessageType.video && isPending)
                  const Text(
                    'Uploading video...',
                    style: TextStyle(color: blackColor),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeFormat.format(message.timestamp),
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 10),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    if (isMe && message.isRead && !isPending)
                      const SizedBox(
                        width: 18,
                        height: 15,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Positioned(
                              right: 5,
                              child: Icon(Icons.check,
                                  size: 15, color: Colors.blue),
                            ),
                            Positioned(
                              right: 0,
                              child: Icon(Icons.check,
                                  size: 15, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (isPending)
              const Positioned(
                right: 0,
                bottom: 0,
                child: CircularProgressIndicator(
                  color: themeColor,
                  strokeWidth: 2,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(AppoinmentChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: themeColor),
            onPressed: chatProvider.isUploadingMedia
                ? null
                : () =>
                    _pickAndSendMedia(MessageType.image, ImageSource.camera),
            tooltip: 'Take Photo',
          ),
          IconButton(
            icon: const Icon(Icons.photo, color: themeColor),
            onPressed: chatProvider.isUploadingMedia
                ? null
                : () =>
                    _pickAndSendMedia(MessageType.image, ImageSource.gallery),
            tooltip: 'Pick Image',
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: themeColor),
            onPressed: chatProvider.isUploadingMedia
                ? null
                : () =>
                    _pickAndSendMedia(MessageType.video, ImageSource.gallery),
            tooltip: 'Pick Video',
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: backgroundColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: themeColor),
            onPressed: chatProvider.isLoading ? null : _sendTextMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
