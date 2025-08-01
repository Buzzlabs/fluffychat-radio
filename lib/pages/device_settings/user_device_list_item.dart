import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import '../../utils/date_time_extension.dart';
import '../../utils/matrix_sdk_extensions/device_extension.dart';
import '../../widgets/matrix.dart';

enum UserDeviceListItemAction {
  rename,
  remove,
  verify,
  block,
  unblock,
}

class UserDeviceListItem extends StatelessWidget {
  final Device userDevice;
  final void Function(Device) remove;
  final void Function(Device) rename;
  final void Function(Device) verify;
  final void Function(Device) block;
  final void Function(Device) unblock;

  const UserDeviceListItem(
    this.userDevice, {
    required this.remove,
    required this.rename,
    required this.verify,
    required this.block,
    required this.unblock,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final keys = client.userDeviceKeys[Matrix.of(context).client.userID]
        ?.deviceKeys[userDevice.deviceId];
    final isOwnDevice = userDevice.deviceId == client.deviceID;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          onTap: () async {
            final action = await showModalActionPopup<UserDeviceListItemAction>(
              context: context,
              title: '${userDevice.displayName} (${userDevice.deviceId})',
              cancelLabel: L10n.of(context).cancel,
              actions: [
                AdaptiveModalAction(
                  value: UserDeviceListItemAction.rename,
                  icon: const Icon(Icons.edit_outlined),
                  label: L10n.of(context).changeDeviceName,
                ),
                if (!isOwnDevice && keys != null) ...{
                  AdaptiveModalAction(
                    value: UserDeviceListItemAction.verify,
                    icon: const Icon(Icons.verified_outlined),
                    label: L10n.of(context).verifyStart,
                  ),
                  if (!keys.blocked)
                    AdaptiveModalAction(
                      value: UserDeviceListItemAction.block,
                      icon: const Icon(Icons.block_outlined),
                      label: L10n.of(context).blockDevice,
                      isDestructive: true,
                    ),
                  if (keys.blocked)
                    AdaptiveModalAction(
                      value: UserDeviceListItemAction.unblock,
                      icon: const Icon(Icons.block),
                      label: L10n.of(context).unblockDevice,
                      isDestructive: true,
                    ),
                },
                if (!isOwnDevice)
                  AdaptiveModalAction(
                    value: UserDeviceListItemAction.remove,
                    icon: const Icon(Icons.delete_outlined),
                    label: L10n.of(context).delete,
                    isDestructive: true,
                  ),
              ],
            );
            if (action == null) return;
            switch (action) {
              case UserDeviceListItemAction.rename:
                rename(userDevice);
                break;
              case UserDeviceListItemAction.remove:
                remove(userDevice);
                break;
              case UserDeviceListItemAction.verify:
                verify(userDevice);
                break;
              case UserDeviceListItemAction.block:
                block(userDevice);
                break;
              case UserDeviceListItemAction.unblock:
                unblock(userDevice);
                break;
            }
          },
          leading: CircleAvatar(
            foregroundColor: Colors.white,
            backgroundColor: keys == null
                ? theme.colorScheme.onSurface
                : keys.blocked
                    ? theme.colorScheme.error
                    : keys.verified
                        ? Colors.green
                        : theme.colorScheme.secondary,
            child: Icon(userDevice.icon),
          ),
          title: Text(
            userDevice.displayname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            L10n.of(context).lastActiveAgo(
              DateTime.fromMillisecondsSinceEpoch(userDevice.lastSeenTs ?? 0)
                  .localizedTimeShort(context),
            ),
            style: const TextStyle(fontWeight: FontWeight.w300),
          ),
          trailing: keys == null
              ? null
              : Text(
                  keys.blocked
                      ? L10n.of(context).blocked
                      : keys.verified
                          ? L10n.of(context).verified
                          : L10n.of(context).unverified,
                  style: TextStyle(
                    color: keys.blocked
                        ? theme.colorScheme.error
                        : keys.verified
                            ? Colors.green
                            : Theme.of(context).colorScheme.secondary,
                  ),
                ),
        ),
      ),
    );
  }
}
