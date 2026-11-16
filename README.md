# PackagistCatalog — Flutter

Каталог PHP-пакетов Packagist на Flutter (Flutter 3.47, Dart 3.13).
Домен, источник данных и макет взяты из ЛР1 (КМП-версия каталога).
В ЛР3 моки заменены данными из сети: поиск и метаданные ходят в API
Packagist, менялись только папка `data` и сборка зависимостей в корне.

## Запуск

```bash
flutter pub get
flutter run -d android    # эмулятор/телефон — работает без настроек
flutter run -d chrome --web-browser-flag="--disable-web-security"
```

На web нужен флаг: Packagist отдаёт CORS-заголовок только https-источникам,
а `repo.packagist.org` (метаданные пакетов) не отдаёт вовсе, поэтому
браузер блокирует запросы с `http://localhost`. Флаг отключает проверку
только для отладочного запуска; на Android/iOS ограничений CORS нет.

Перед коммитами:

```bash
flutter analyze           # статический анализ
dart run tool/check_arb.dart   # проверка, что ARB ru/en согласованы
```

## Возможности

- Каталог загружается из сети (`packagist.org/search.json`, страница —
  15 пакетов, счётчик «Найдено пакетов» — поле `total` из ответа).
- Деталь пакета грузится своим запросом
  (`repo.packagist.org/p2/{name}.json`) со своим индикатором; наличие
  зависимостей из `require` проверяется параллельно (`Future.wait`).
- Пагинация: докрутил список — подгружается следующая страница без
  повторов; при обрыве догрузки внизу остаётся кнопка «Повторить».
- Без сети или при неверном адресе — сообщение по типу ошибки
  и кнопка «Повторить»: включил сеть, нажал — список появился.
- Поиск по имени и описанию, экран «ничего не найдено».
- Позиция списка, запрос и результат не теряются при возврате с детали.
- Переключение темы (светлая/тёмная/системная) и языка (ru/en)
  в шапке каталога.

## Структура

```
lib/
  main.dart, app.dart        корень: сборка цепочки данных, провайдеры
  common/
    network/
      dio_client.dart            Dio: адреса хостов, таймауты, лог в debug
      load_exception.dart        sealed LoadException и его подтипы
    navigation/app_router.dart   go_router: / и /package/:name
    theme/                       AppColors, AppTheme, ThemeCubit
    localization/                LocaleCubit
    widgets/                     LoadErrorView, экран для неизвестных адресов
  l10n/                        ARB ru/en + сгенерированная локализация
  features/package/
    api/package_api.dart         HTTP-клиент: один метод на один адрес
    dto/                         DTO + сгенерированный fromJson (.g.dart)
    data_sources/                датасорс: ловит DioException → LoadException
    mappers/package_mapper.dart  extension toModel(): DTO → домен
    data/package_repository.dart репозиторий над датасорсом
    domain/                      PhpPackage, PackagePage, IPackageRepository
    presentation/
      bloc/          PackageListCubit, PackageDetailBloc, состояния, события
      view/          экраны каталога и пакета, виджеты карточек
```

Цепочка данных: **Dio → PackageApi → NetworkPackageDataSource →
PackageRepository → Cubit/Bloc → экран**. Слои выше датасорса не знают
про dio и DTO: датасорс переводит `DioException` в свои `LoadException`,
репозиторий переводит DTO в домен через маппер, экраны видят только
состояния и `LoadException`.

## Ключевые решения

- **State manager — flutter_bloc.** Каталог на `PackageListCubit`
  (публичные методы `load()`, `search(query)`, `loadMore()`, Cubit живёт
  в корне приложения), деталь — на `PackageDetailBloc` с событием
  `PackageDetailOpened` (Bloc создаётся и закрывается вместе со своим
  экраном). Состояния — sealed-классы, экран разбирает их через `switch`.
- **Гонки.** Сеть непредсказуема по времени: у Cubit есть счётчик
  запросов, ответ на устаревший запрос отбрасывается. У Bloc детали
  после каждого `await` стоит проверка `isClosed`, чтобы быстрый
  «назад» не приводил к ошибкам в консоли.
- **Пагинация — без библиотек.** `ListView` с футером: докрутил до
  конца — `loadMore()` грузит следующую страницу; повторные вызовы
  Cubit игнорирует. Обрыв догрузки — не ошибка экрана: список остаётся,
  внизу «Повторить» грузит ту же страницу, чтобы не пропустить записи.
- **DTO — json_serializable.** `fromJson` генерируется
  (`dart run build_runner build`), `.g.dart` в git. Ответ `p2/*.json`
  отдаётся minified: в старых версиях опущены поля, совпадающие с более
  новой версией, — маппер разворачивает наследование и выбирает
  последнюю стабильную версию (первая в списке может быть `BETA`).
- **Счётчики пакета.** В `p2`-метаданных загрузок и звёзд нет — они
  приходят из выдачи поиска, поэтому деталь запрашивает оба ответа
  параллельно; недостающие счётчики не ломают экран.
- **Навигация — go_router.** Идентификатор в пути: `/package/:name`.
  Имя пакета содержит `/`, поэтому в пути оно закодировано:
  `/package/laravel%2Fframework`. Включён
  `GoRouter.optionURLReflectsImperativeAPIs`, связанные записи
  открываются через `push`.
- **Зависимости — провайдеры.** Dio создаётся один раз в корне
  (`app.dart`) и передаётся в API-клиент через конструктор; репозиторий
  регистрируется через `RepositoryProvider<IPackageRepository>`, Cubit
  получает его через `context.read`. DI-контейнеров нет.
- **Подписи** — в ARB на двух языках, `tool/check_arb.dart` проверяет,
  что ключи и плейсхолдеры совпадают в обоих файлах.
- **Цвета и тема** — только из `AppColors` и `ColorScheme`; прямые
  `Colors.white` и русские строки в виджетах не используются.
