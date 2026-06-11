import 'package:eanalytics/src/models/EAGlobalParams.dart';
import 'package:eanalytics/src/models/EAProperty.dart';
import 'package:eanalytics/src/models/EATpClick.dart';
import 'package:eanalytics/src/models/EATpView.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eanalytics/src/eulerian.dart';

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
}
