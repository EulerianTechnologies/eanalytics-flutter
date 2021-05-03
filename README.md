# eanalytics-flutter

### iOS Setup 📱

If you're planning on using the advertisingIdentifier : make sure you update your `Info.plist` file located in ios/Runner directory and add the `NSUserTrackingUsageDescription` key with a custom message describing your usage

```
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

### Flutter SDK version

`>=2.12.0 <3.0.0`
