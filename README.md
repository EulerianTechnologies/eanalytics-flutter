# EAnalytics - Flutter SDK

## Initialization

Call `Eulerian.init` **ONCE** before any tracking request at the top-level of your app.
It will try to sync any failed tracking attemps locally stored.

```dart
  await Eulerian.init('test.domain.dev')
```

> You can optionnally request tracking authorization for iOS devices by passing the requestTrackingAuhtorization flag to the init method.

To track `EAProperties`, call `Eulerian.track` from anywhere in your flutter app.
If the POST request fails, it will be stored in local storage for future retry.

> EAProperties include EACart, EAEstimate, EAOrder, EAProducts, EASearch -
> Additional models are here to help building EAProperties : Action, Params, Product, Search, SiteCentric

```dart
  Eulerian.track([
    EAProducts(path: '/add/products')
      ..addProduct(Product(ref: 'p1', name: 'Product 1', group: 'test_group'))
  ])
```

## iOS Setup 📱

If you're planning on using the advertisingIdentifier : make sure you update your `Info.plist` file located in ios/Runner directory and add the `NSUserTrackingUsageDescription` key with a custom message describing your usage

```xml
<key>NSUserTrackingUsageDescription</key>
<string>Request tracking...</string>
```

> If your app calls the App Tracking Transparency API, you must provide custom text, known as a usage-description string, which displays as a system-permission alert request.

When initializing EAnalytics, pass the `requestTrackingAuthorization` flag to prompt user for tracking authorization

```dart
  @override
  void initState() {
    Eulerian.init('domain.name', requestTrackingAuthorization: true);
    super.initState();
  }
```

### Global EAnalytics Properties

EAnalytics will internally handle setting the following properties on your payloads based on your platform.

| property name          | EAPropertyKey                | iOS | Android | Web |
| ---------------------- | ---------------------------- | --- | ------- | --- |
| ehw                    | `EAPropertyKey.EHW`          | ✔   | ✔       | ✔   |
| eos                    | `EAPropertyKey.EOS`          | ✔   | ✔       | ✔   |
| euidl                  | `EAPropertyKey.EUIDL`        | ✔   | ✔       | ✘   |
| ea-appname             | `EAPropertyKey.APPNAME`      | ✔   | ✔       | ✔   |
| ea-appversion          | `EAPropertyKey.APP_VERSION`  | ✔   | ✔       | ✔   |
| url \*                 | `EAPropertyKey.URL`          | ✔   | ✔       | ✔   |
| ea-ios-idfv            | `EAPropertyKey.IOS_IDFV`     | ✔   | ✘       | ✘   |
| ea-ios-idfa \*\*       | `EAPropertyKey.IOS_ADID`     | ✔   | ✘       | ✘   |
| ea-android-adid        | `EAPropertyKey.ANDROID_ADID` | ✘   | ✔       | ✘   |
| ereplay-time           | `EAPropertyKey.EPOCH`        | ✔   | ✔       | ✔   |
| ea-flutter-sdk-version | `EAPropertyKey.SDK_VERSION`  | ✔   | ✔       | ✔   |

> (\*) url property will be mapped to bundleIdentifier on iOS, getPackageName on Android, and current url path on web platform.

> (\*\*) ea-ios-idfv require requestTrackingAuthorization flag on eanalytics initialization on iOS.

### Flutter SDK version

`>=2.12.0`
