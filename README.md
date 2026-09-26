# RAWG

![Flutter](https://img.shields.io/badge/Flutter-3.32%2B-02569B?logo=flutter&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-Cubit-13B9FD)
![Supabase](https://img.shields.io/badge/Supabase-Auth-3FCF8E?logo=supabase&logoColor=white)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-3DDC84)

A game discovery app for Android and iOS, built with Flutter on top of the RAWG video game database. Players sign in, browse and search hundreds of thousands of games, filter by platform, and open a detailed overview of any title.

The app follows Clean Architecture with use cases, repositories and data sources behind interfaces, and keeps game details available offline once they have been viewed.

## Features

- **Game browsing** from the RAWG API, twenty games per page, with a Load More button for the next page.
- **Debounced search**: results update one second after typing stops, and clearing the field returns to the full list.
- **Platform filters** for PlayStation, Xbox and PC.
- **Game overview** with Metascore, average playtime, genres, release date, publishers, website, platforms, available stores and the full description.
- **Offline game details**: every overview you open is cached on the device for 24 hours and served from the cache when the network is unavailable.
- **Connection awareness**: the game list reloads by itself when the device comes back online after starting without a connection.
- **Accounts** with email and password sign-up and sign-in through Supabase, live form validation, and routes that redirect to sign-in when there is no session.
- **Push notifications** through OneSignal, linked to the signed-in user and switchable on or off in Settings.
- **English and Sinhala**, switchable at runtime from Settings.
- **Dark theme** throughout.

## Architecture

- **Clean Architecture per feature.** `auth` and `dashboard` each have `data` (data sources, models, repository implementations), `domain` (entities, repository contracts, use cases) and `presentation` (cubits, states, pages, widgets). The domain has no framework types: auth works with an `AppUser` entity, and the data layer maps Supabase users into it.
- **Cubits for state.** Auth, dashboard, platform filters, settings and form fields each have their own Cubit with an `Equatable` state. Cubits hold no widgets or text controllers; pages and fields own those and pass values in.
- **Dependency injection with GetIt.** One container registers data sources, repositories, use cases and cubits, and initialises Hive, Supabase and OneSignal at start-up. It is the only place that keeps a single shared instance of a service.
- **Typed results.** Data sources return `ApiSuccess` or `ApiFailure` instead of throwing, and cubits pattern-match on the result.
- **Declarative routing.** GoRouter redirects based on the current user from `GetCurrentUserUseCase`, and the game overview is a nested route under the dashboard.
- **No code generation.** Models, entities and the Hive type adapter are written by hand.

## How the data flows

1. **Every request carries the API key.** A Dio interceptor adds the RAWG key to each call, with 30-second timeouts and compact request logging.
2. **The list is always live.** `getGames` checks connectivity first and returns a localised no-internet error when offline.
3. **Stale responses are dropped.** Each list request takes an incrementing id, and a response is ignored if a newer search, filter or page request has started since.
4. **Details are network-first with a cache fallback.** A successful overview is written to Hive; when the device is offline or the request fails, the cached copy is returned if it is younger than 24 hours.
5. **Errors are localised.** Failures surface as translated messages rather than raw exceptions.

## Tech stack

| Area | Choice |
|---|---|
| Language | Dart 3.8 |
| UI | Flutter, Material dark theme, cached_network_image |
| State | flutter_bloc (Cubit), equatable |
| Navigation | go_router |
| Networking | dio, pretty_dio_logger, internet_connection_checker_plus |
| Local storage | hive_flutter, shared_preferences |
| Dependency injection | get_it |
| Backend | Supabase authentication |
| Notifications | OneSignal |
| Localisation | easy_localization (English, Sinhala) |

## Code conventions

- A strict member ordering convention for every class: fields sorted by type tier, then type, then name; methods ordered by call order.
- No comments in source. Names, types and ordering carry the meaning.
- `dart format` at a 240-column page width.

## Project structure

```
lib/
    main.dart, app.dart
    core/configs/       Router
    core/constants/     API, assets, locales, routes, platform filters
    core/di/            GetIt container
    core/errors/        Exceptions and failures
    core/network/       ApiRequest, ApiResult, ConnectionChecker
    core/services/      OneSignalService
    core/theme/         Fonts, palette, theme
    features/auth/      Sign up, sign in, sign out, current user
    features/common/    Shared cubits and widgets
    features/dashboard/ Game list, search, filters, overview, Hive cache
    features/settings/  Language, notifications, sign out
assets/locales/         en-US and si-LK translations
```

## Building

**Requirements:** Flutter 3.32 or later, the Android SDK, and Xcode on macOS for iOS.

1. Set your RAWG API key, Supabase URL and anon key, and OneSignal app id in `lib/core/secrets/app_secrets.dart`.
2. Run `flutter pub get`, then `flutter run`.

## Testing

Unit tests live in `test/`, mirroring the `lib/` path of the code they cover, with hand-written fakes for the data sources and connection checker:

- **`test/features/dashboard/data/repository/dashboard_repository_impl_test.dart`**: when online, game details come from the network and are cached; when offline, the cached copy is served without calling the network.

Run them with `flutter test`.

## Roadmap

- Cache the game list for offline browsing, not only opened game details
- Open the game from a notification's `game_id` instead of the dashboard
- Infinite scroll in place of the Load More button
