import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'section_card.dart';

/// Clean and normalize phone numbers (e.g. Bangladesh numbers: +88017... -> 017...).
String cleanPhoneNumber(String raw) {
  var s = raw.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
  if (s.startsWith('+880')) {
    s = '0${s.substring(4)}';
  } else if (s.startsWith('880') && s.length >= 13) {
    s = '0${s.substring(3)}';
  } else if (s.startsWith('+88')) {
    s = s.substring(3);
  }
  s = s.replaceAll(RegExp(r'\D'), '');
  if (s.startsWith('8801') && s.length == 13) {
    s = s.substring(2);
  }
  return s;
}

/// Helper to pick a contact using the native device picker.
Future<String?> pickContactFromDevice() async {
  try {
    var hasPermission =
        await FlutterContacts.permissions.has(PermissionType.read);
    if (!hasPermission) {
      final status =
          await FlutterContacts.permissions.request(PermissionType.read);
      hasPermission = (status == PermissionStatus.granted ||
          status == PermissionStatus.limited);
    }

    if (!hasPermission) return null;

    final contact = await FlutterContacts.native.showPicker(
      properties: {ContactProperty.phone},
    );
    if (contact != null && contact.phones.isNotEmpty) {
      final cleaned = cleanPhoneNumber(contact.phones.first.number);
      if (cleaned.isNotEmpty) return cleaned;
    }
  } catch (e) {
    debugPrint('Error opening native contact picker: $e');
  }
  return null;
}

class ContactItem {
  final String name;
  final String phoneNumber;
  final String initial;

  const ContactItem({
    required this.name,
    required this.phoneNumber,
    required this.initial,
  });
}

class ContactsList extends StatefulWidget {
  final ValueChanged<String> onContactSelected;
  final String title;

  const ContactsList({
    required this.onContactSelected,
    this.title = 'Contacts',
    super.key,
  });

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<ContactItem> _contacts = _mockContacts;
  bool _isLoading = false;
  bool _permissionGranted = false;

  static const List<ContactItem> _mockContacts = [
    ContactItem(name: 'Mom', phoneNumber: '01712345678', initial: 'M'),
    ContactItem(name: 'Dad', phoneNumber: '01812345678', initial: 'D'),
    ContactItem(name: 'Abir Hasan', phoneNumber: '01912345679', initial: 'A'),
    ContactItem(name: 'Fahim Ahmed', phoneNumber: '01512345680', initial: 'F'),
    ContactItem(name: 'Karim Rahman', phoneNumber: '01612345681', initial: 'K'),
    ContactItem(name: 'Nusrat Jahan', phoneNumber: '01312345682', initial: 'N'),
    ContactItem(name: 'Sadia Islam', phoneNumber: '01412345683', initial: 'S'),
  ];

  @override
  void initState() {
    super.initState();
    _loadDeviceContacts(requestPermission: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDeviceContacts({bool requestPermission = true}) async {
    if (requestPermission) {
      setState(() => _isLoading = true);
    }
    try {
      var hasPermission =
          await FlutterContacts.permissions.has(PermissionType.read);
      if (!hasPermission && requestPermission) {
        final status =
            await FlutterContacts.permissions.request(PermissionType.read);
        hasPermission = (status == PermissionStatus.granted ||
            status == PermissionStatus.limited);
      }

      if (hasPermission) {
        final deviceContacts = await FlutterContacts.getAll(
          properties: {ContactProperty.phone},
        );

        final items = <ContactItem>[];
        final seen = <String>{};

        for (final contact in deviceContacts) {
          final displayName = contact.displayName?.trim() ?? '';
          for (final phone in contact.phones) {
            final cleaned = cleanPhoneNumber(phone.number);
            if (cleaned.isNotEmpty && !seen.contains(cleaned)) {
              seen.add(cleaned);
              final initial = displayName.isNotEmpty
                  ? displayName[0].toUpperCase()
                  : '#';
              items.add(ContactItem(
                name: displayName.isNotEmpty ? displayName : cleaned,
                phoneNumber: cleaned,
                initial: initial,
              ));
            }
          }
        }

        if (mounted) {
          setState(() {
            _permissionGranted = true;
            _contacts = items.isNotEmpty ? items : _mockContacts;
            _isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('ContactsList: error loading device contacts: $e');
    }

    if (mounted) {
      setState(() {
        _permissionGranted = false;
        _contacts = _mockContacts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredContacts = _contacts.where((contact) {
      final nameMatch =
          contact.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final phoneMatch = contact.phoneNumber.contains(_searchQuery);
      return nameMatch || phoneMatch;
    }).toList();

    const maxItems = 50;
    final displayedContacts = filteredContacts.take(maxItems).toList();

    return SectionCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: isDark
                      ? AppTypography.sectionTitle.copyWith(color: Colors.white)
                      : AppTypography.sectionTitle,
                ),
                if (!_permissionGranted)
                  TextButton.icon(
                    onPressed: () =>
                        _loadDeviceContacts(requestPermission: true),
                    icon: const Icon(Icons.sync_rounded, size: 16),
                    label: const Text(
                      'Load Phone Contacts',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark ? AppColors.cyberBlue : AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 0,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                else
                  Text(
                    '${_contacts.length} contacts',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contact or number...',
                hintStyle: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textTertiary),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                filled: true,
                fillColor: AppColors.field,
              ),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (displayedContacts.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Text(
                  'No contacts found',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedContacts.length,
              separatorBuilder: (context, index) => Divider(
                color: isDark ? Colors.white.withOpacity(0.1) : AppColors.border,
                height: 1,
                indent: 70,
              ),
              itemBuilder: (context, index) {
                final contact = displayedContacts[index];
                return ListTile(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.onContactSelected(contact.phoneNumber);
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  leading: CircleAvatar(
                    backgroundColor: isDark
                        ? AppColors.cyberBlue.withOpacity(0.2)
                        : AppColors.primarySoft,
                    radius: 20,
                    child: Text(
                      contact.initial,
                      style: TextStyle(
                        color: isDark ? AppColors.cyberBlue : AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    contact.phoneNumber,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: isDark ? Colors.white38 : AppColors.textTertiary,
                  ),
                );
              },
            ),
            if (filteredContacts.length > maxItems)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Center(
                  child: Text(
                    'Showing first $maxItems of ${filteredContacts.length} contacts. Search above for more.',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white54 : AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
