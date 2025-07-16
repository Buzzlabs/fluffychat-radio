import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';

class LoginScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final bool enforceMobileMode;

  const LoginScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.enforceMobileMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isMobileMode =
        enforceMobileMode || !FluffyThemes.isColumnMode(context);
    if (isMobileMode) {
      return Scaffold(
        key: const Key('LoginScaffold'),
        appBar: appBar,
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SafeArea(
              child: body,
            ),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainerLow,
            theme.colorScheme.surfaceContainer,
            theme.colorScheme.surfaceContainerHighest,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Material(
            color: theme.colorScheme.tertiary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
              side: BorderSide(
                color: theme.colorScheme.secondary,
                width: 2,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            elevation: theme.appBarTheme.scrolledUnderElevation ?? 4,
            shadowColor: theme.appBarTheme.shadowColor,
            child: ConstrainedBox(
              constraints: isMobileMode
                  ? const BoxConstraints()
                  : const BoxConstraints(maxWidth: 480, maxHeight: 680),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                key: const Key('LoginScaffold'),
                appBar: appBar,
                body: SafeArea(child: body),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class _PrivacyButtons extends StatelessWidget {
//   final MainAxisAlignment mainAxisAlignment;
//   const _PrivacyButtons({required this.mainAxisAlignment});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final shadowTextStyle = TextStyle(color: theme.colorScheme.secondary);
//     return SizedBox(
//       height: 64,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: mainAxisAlignment,
//           children: [
//             TextButton(
//               onPressed: () => launchUrlString(AppConfig.website),
//               child: Text(
//                 L10n.of(context).website,
//                 style: shadowTextStyle,
//               ),
//             ),
//             TextButton(
//               onPressed: () => launchUrlString(AppConfig.supportUrl),
//               child: Text(
//                 L10n.of(context).help,
//                 style: shadowTextStyle,
//               ),
//             ),
//             TextButton(
//               onPressed: () => launchUrlString(AppConfig.privacyUrl),
//               child: Text(
//                 L10n.of(context).privacy,
//                 style: shadowTextStyle,
//               ),
//             ),
//             TextButton(
//               onPressed: () => PlatformInfos.showAboutInfo(context),
//               child: Text(
//                 L10n.of(context).about,
//                 style: shadowTextStyle,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
