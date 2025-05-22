// chat_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formatted_text/formatted_text.dart';
import 'package:gausampada/backend/models/message.dart';
import 'package:gausampada/backend/providers/ai_chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AiBreedChat extends StatefulWidget {
  const AiBreedChat({super.key});

  @override
  State<AiBreedChat> createState() => _AiBreedChatState();
}

class _AiBreedChatState extends State<AiBreedChat> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'AI Breed Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
        actions: [
          Tooltip(
            message: 'New Conversation',
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                Provider.of<BreedChatProvider>(context, listen: false)
                    .createNewChat();
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          // Subtle background pattern or gradient
          color: theme.scaffoldBackgroundColor,
          // image: const DecorationImage(
          //   image: AssetImage('assets/images/subtle_pattern.png'),
          //   opacity: 0.05,
          //   repeat: ImageRepeat.repeat,
          // ),
        ),
        child: Consumer<BreedChatProvider>(
          builder: (context, chatProvider, child) {
            // Scroll to bottom when messages change
            if (chatProvider.messages.isNotEmpty) {
              _scrollToBottom();
            }

            return Column(
              children: [
                // Messages list
                Expanded(
                  child: chatProvider.messages.isEmpty
                      ? _buildWelcomeScreen()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16.0),
                          itemCount: chatProvider.messages.length,
                          itemBuilder: (context, index) {
                            final message = chatProvider.messages[index];
                            return _MessageBubble(
                              message: message,
                              isFirstInSequence: _isFirstInSequence(
                                  chatProvider.messages, index),
                              isLastInSequence: _isLastInSequence(
                                  chatProvider.messages, index),
                            );
                          },
                        ),
                ),

                // Loading indicator
                if (chatProvider.isLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green[800],
                          radius: 16,
                          child: const Icon(
                            Icons.pets,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Thinking...",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green[800]!),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Input area
                _buildInputArea(chatProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isFirstInSequence(List<Message> messages, int index) {
    if (index == 0) return true;
    return messages[index].isUser != messages[index - 1].isUser;
  }

  bool _isLastInSequence(List<Message> messages, int index) {
    if (index == messages.length - 1) return true;
    return messages[index].isUser != messages[index + 1].isUser;
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pets,
                  size: 60,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to the Indian Cow Breeds Expert',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  // 'Start a conversation about Indian cow breeds. You can send text or images of cows for identification.',
                  AppLocalizations.of(context)!.breadAIDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                children: [
                  _buildSuggestionChip('Tell me about Andhra Pradesh cows'),
                  _buildSuggestionChip('Identify best milking breeds'),
                  _buildSuggestionChip('Indigenous cow benefits'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      avatar:
          Icon(Icons.chat_bubble_outline, size: 16, color: Colors.green[800]),
      label: Text(text),
      backgroundColor: Colors.green[50],
      onPressed: () {
        final provider = Provider.of<BreedChatProvider>(context, listen: false);
        provider.sendTextMessage(text);
      },
    );
  }

  Widget _buildInputArea(BreedChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Image button
          Container(
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Tooltip(
              message: 'Add Image',
              child: IconButton(
                icon: Icon(
                  Icons.add_photo_alternate,
                  color: Colors.green[800],
                ),
                onPressed: () {
                  _showImageSourceDialog(chatProvider);
                },
              ),
            ),
          ),
          // Text input
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Ask about Indian cow breeds...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty) {
                    chatProvider.sendTextMessage(text);
                    _textController.clear();
                  }
                },
              ),
            ),
          ),
          // Send button
          Container(
            decoration: BoxDecoration(
              color: Colors.green[800],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_textController.text.trim().isNotEmpty) {
                  chatProvider.sendTextMessage(_textController.text);
                  _textController.clear();
                  _focusNode.requestFocus();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog(BreedChatProvider chatProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Cow Image',
          style: TextStyle(
            color: Colors.green[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.green[800]),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                chatProvider.pickImageFromGallery();
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.green[800]),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                chatProvider.takePhoto();
              },
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isFirstInSequence;
  final bool isLastInSequence;

  const _MessageBubble({
    required this.message,
    required this.isFirstInSequence,
    required this.isLastInSequence,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.only(
        top: isFirstInSequence ? 16.0 : 4.0,
        bottom: isLastInSequence ? 16.0 : 4.0,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar for AI messages
          if (!isUser && isFirstInSequence)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.green[800],
                radius: 16,
                child: const Icon(
                  Icons.pets,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            )
          else if (!isUser && !isFirstInSequence)
            const SizedBox(width: 40), // Space for alignment

          // Message content
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[600] : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      isUser || !isFirstInSequence ? 16.0 : 4.0),
                  topRight: Radius.circular(
                      !isUser || !isFirstInSequence ? 16.0 : 4.0),
                  bottomLeft: Radius.circular(isUser ? 16.0 : 4.0),
                  bottomRight: Radius.circular(!isUser ? 16.0 : 4.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display image if available
                    if (message.imageUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.memory(
                            base64Decode(message.imageUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    // Message text
                    FormattedText(
                      message.content,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                      // linkStyle: TextStyle(
                      //   color: isUser ? Colors.white : Colors.blue[700],
                      //   decoration: TextDecoration.underline,
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // User avatar (optional)
          if (isUser && isFirstInSequence)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue[600],
                radius: 16,
                child: const Icon(
                  Icons.person,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            )
          else if (isUser && !isFirstInSequence)
            const SizedBox(width: 40), // Space for alignment
        ],
      ),
    );
  }
}
