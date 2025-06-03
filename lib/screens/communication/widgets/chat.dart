import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';
import 'package:flutter/material.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/backend/models/appoinments_chat_model.dart';
import 'package:gausampada/backend/models/user_model.dart';
import 'package:gausampada/backend/providers/appoinment_chat_provider.dart';
import 'package:gausampada/backend/providers/booking_provider.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/const/new_image_picker.dart';
import 'package:gausampada/const/video_picker.dart';
import 'package:gausampada/screens/communication/widgets/call.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class AppointmentChatScreen extends StatefulWidget {
  final String appointmentId;

  const AppointmentChatScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentChatScreen> createState() => _AppointmentChatScreenState();
}

class _AppointmentChatScreenState extends State<AppointmentChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppoinmentChatProvider>(context, listen: false)
          .loadMessages(widget.appointmentId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number not available")),
      );
      return;
    }
    var status = await Permission.phone.request();
    if (status.isGranted) {
      bool? result = await DirectCaller().makePhoneCall(phoneNumber);
      if (result != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Failed to make the call. Please try again.")),
        );
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied. Cannot make a call.")),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Permission permanently denied. Enable in settings."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointment = Provider.of<AppointmentProvider>(context)
        .currentAppointments
        .firstWhere((a) => a.id == widget.appointmentId);
    final user = Provider.of<AppointmentProvider>(context).currentUser!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          user.userType == UserType.farmer
              ? appointment.doctorName
              : appointment.farmerName,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () async {
              if (mounted) {
                final phoneNumber = user.userType == UserType.farmer
                    ? '6303642297'
                    : '8125150264';
                await _makePhoneCall(context, phoneNumber);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {
              if (mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AppooinmentCallScreen(
                        appointmentId: widget.appointmentId,
                        callType: 'video',
                      ),
                    ),
                  );
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<AppoinmentsChatModel>>(
              stream: Provider.of<AppoinmentChatProvider>(context)
                  .getMessagesStream(widget.appointmentId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: themeColor),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: blackColor),
                    ),
                  );
                }

                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: blackColor),
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ChatBubble(
                      message: message,
                      isMe: message.senderId == user.uid,
                      onMessageRead: () {
                        if (!message.isRead && message.senderId != user.uid) {
                          Provider.of<AppoinmentChatProvider>(context,
                                  listen: false)
                              .markMessageAsRead(
                                  widget.appointmentId, message.id);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(context, user),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, UserModel user) {
    return Consumer<AppoinmentChatProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey[100],
          child: Row(
            children: [
              ImagePickerWidget(
                onImagePicked: (file) =>
                    _handleMediaPicked(file, context, user, MessageType.image),
              ),
              VideoPickerWidget(
                onVideoPicked: (file) =>
                    _handleMediaPicked(file, context, user, MessageType.video),
              ),
              IconButton(
                icon: Icon(Icons.mic, color: themeColor),
                onPressed: () =>
                    _handleMediaPicked(null, context, user, MessageType.audio),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    if (provider.isUploadingMedia)
                      const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: themeColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: themeColor),
                onPressed: provider.isUploadingMedia
                    ? null // Disable send button during upload
                    : () => _sendMessage(context, user, MessageType.text),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleMediaPicked(File? file, BuildContext context,
      UserModel user, MessageType type) async {
    final provider =
        Provider.of<AppoinmentChatProvider>(context, listen: false);
    if (file == null && type != MessageType.audio) return;

    if (file != null) {
      final url = await provider.uploadMedia(file.path, type);
      if (url != null) {
        await provider.sendMessage(
          chatId: widget.appointmentId,
          senderId: user.uid,
          senderName: user.name,
          content: url,
          type: type,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio recording not implemented')),
      );
    }
  }

  Future<void> _sendMessage(
      BuildContext context, UserModel user, MessageType type) async {
    final provider =
        Provider.of<AppoinmentChatProvider>(context, listen: false);
    if (_messageController.text.isEmpty) return;

    final success = await provider.sendMessage(
      chatId: widget.appointmentId,
      senderId: user.uid,
      senderName: user.name,
      content: _messageController.text,
      type: MessageType.text,
    );

    if (success) {
      _messageController.clear();
    }
  }
}

class ChatBubble extends StatelessWidget {
  final AppoinmentsChatModel message;
  final bool isMe;
  final VoidCallback onMessageRead;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.onMessageRead,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onMessageRead());

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? themeColor.withOpacity(0.1) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.type == MessageType.text)
              Text(
                message.content,
                style: const TextStyle(color: blackColor),
              ),
            if (message.type == MessageType.image)
              Image.network(
                message.content,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator(color: themeColor);
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, color: Colors.red),
              ),
            if (message.type == MessageType.video)
              Text('Video: ${message.content}'), // Placeholder for video player
            if (message.type == MessageType.audio)
              Text('Audio: ${message.content}'), // Placeholder for audio player
            const SizedBox(height: 4),
            Text(
              DateFormat('h:mm a').format(message.timestamp),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            if (isMe)
              Icon(
                Icons.done_all,
                size: 16,
                color: message.isRead ? Colors.blue : Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
