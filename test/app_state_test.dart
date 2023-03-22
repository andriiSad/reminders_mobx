import 'package:flutter_test/flutter_test.dart';
import 'package:reminders_mobx/state/app_state.dart';

import 'mocks/mock_auth_service.dart';
import 'mocks/mock_image_upload_service.dart';
import 'mocks/mock_reminders_service.dart';

void main() {
  late AppState appState;
  setUp(() {
    appState = AppState(
      remindersService: MockRemindersService(),
      authService: MockAuthService(),
      imageUploadService: MockImageUploadService(),
    );
  });

  test('Initial State', () {
    expect(
      appState.currentScreen,
      AppScreen.login,
    );
    appState.authError.expectNull();
    appState.isLoading.expectFalse();
    appState.reminders.isEmpty.expectTrue();
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

    appState.reminders.contains(mockReminder1).expectTrue();

    appState.reminders.contains(mockReminder2).expectTrue();
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

    appState.reminders
        .firstWhere((reminder) => reminder.id == mockReminder1Id)
        .isDone
        .expectFalse();

    appState.reminders
        .firstWhere((reminder) => reminder.id == mockReminder2Id)
        .isDone
        .expectTrue();
  });
  test('Creating reminders', () async {
    await appState.initialize();
    const text = 'text';
    final didCreate = await appState.createReminder(text);

    didCreate.expectTrue();

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

    testReminder.isDone.expectFalse();
  });
  test('Deleting reminders', () async {
    await appState.initialize();
    var count = appState.reminders.length;
    var reminder = appState.reminders.first;

    var deleted = await appState.deleteReminder(reminder);

    deleted.expectTrue();

    expect(
      appState.reminders.length,
      count - 1,
    );

    reminder = appState.reminders.first;
    count = appState.reminders.length;
    deleted = await appState.deleteReminder(mockReminder2);

    deleted.expectTrue();

    expect(
      appState.reminders.length,
      count - 1,
    );
  });

  test('Deleting all reminders', () async {
    await appState.initialize();
    final didDeleteReminders = await appState.deleteAccount();

    didDeleteReminders.expectTrue();

    appState.reminders.isEmpty.expectTrue();

    expect(
      appState.currentScreen,
      AppScreen.login,
    );
  });
  test('Log Out', () async {
    await appState.initialize();

    await appState.logOut();

    appState.reminders.isEmpty.expectTrue();

    expect(
      appState.currentScreen,
      AppScreen.login,
    );
  });

  test('Uploading image for reminder', () async {
    await appState.initialize();

    final reminder = appState.reminders.firstWhere(
      (element) => element.id == mockReminder1Id,
    );
    reminder.hasImage.expectFalse();
    reminder.imageData.expectNull();

    //fake uplode an image for this reminder

    final couldUploadImage = await appState.upload(
      filePath: 'dummy_path',
      forReminderId: reminder.id,
    );
    couldUploadImage.expectTrue();
    reminder.hasImage.expectTrue();
    reminder.imageData.expectNull();

    final imageData = await appState.getReminderImage(
      reminderId: reminder.id,
    );

    imageData.expectNotNull();
    imageData!.isEqualTo(mockReminder1ImageData).expectTrue();
  });
}

extension Expectations on Object? {
  void expectNull() => expect(this, isNull);
  void expectNotNull() => expect(this, isNotNull);
}

extension BoolExpectations on bool {
  void expectTrue() => expect(this, true);
  void expectFalse() => expect(this, false);
}

extension Comparison<E> on List<E> {
  bool isEqualTo(List<E> other) {
    if (identical(this, other)) {
      return true;
    }
    if (length != other.length) {
      return false;
    }
    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}
