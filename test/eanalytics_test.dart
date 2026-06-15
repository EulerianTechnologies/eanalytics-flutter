import 'package:eanalytics/src/models/EAGlobalParams.dart';
import 'package:eanalytics/src/models/EAProperty.dart';
import 'package:eanalytics/src/models/EATpClick.dart';
import 'package:eanalytics/src/models/EATpView.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eanalytics/src/eulerian.dart';
import 'package:eanalytics/src/utils/storage.dart';
import 'package:eanalytics/src/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Eulerian class should always return singleton instance', () {
    expect(Eulerian(), Eulerian());
  });

  test('Calling track before init should throw', () {
    expect(() => Eulerian.track([EAProperty(path: '/test')]),
        throwsAssertionError);
  });

  group('Merchandise query string', () {
    setUp(() {
      EAGlobalParams.edev = null;
    });

    test('EATpClick builds path and mandatory product params', () {
      final click = EATpClick(path: 'homepage')
        ..siteName = 'my-site'
        ..campaignName = 'summer_sale'
        ..placement = 'banner_top'
        ..url = 'tgt://recherche/promo?titre=Promo!'
        ..setProduct('PROD_001', 2, totalProducts: 12);

      final qs = click.toQueryString();

      expect(qs, startsWith('my-site/summer_sale/banner_top/my-site/generic/'));
      expect(qs, contains('ecprdr=PROD_001'));
      expect(qs, contains('ecpos=2'));
      expect(qs, contains('ecnbr=12'));
      expect(qs,
          contains('eurl=${Uri.encodeComponent('tgt://recherche/promo?titre=Promo!')}'));
      expect(qs.endsWith('&'), isFalse);
    });

    test('EATpView serializes every product with its position', () {
      final view = EATpView(path: 'homepage')
        ..siteName = 'my-site'
        ..campaignName = 'summer_sale'
        ..placement = 'banner_top'
        ..url = 'http://eulerian.net'
        ..addProduct('PROD_001', position: 0)
        ..addProduct('PROD_002', position: 1);

      final qs = view.toQueryString();

      expect(qs, startsWith('my-site/summer_sale/banner_top/my-site/generic/'));
      expect(qs, contains('evprdr0=PROD_001'));
      expect(qs, contains('evprdpos0=0'));
      expect(qs, contains('evprdr1=PROD_002'));
      expect(qs, contains('evprdpos1=1'));
      /* tpview sends the current page url as "url", not "eurl" */
      expect(qs, contains('url=${Uri.encodeComponent('http://eulerian.net')}'));
      expect(qs, isNot(contains('eurl=')));
      expect(qs.endsWith('&'), isFalse);
    });

    test('global context params (uid, edev) are appended automatically', () {
      EAGlobalParams.edev = 'AppNativeAndroidphone';

      final click = EATpClick(path: 'homepage')
        ..siteName = 'my-site'
        ..campaignName = 'summer_sale'
        ..placement = 'banner_top'
        ..setUID('beta-rc')
        ..setProduct('PROD_001', 1);

      final qs = click.toQueryString();

      expect(qs, contains('uid=beta-rc'));
      expect(qs, contains('edev=AppNativeAndroidphone'));
      /* excluded on purpose */
      expect(qs, isNot(contains('ereplay-time')));
      expect(qs, isNot(contains('ea-appversion')));
    });

    test('empty global params are skipped', () {
      final click = EATpClick(path: 'homepage')
        ..siteName = 'my-site'
        ..setProduct('PROD_001', 1);

      final qs = click.toQueryString();

      expect(qs, isNot(contains('edev=')));
      expect(qs, isNot(contains('uid=')));
      expect(qs, isNot(contains('euidl=')));
    });
  });

  group('Merchandise storage round-trip', () {
    setUp(() {
      EAGlobalParams.edev = null;
    });

    test('EATpView survives toStorageJson/fromStorageJson', () {
      final view = EATpView(path: 'homepage')
        ..siteName = 'my-site'
        ..campaignName = 'summer_sale'
        ..placement = 'banner_top'
        ..url = 'http://eulerian.net'
        ..setUID('beta-rc')
        ..addProduct('PROD_001', position: 0)
        ..addProduct('PROD_002', position: 1);

      final json = view.toStorageJson();
      expect(json['_ea_kind'], 'tpview');

      final restored = EATpView.fromStorageJson(json);

      expect(restored.toQueryString().split('/generic/').first,
          view.toQueryString().split('/generic/').first);
      final restoredParams = restored.toQueryString().split('?').last;
      final originalParams = view.toQueryString().split('?').last;
      expect(restoredParams, originalParams);
    });

    test('EATpClick survives toStorageJson/fromStorageJson', () {
      final click = EATpClick(path: 'homepage')
        ..siteName = 'my-site'
        ..campaignName = 'summer_sale'
        ..placement = 'banner_top'
        ..url = 'tgt://recherche/promo?titre=Promo!'
        ..setUID('beta-rc')
        ..setProduct('PROD_001', 2, totalProducts: 12);

      final json = click.toStorageJson();
      expect(json['_ea_kind'], 'tpclick');

      final restored = EATpClick.fromStorageJson(json);

      expect(restored.toQueryString().split('?').last,
          click.toQueryString().split('?').last);
      expect(restored.toQueryString(), contains('ecprdr=PROD_001'));
      expect(restored.toQueryString(), contains('ecnbr=12'));
      expect(restored.toQueryString(), contains('uid=beta-rc'));
    });
  });

  group('appendStored', () {
    test('appends without overwriting existing items', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await SharedPreferences.getInstance();
      final logger = EALogger();

      await appendStored([
        {'_ea_kind': 'tpview', 'a': 1}
      ], store: store, logger: logger);
      await appendStored([
        {'_ea_kind': 'tpclick', 'b': 2}
      ], store: store, logger: logger);

      final stored = await getStoredProperties(store: store, logger: logger);
      expect(stored.length, 2);
      expect(stored[0]['_ea_kind'], 'tpview');
      expect(stored[1]['_ea_kind'], 'tpclick');
    });
  });

  group('partitionStoredItems', () {
    test('routes merchandise to GET-objects and the rest to POST', () {
      final stored = <Map<String, dynamic>>[
        {
          '_ea_kind': 'tpview',
          '_ea_merch': {'siteName': 'my-site', 'products': []}
        },
        {
          '_ea_kind': 'tpclick',
          '_ea_merch': {'siteName': 'my-site', 'product': {}}
        },
        {'path': '/page', 'uid': 'plain-event'},
      ];

      final result = partitionStoredItems(stored);

      expect(result.merchandise.length, 2);
      expect(result.merchandise[0], isA<EATpView>());
      expect(result.merchandise[1], isA<EATpClick>());
      expect(result.postPayloads.length, 1);
      expect(result.postPayloads[0]['uid'], 'plain-event');
    });
  });
}
