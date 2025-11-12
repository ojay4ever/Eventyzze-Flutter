import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_theme.dart';

class UserAgreementScreen extends StatefulWidget {
  const UserAgreementScreen({super.key});

  @override
  State<UserAgreementScreen> createState() => _UserAgreementScreenState();
}

class _UserAgreementScreenState extends State<UserAgreementScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = AppTheme.kButtonColor;
    final secondary = theme.colorScheme.secondary;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primary.withValues(alpha: 0.95),
                  secondary.withValues(alpha: 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 8),
              _appBar(context),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 18,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      radius: const Radius.circular(12),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.description_outlined,
                                    color: theme.colorScheme.onPrimaryContainer,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Terms & Conditions',
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Last updated: Aug 20, 2025',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _sectionTitle(context, '1. Acceptance of Terms'),
                            _para(
                              context,
                              'By accessing or using this application, you agree to be bound by these Terms & Conditions. '
                                  'If you disagree with any part of the terms, you may not access the service.',
                            ),

                            _sectionTitle(context, '2. Eligibility'),
                            _para(
                              context,
                              'You must be at least 13 years old (or the age of digital consent in your country) to use the app. '
                                  'By using the app, you represent that you meet this requirement.',
                            ),

                            _sectionTitle(context, '3. User Accounts'),
                            _bullet(
                              context,
                              'Provide accurate, current, and complete information.',
                            ),
                            _bullet(
                              context,
                              'Maintain the security of your account credentials.',
                            ),
                            _bullet(
                              context,
                              'Promptly notify us of any unauthorized use.',
                            ),

                            _sectionTitle(context, '4. Content & Conduct'),
                            _para(
                              context,
                              'You are responsible for the content you share. Do not upload content that is illegal, harmful, harassing, '
                                  'infringing, or otherwise objectionable. We may remove content that violates these terms.',
                            ),

                            _sectionTitle(
                              context,
                              '5. Purchases & Subscriptions',
                            ),
                            _para(
                              context,
                              'Some features may require payment. All purchases are final unless required by law. '
                                  'Subscriptions renew automatically unless canceled before the renewal date.',
                            ),

                            _sectionTitle(context, '6. Privacy'),
                            _para(
                              context,
                              'Your use of the app is also governed by our Privacy Policy, which explains how we collect, use, and share information.',
                            ),
                            _sectionTitle(
                              context,
                              '7. Limitation of Liability',
                            ),
                            _para(
                              context,
                              'To the maximum extent permitted by law, the app and its owners are not liable for any indirect, incidental, special, '
                                  'consequential, or punitive damages, or any loss of profits or revenues.',
                            ),
                            _sectionTitle(context, '8. Changes to Terms'),
                            _para(
                              context,
                              'We may update these terms from time to time. Continued use of the app after changes become effective constitutes acceptance.',
                            ),
                            _sectionTitle(context, '9. Contact'),
                            _para(
                              context,
                              'Questions about these Terms? Reach out via the Help section or our support email.',
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: CheckboxListTile(
                                value: _accepted,
                                onChanged: (v) =>
                                    setState(() => _accepted = v ?? false),
                                controlAffinity:
                                ListTileControlAffinity.leading,
                                title: Text(
                                  'I have read and agree to the Terms & Conditions',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: () async {
                                      SystemNavigator.pop();
                                    },
                                    child: const Text('Decline'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: _accepted
                                        ? () {
                                      Navigator.of(context).pop(true);
                                    }
                                        : null,
                                    child: const Text('Accept & Continue'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Terms & Conditions',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _para(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          height: 1.45,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget _bullet(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.45,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
