import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminders_mobx/state/app_state.dart';

import '../dialogs/delete_account_dialog.dart';
import '../dialogs/logout_dialog.dart';

enum MenuAction {
  logout,
  deleteAccount,
}

class MainMenuPopupMenuButton extends StatelessWidget {
  const MainMenuPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogOut = await showLogOutDialog(context);
            if (shouldLogOut) {
              if (context.mounted) {
                context.read<AppState>().logOut();
              }
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context);
            if (shouldDeleteAccount) {
              if (context.mounted) {
                context.read<AppState>().deleteAccount();
              }
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: MenuAction.logout,
            child: Text('Log out'),
          ),
          const PopupMenuItem(
            value: MenuAction.deleteAccount,
            child: Text('Delete account'),
          ),
        ];
      },
    );
  }
}
