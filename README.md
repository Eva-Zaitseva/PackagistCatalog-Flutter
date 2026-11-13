# PackagistCatalog — Flutter

Каталог PHP-пакетов Packagist на Flutter (Flutter 3.47, Dart 3.13).
Домен, источник данных и макет взяты из ЛР1 (КМП-версия каталога).
Сети пока нет — данные берутся из моков; в ЛР3 вместо моков появится
API packagist.org, изменится только папка `data`.

## Запуск

```bash
flutter pub get
flutter run -d chrome     # веб
flutter run -d android    # либо эмулятор/телефон
```

Перед коммитами:

```bash
flutter analyze           # статический анализ
dart run tool/check_arb.dart   # проверка, что ARB ru/en согласованы
```

## Возможности

- Каталог из 23 PHP-пакетов: имя, описание, версия, загрузки, звёзды.
- Деталь пакета: счётчики и зависимости `require`; зависимость,
  которая есть в каталоге, открывается через `push` («назад»
  возвращает по одному экрану).
- Поиск по имени и описанию, экран «ничего не найдено».
- Позиция списка, запрос и результат не теряются при возврате с детали.
- Переключение темы (светлая/тёмная/системная) и языка (ru/en)
  в шапке каталога.

## Структура

```
lib/
  main.dart, app.dart        корень: провайдеры, MaterialApp.router
  common/
    navigation/app_router.dart   go_router: / и /package/:name
    theme/                       AppColors, AppTheme, ThemeCubit
    localization/                LocaleCubit
    widgets/                     экран для неизвестных адресов
  l10n/                        ARB ru/en + сгенерированная локализация
  features/package/
    data/            моки и реализация репозитория
    domain/          модель PhpPackage, интерфейс IPackageRepository
    presentation/
      bloc/          PackageListCubit, PackageDetailBloc, состояния, события
      view/          экраны каталога и пакета, виджеты карточек
```

## Ключевые решения

- **State manager — flutter_bloc.** Каталог на `PackageListCubit`
  (публичные методы `load()` и `search(query)`, Cubit живёт в корне
  приложения), деталь — на `PackageDetailBloc` с событием
  `PackageDetailOpened` (Bloc создаётся и закрывается вместе со своим
  экраном). Состояния — sealed-классы, экран разбирает их через `switch`.
- **Навигация — go_router.** Идентификатор в пути: `/package/:name`.
  Имя пакета содержит `/`, поэтому в пути оно закодировано:
  `/package/laravel%2Fframework`. Включён
  `GoRouter.optionURLReflectsImperativeAPIs`, связанные записи
  открываются через `push`.
- **Зависимости — провайдеры.** Репозиторий регистрируется в корне
  через `RepositoryProvider<IPackageRepository>`; Cubit получает его
  через `context.read`. DI-контейнеров нет.
- **Подписи** — в ARB на двух языках, `tool/check_arb.dart` проверяет,
  что ключи и плейсхолдеры совпадают в обоих файлах.
- **Цвета и тема** — только из `AppColors` и `ColorScheme`; прямые
  `Colors.white` и русские строки в виджетах не используются.
