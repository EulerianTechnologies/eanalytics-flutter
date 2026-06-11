# EAnalytics — Flutter SDK

> 🇬🇧 English · [🇫🇷 Français](README-fr.md) · [🇪🇸 Español](README-es.md) · [🇮🇹 Italiano](README-it.md)

Official Flutter SDK for the [Eulerian Technologies](https://eulerian.io/) augmented analytics platform. It lets you track pages, products, carts, orders, searches, actions and merchandise events (impressions / clicks) from a single API, on **iOS**, **Android** and **Web**.

## Requirements

| | |
| --- | --- |
| Flutter | `>=3.3.0` |
| Dart SDK | `>=2.18.0 <4.0.0` |
| Platforms | iOS, Android, Web |

## Installation

Add the package to your app:

```sh
flutter pub add eanalytics
```

Or declare it manually in your `pubspec.yaml`:

```yaml
dependencies:
  eanalytics: ^1.1.1
```

Then import it:

```dart
import 'package:eanalytics/eanalytics.dart';
```

## Quick start

### 1. Initialize the SDK

Call `Eulerian.init` **once**, before any tracking request, at the top level of your app (e.g. in `initState` of your root widget). It will also try to sync any failed tracking attempts stored locally.

```dart
await Eulerian.init('your.tracking-domain.com');
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `domain` | `String` | — | Your dedicated Eulerian tracking domain (must **not** contain `.eulerian.com`) |
| `requestTrackingAuthorization` | `bool` | `false` | iOS only — prompts the user with the App Tracking Transparency dialog to collect the IDFA |
| `enableLogger` | `bool` | `true` | Enables / disables SDK console logging |

### 2. Track events

Call `Eulerian.track` from anywhere in your app with a list of trackable properties:

```dart
Eulerian.track([
  EAProducts(path: '/add/products')
    ..addProduct(Product(ref: 'p1', name: 'Product 1', group: 'test_group'))
]);
```

Standard events are sent as a **POST** batch to the Eulerian collector. If the request fails, payloads are stored locally and retried on the next `Eulerian.track` call or on the next app launch (after `Eulerian.init`).

## API reference

### `Eulerian` (singleton)

| Method | Description |
| --- | --- |
| `Eulerian.init(domain, {requestTrackingAuthorization, enableLogger})` | Initializes the SDK and replays locally stored payloads |
| `Eulerian.track(List<EAProperty> properties)` | Tracks a list of properties. `EATpView` / `EATpClick` are sent via GET, everything else is batched in a single POST |
| `Eulerian.uid()` | Returns the device identifier used as `euidl` (Android ID on Android, `identifierForVendor` on iOS), or an empty string if the SDK is not initialized |

### `EAProperty` — base trackable event

`EAProperty` is the base class of every trackable event. It can also be used directly to track a simple page view. The constructor requires a `path` (the page path; a leading `/` is added automatically if missing).

```dart
Eulerian.track([
  EAProperty(path: '/home')
    ..setEmail('johndoe@example.com')
    ..setUID('user-42')
    ..setPageGroup('homepage')
]);
```

Available setters (inherited by all event models):

| Method | Payload key | Description |
| --- | --- | --- |
| `setPath(String path)` | `path` | Page path of the event |
| `setLocation({latitude, longitude})` | `ea-lat`, `ea-lon` | Geographic coordinates |
| `setNewCustomer(bool isNew)` | `newcustomer` | Flags the visitor as a new customer (`1` / `0`) |
| `setStandalone()` | `ereplay-notag` | Marks the hit as a standalone call (no page view counted) |
| `setEmail(String email)` | `email` | Visitor e-mail address |
| `setLabel(String label)` | `pagelabel` | Page label (comma-separated values allowed) |
| `setUID(String uid)` | `uid` | Your own visitor identifier |
| `setProfile(String profile)` | `profile` | Visitor profile |
| `setPageGroup(String group)` | `pagegroup` | Page group |
| `setAction(Action action)` | `action` | Attaches an [`Action`](#action) to the page |
| `setProperty(SiteCentric property)` | `property` | Site-centric properties |
| `setCFlag(SiteCentric cFlag)` | `cflag` | Site-centric conversion flags |
| `setCustomParam(String key, String value)` | `<key>` | Arbitrary custom key/value pair |

### Event models

All models below extend `EAProperty`, so every setter above is available on them too.

#### `EAProducts` — product display

Tracks the display of one or more products.

```dart
Eulerian.track([
  EAProducts(path: '/product/page')
    ..addProduct(Product(ref: 'p1', name: 'Product 1', group: 'shoes'))
    ..addProduct(Product(ref: 'p2', name: 'Product 2', group: 'shoes')),
]);
```

| Method | Description |
| --- | --- |
| `addProduct(Product product)` | Adds a product to the `products` list |

#### `EACart` — shopping cart

Tracks the content of the visitor's cart. The `scart` flag is set automatically.

```dart
Eulerian.track([
  EACart(path: '/cart')
    ..setCartCumul(true)
    ..addProduct(product: Product(ref: 'p1'), amount: 19.99, quantity: 2),
]);
```

| Method | Description |
| --- | --- |
| `setCartCumul(bool cumul)` | If `true`, the cart is cumulative (`scartcumul`) |
| `addProduct({product, amount, quantity})` | Adds a product; `amount` / `quantity` are applied to the product if not already set on it |

#### `EAEstimate` — estimate / quote

Tracks an estimate (pre-sale). The `estimate` flag is set automatically.

```dart
Eulerian.track([
  EAEstimate(path: '/estimate', ref: 'EST-001')
    ..setAmount(149.90)
    ..setCurrency('EUR')
    ..setType('quote')
    ..setPayment('card')
    ..addProduct(product: Product(ref: 'p1'), amount: 149.90, quantity: 1),
]);
```

| Method | Payload key | Description |
| --- | --- | --- |
| `setAmount(double amount)` | `amount` | Total amount |
| `setCurrency(String currency)` | `currency` | Currency code |
| `setType(String type)` | `type` | Estimate type |
| `setPayment(String payment)` | `payment` | Payment method |
| `addProduct({product, amount, quantity})` | `products` | Adds a product to the estimate |

#### `EAOrder` — purchase

Tracks a confirmed order. Extends `EAEstimate`, so all its setters are available. The constructor links the order to a previous estimate via `estimateRef`.

```dart
Eulerian.track([
  EAOrder(path: '/order/confirmation', estimateRef: 'EST-001')
    ..setAmount(149.90)
    ..setCurrency('EUR')
    ..setPayment('card')
    ..addProduct(product: Product(ref: 'p1'), amount: 149.90, quantity: 1),
]);
```

| Method | Payload key | Description |
| --- | --- | --- |
| `setEstimateRef(String ref)` | `estimateref` | Reference of the originating estimate |

#### `EASearch` — internal search engine

Tracks a query on your internal search engine.

```dart
Eulerian.track([
  EASearch(
    path: '/search',
    search: Search(name: 'shoes', results: 42),
  ),
]);
```

#### `EAActions` — user actions

Tracks one or more user actions (clicks, interactions…). Combine with `setStandalone()` for action-only hits that should not count as a page view.

```dart
Eulerian.track([
  EAActions(path: '')
    ..setStandalone()
    ..addAction(Action(name: 'button1', mode: 'in'))
    ..addAction(Action(name: 'newsletter', label: 'footer')
      ..setParams(Params()..addParam('input', 'test'))),
]);
```

| Method | Description |
| --- | --- |
| `addAction(Action action)` | Adds an [`Action`](#action) to the `actions` list |

### Helper classes

These classes are building blocks for the event models above.

#### `Product`

```dart
Product(
  ref: 'p1',                       // required
  name: 'Product 1',
  group: 'shoes',
  parameters: Params()..addParam('color', 'red'),
)
  ..setAmount(19.99)
  ..setQuantity(2);
```

#### `Action`

```dart
Action(name: 'button1', mode: 'in', label: 'lbl1,lbl2', ref: 'ref1')
  ..setParams(Params()..addParam('input', 'test'));
```

`name` is required; `mode`, `label` and `ref` are optional.

#### `Params`

Arbitrary key/value parameters attachable to products, actions and searches.

```dart
Params.fromEntries([MapEntry('foo', 'bar'), MapEntry('baz', [1, 2, 3])]);
// or
Params()..addParam('foo', 'bar');
```

#### `Search`

Describes an internal search for `EASearch`: `Search(name: 'shoes', results: 42, parameters: Params()...)`.

#### `SiteCentric`

Site-centric key/values (each value is a list of strings) for `setProperty` / `setCFlag`:

```dart
SiteCentric()..addParam('prop', ['foo', 'baz']);
```

## Merchandise tracking (`EATpView` / `EATpClick`)

A dedicated **merchandise** tracking flow sends impressions and clicks on product showcases, recommendation lists and similar surfaces.

- **`EATpView`** — impression events, sent on `GET /tpview/`
- **`EATpClick`** — click events, sent on `GET /tpclick/`

Unlike the other events, which are POSTed to the standard collector, merchandise events are sent as **GET** requests on these two dedicated paths. If a request fails, the payload is stored locally as a fallback and replayed with the pending POST batch.

The requests are built as:

```
https://<domain>/tpview/<siteName>/<campaignName>/<placement>/<siteName>/generic/<random>
       ?evprdr0=<ref>&evprdpos0=<position>&...&url=<encoded page url>&<global context>

https://<domain>/tpclick/<siteName>/<campaignName>/<placement>/<siteName>/generic/<random>
       ?ecprdr=<ref>&ecpos=<position>&ecnbr=<total>&eurl=<encoded landing url>&<global context>
```

The SDK **automatically appends the global context parameters** to every merchandise request — the same values used on collector calls: `euidl`, `ea-appname`, `eos`, `ehw`, the advertising identifiers (`ea-android-adid` / `ea-ios-idfa` / `ea-ios-idfv`) and the `edev` device qualification (`AppNativeIOSphone`, `AppNativeIOStablet`, `AppNativeAndroidphone`, `AppNativeAndroidtablet`), which forces the traffic to be qualified as a native application. No extra code is needed on your side.

The `uid` visitor identifier is appended too when set on the event via `setUID()`, exactly like on collector calls.

Both models expose the same campaign descriptors: `siteName`, `campaignName`, `placement` and `url`. Note the different meaning of `url`: on `EATpView` it is the **current page URL** (sent as `url`), on `EATpClick` it is the **landing URL** of the clicked product (sent as `eurl`).

### `EATpView` — impression

```dart
final view = EATpView(path: 'homepage')
  ..siteName = 'my-site'
  ..campaignName = 'summer_sale'
  ..placement = 'banner_top'
  ..url = 'https://example.com/home'
  ..addProduct('PROD_001', position: 0)
  ..addProduct('PROD_002', position: 1);

Eulerian.track([view]);
```

| Method | Description |
| --- | --- |
| `addProduct(String ref, {int? position})` | Adds a displayed product (with its optional position in the block) |
| `setProducts(List<List<dynamic>> products)` | Replaces the whole product list (`[ref]` or `[ref, position]` entries) |

### `EATpClick` — click

```dart
final click = EATpClick(path: 'homepage')
  ..siteName = 'my-site'
  ..campaignName = 'summer_sale'
  ..placement = 'banner_top'
  ..url = 'https://example.com/home'
  ..setProduct('PROD_001', 2);

Eulerian.track([click]);
```

| Method | Description |
| --- | --- |
| `setProduct(String ref, int position, {int? totalProducts})` | Sets the clicked product, its position and optionally the total number of products in the block |
| `setProductMap(Map<String, dynamic> product)` | Sets the product from a raw map (`ref`, `position`, `totalProducts` keys) |

## Global properties

The SDK automatically attaches the following properties to every payload, depending on the platform:

| Property name | EAPropertyKey | iOS | Android | Web |
| --- | --- | --- | --- | --- |
| `ehw` | `EAPropertyKey.EHW` | ✔ | ✔ | ✔ |
| `eos` | `EAPropertyKey.EOS` | ✔ | ✔ | ✔ |
| `euidl` | `EAPropertyKey.EUIDL` | ✔ | ✔ | ✘ |
| `ea-appname` | `EAPropertyKey.APPNAME` | ✔ | ✔ | ✔ |
| `ea-appversion` | `EAPropertyKey.APP_VERSION` | ✔ | ✔ | ✔ |
| `url` \* | `EAPropertyKey.URL` | ✔ | ✔ | ✔ |
| `ea-ios-idfv` | `EAPropertyKey.IOS_IDFV` | ✔ | ✘ | ✘ |
| `ea-ios-idfa` \*\* | `EAPropertyKey.IOS_ADID` | ✔ | ✘ | ✘ |
| `ea-android-adid` | `EAPropertyKey.ANDROID_ADID` | ✘ | ✔ | ✘ |
| `ea-android-referrer` | `EAPropertyKey.INSTALL_REFERRER` | ✘ | ✔ | ✘ |
| `ereplay-time` | `EAPropertyKey.EPOCH` | ✔ | ✔ | ✔ |
| `ea-flutter-sdk-version` | `EAPropertyKey.SDK_VERSION` | ✔ | ✔ | ✔ |

> (\*) the `url` property is mapped to the bundle identifier on iOS, the package name on Android, and the current URL path on Web.

> (\**) `ea-ios-idfa` requires the `requestTrackingAuthorization` flag at SDK initialization on iOS.

## iOS setup 📱

If you plan on using the advertising identifier (IDFA), update the `Info.plist` file located in the `ios/Runner` directory and add the `NSUserTrackingUsageDescription` key with a message describing your usage:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized analytics.</string>
```

> If your app calls the App Tracking Transparency API, you must provide a usage-description string, which displays as a system permission alert.

Then pass the `requestTrackingAuthorization` flag when initializing the SDK to prompt the user:

```dart
@override
void initState() {
  Eulerian.init('your.tracking-domain.com', requestTrackingAuthorization: true);
  super.initState();
}
```

## Offline retry

Tracking requests that fail (network error, non-2xx response) are stored in local storage (`shared_preferences`) and automatically replayed:

- on the next `Eulerian.track` call (merged with the new batch), or
- on the next app launch, when `Eulerian.init` completes.

## Example app

A complete example app (iOS / Android / Web) is available in the [example/](example/) directory.

## License

See [LICENSE](LICENSE).
