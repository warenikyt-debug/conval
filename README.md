# ЛР № 2 «Конвертер валют»

«КОНВАЛ» — Flutter-приложение для перевода сумм между EUR, RUB, USD, THB и VND. Чтобы запустить проект после клонирования, открой папку с `pubspec.yaml` и выполни команды ниже.

## Установка на Windows

1. Установи Git for Windows. Скачай Flutter SDK 3.47.7 stable с Dart 3.13.5 для архитектуры ноутбука. Это версия, на которой проверена сборка. Распакуй SDK в доступную для записи папку, например `C:\dev\flutter`, добавь `C:\dev\flutter\bin` в пользовательский `Path` и открой новый PowerShell. Dart входит в Flutter SDK. [Установка Flutter](https://docs.flutter.dev/install/manual) · [Архив версий Flutter](https://docs.flutter.dev/install/archive)
2. Установи Android Studio. В **SDK Manager** выбери Android SDK Platform 36, Android SDK Build-Tools 36.0.0, Android SDK Platform-Tools, Android SDK Command-line Tools и NDK (Side by side) 28.2.13676358. Для виртуального устройства добавь Android Emulator и образ API 36. Для Android Studio можно также включить плагины Flutter и Dart. [Настройка Android для Flutter](https://docs.flutter.dev/platform-integration/android/setup)
3. Для Gradle используй встроенную Java (JBR) из Android Studio. Проверенная конфигурация использовала JBR 25, а минимальная версия для Android Gradle Plugin 9.1 — JDK 17. Gradle 9.3.1 загрузится через включённый в проект Gradle Wrapper. [Совместимость Android Gradle Plugin 9.1](https://developer.android.com/build/releases/agp-9-1-0-release-notes#compatibility)
4. Выполни команды ниже. В выводе `flutter doctor -v` проверь Flutter, Android toolchain, пути к SDK и Java. Если Flutter видит другой Android SDK или JDK, укажи фактический путь на этом ноутбуке с помощью `flutter config --android-sdk "путь к SDK"` или `flutter config --jdk-dir "путь к JDK"`.

```powershell
flutter --version
flutter doctor --android-licenses
flutter doctor -v
```

## Первый запуск

Открой PowerShell в папке проекта. В Android Studio запусти эмулятор из **Device Manager** или подключи телефон по USB, включи USB-отладку и подтверди подключение на телефоне. Для телефона нужен Android 7.0 (API 24) или новее.

```powershell
flutter pub get --enforce-lockfile
flutter devices
flutter run -d ID_УСТРОЙСТВА
```

Подставь идентификатор из `flutter devices`. Для сборки debug APK без телефона или эмулятора выполни `flutter build apk --debug --no-pub`. APK появится в `build/app/outputs/flutter-apk/app-debug.apk`. На Windows интерфейс также можно открыть командой `flutter run -d edge`, если Edge есть в списке устройств.

При сборке Flutter создаст `android/local.properties` с путями нового ноутбука. Для скачивания зависимостей и загрузки курсов нужен интернет. Приложение обращается напрямую к открытому API.

## Где продолжать разработку

| Файл | Что в нём |
| --- | --- |
| `lib/main.dart` | Экран, выбор валют, кнопки `SWAP` и `КОН`, индикатор загрузки, конвертация и история |
| `lib/services/api.dart` | HTTP GET к `https://open.er-api.com/v6/latest/EUR` с тайм-аутом 10 секунд |
| `lib/services/models/Now_price.dart` | Модель `NowPrice` и разбор полей `base_code`, `rates` и `time_last_update_utc` |
| `lib/themes.dart` | Тема Flutter |
| `pubspec.yaml`, `pubspec.lock` | Ограничение Dart `^3.13.5` и зафиксированные версии зависимостей, включая `http` |

Курсы в ответе API даны относительно EUR. Формула пересчёта между любыми двумя доступными валютами — `сумма × курс_целевой / курс_исходной`. Карточка выводит сумму, курс за единицу и время обновления. История хранит успешные конвертации в памяти, пока открыт экран. Она соответствует одному из дополнительных заданий раздела 9. [Документация ExchangeRate-API](https://www.exchangerate-api.com/docs/free)

## Что проверить перед сдачей

1. На Android введи 100 и нажми `КОН` для EUR → RUB. Сверь результат с курсом и временем из API. Нажми `SWAP`, повтори расчёт и проверь направление RUB → EUR и обе записи в истории.
2. Проверь пустую сумму, текст, отрицательное число, отсутствие сети и ответ сервера с ошибкой. Для повторяемых тестов используй подставной HTTP-ответ с заранее известными курсами.
3. Шаблонный `test/widget_test.dart` всё ещё проверяет счётчик из стандартного Flutter-проекта. При доработке замени эти проверки сценариями конвертера. В задании рекомендованы `ConverterState`, `CurrencyRepository` и `ApiClient`. Сейчас запрос вызывается обработчиком в `lib/main.dart`, а сам HTTP-код уже вынесен в `Api`.
4. Проверь соответствие UI заданию. Сейчас кнопка конвертации подписана `КОН`, а задание использует подпись «Конвертировать». При доработке сетевой части обработай повторные нажатия и смену валют во время запроса, проверь валидацию ввода и разбор ошибки API.
5. Для Android release сборки добавь `android.permission.INTERNET` в `android/app/src/main/AndroidManifest.xml` перед элементом `<application>` и проверь запрос курсов на устройстве. В исходнике разрешение есть в debug и profile манифестах. [Сетевые запросы во Flutter](https://docs.flutter.dev/cookbook/networking/fetch-data)

## Проверка архива 12 ноября 2026

- В распакованной копии прошли `flutter pub get --enforce-lockfile` и `flutter build apk --debug --no-pub`.
- Запрос к API с ноутбука вернул EUR, RUB, USD и время обновления. Запуск приложения на Android ещё предстоит проверить на телефоне или эмуляторе.
- `flutter test --no-pub` загрузил экран и остановился на проверке шаблонного счётчика. Автоматические проверки сценариев конвертера предстоит добавить.
