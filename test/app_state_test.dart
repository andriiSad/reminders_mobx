import 'package:flutter_test/flutter_test.dart';
import 'package:reminders_mobx/state/app_state.dart';

import 'mocks/mock_auth_provider.dart';
import 'mocks/mock_reminders_provider.dart';

void main() {
  late AppState appState;
  setUp(() {
    appState = AppState(
      remindersProvider: MockRemindersProvider(),
      authProvider: MockAuthProvider(),
    );
  });

  test('Initial State', () {
    expect(
      appState.currentScreen,
      AppScreen.login,
    );
    expect(
      appState.authError,
      null,
    );
    expect(
      appState.isLoading,
      false,
    );
    expect(
      appState.reminders.isEmpty,
      true,
    );
  });

  test('Going to screens', () {
    appState.goTo(
      AppScreen.register,
    );

    expect(
      appState.currentScreen,
      AppScreen.register,
    );
    appState.goTo(
      AppScreen.reminders,
    );

    expect(
      appState.currentScreen,
      AppScreen.reminders,
    );
    appState.goTo(
      AppScreen.login,
    );

    expect(
      appState.currentScreen,
      AppScreen.login,
    );
  });

  test('Initializing the app state', () async {
    await appState.initialize();
    expect(
      appState.currentScreen,
      AppScreen.reminders,
    );
    expect(
      appState.reminders.length,
      mockReminders.length,
    );
    expect(
      appState.reminders.contains(mockReminder1),
      true,
    );
    expect(
      appState.reminders.contains(mockReminder2),
      true,
    );
  });
  test('Modifying reminders', () async {
    await appState.initialize();

    await appState.modifyReminder(
      reminderId: mockReminder1Id,
      isDone: false,
    );

    await appState.modifyReminder(
      reminderId: mockReminder2Id,
      isDone: true,
    );

    expect(
      appState.reminders
          .firstWhere((reminder) => reminder.id == mockReminder1Id)
          .isDone,
      false,
    );

    expect(
      appState.reminders
          .firstWhere((reminder) => reminder.id == mockReminder2Id)
          .isDone,
      true,
    );
  });
  test('Creating reminders', () async {
    await appState.initialize();
    const text = 'text';
    final didCreate = await appState.createReminder(text);

    expect(
      didCreate,
      true,
    );

    expect(
      appState.reminders.length,
      mockReminders.length + 1,
    );

    final testReminder = appState.reminders.firstWhere(
      (element) => element.id == mockReminderId,
    );

    expect(
      testReminder.text,
      text,
    );

    expect(
      testReminder.isDone,
      false,
    );
  });
  test('Deleting reminders', () async {
    await appState.initialize();
    var count = appState.reminders.length;
    var reminder = appState.reminders.first;

    var deleted = await appState.deleteReminder(reminder);

    expect(
      deleted,
      true,
    );

    expect(
      appState.reminders.length,
      count - 1,
    );

    reminder = appState.reminders.first;
    count = appState.reminders.length;
    deleted = await appState.deleteReminder(mockReminder2);

    expect(
      deleted,
      true,
    );

    expect(
      appState.reminders.length,
      count - 1,
    );
  });

  test('Deleting all reminders', () async {
    await appState.initialize();
    final didDeleteReminders = await appState.deleteAccount();

    expect(
      didDeleteReminders,
      true,
    );

    expect(
      appState.reminders.isEmpty,
      true,
    );

    expect(
      appState.currentScreen,
      AppScreen.login,
    );
  });
  test('Log Out', () async {
    await appState.initialize();

    await appState.logOut();

    expect(
      appState.reminders.isEmpty,
      true,
    );

    expect(
      appState.currentScreen,
      AppScreen.login,
    );
  });
}
