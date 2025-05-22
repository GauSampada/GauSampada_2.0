import 'package:gausampada/backend/providers/ai_chat_provider.dart';
import 'package:gausampada/backend/providers/ai_provider.dart';
import 'package:gausampada/backend/providers/booking_provider.dart';
import 'package:gausampada/backend/providers/locale_provider.dart';
import 'package:gausampada/backend/providers/user_provider.dart';
import 'package:gausampada/const/image_picker_.dart';
import 'package:gausampada/screens/chat_bot/ai_assistance.dart';
import 'package:gausampada/screens/market/market_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => AiProvider()),
    ChangeNotifierProvider(create: (_) => ImagePickerService()),
    ChangeNotifierProvider(create: (_) => ChatProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => BreedChatProvider()),
    ChangeNotifierProvider(create: (_) => AppointmentProvider()),
  ];
}
