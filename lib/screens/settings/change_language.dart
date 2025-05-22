import 'package:flutter/material.dart';
import 'package:gausampada/backend/providers/locale_provider.dart';
import 'package:gausampada/const/colors.dart';
import 'package:gausampada/const/languages.dart';
import 'package:gausampada/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  Locale? selectedLocale;

  // Green theme colors
  final Color? selectGreen = Colors.green[400];

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.translate,
              size: 24,
              color: Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.select_language,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: Languages.languages_list.length,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) {
                    final locale = L10n.locales[index];
                    final isCurrentlySelected = selectedLocale?.languageCode ==
                            locale.languageCode ||
                        (selectedLocale == null &&
                            currentLocale.languageCode == locale.languageCode);
                    return LanguageOption(
                      title: Languages.languagesTitles[index],
                      subtitle: Languages.languages_list[index],
                      isSelected: isCurrentlySelected,
                      onTap: () {
                        setState(() {
                          selectedLocale = locale;
                        });
                      },
                      flagEmoji: Languages.languageFirstLetter[index],
                      selectColor: selectGreen!,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: selectedLocale != null
                  ? () {
                      localeProvider.setLocale(selectedLocale!);
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedLocale != null ? selectGreen : Colors.grey[300],
                foregroundColor: Colors.white,
                elevation: selectedLocale != null ? 2 : 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: backgroundColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Languages.getApplyLanguageText(
                        selectedLocale?.languageCode ??
                            currentLocale.languageCode),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final String flagEmoji;
  final Color selectColor;

  const LanguageOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.flagEmoji,
    required this.selectColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isSelected ? selectColor.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? selectColor : Colors.grey.withOpacity(0.2),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor:
                    isSelected ? selectColor : Colors.grey.shade200,
                child: Text(
                  flagEmoji,
                  style: TextStyle(
                    fontSize: 18,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
              title: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? selectColor : Colors.black87,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isSelected
                      ? selectColor.withOpacity(0.7)
                      : Colors.black54,
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: selectColor,
                      size: 24,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
