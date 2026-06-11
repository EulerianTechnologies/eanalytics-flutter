# EAnalytics — SDK Flutter

> [🇬🇧 English](README.md) · 🇫🇷 Français · [🇪🇸 Español](README-es.md) · [🇮🇹 Italiano](README-it.md)

SDK Flutter officiel pour la plateforme d'analytics augmentée [Eulerian Technologies](https://eulerian.io/). Il vous permet de tracker les pages, produits, paniers, commandes, recherches, actions et événements merchandising (impressions / clics) depuis une API unique, sur **iOS**, **Android** et **Web**.

## Prérequis

| | |
| --- | --- |
| Flutter | `>=3.3.0` |
| Dart SDK | `>=2.18.0 <4.0.0` |
| Plateformes | iOS, Android, Web |

## Installation

Ajoutez le package à votre application :

```sh
flutter pub add eanalytics
```

Ou déclarez-le manuellement dans votre `pubspec.yaml` :

```yaml
dependencies:
  eanalytics: ^1.1.1
```

Puis importez-le :

```dart
import 'package:eanalytics/eanalytics.dart';
```

## Démarrage rapide

### 1. Initialiser le SDK

Appelez `Eulerian.init` **une seule fois**, avant toute requête de tracking, au niveau racine de votre application (par exemple dans le `initState` de votre widget racine). Il tentera également de synchroniser les tentatives de tracking échouées stockées localement.

```dart
await Eulerian.init('your.tracking-domain.com');
```

| Paramètre | Type | Défaut | Description |
| --- | --- | --- | --- |
| `domain` | `String` | — | Votre domaine de tracking Eulerian dédié (ne doit **pas** contenir `.eulerian.com`) |
| `requestTrackingAuthorization` | `bool` | `false` | iOS uniquement — affiche à l'utilisateur la boîte de dialogue App Tracking Transparency afin de collecter l'IDFA |
| `enableLogger` | `bool` | `true` | Active / désactive la journalisation du SDK dans la console |

### 2. Tracker des événements

Appelez `Eulerian.track` depuis n'importe quel endroit de votre application avec une liste de propriétés trackables :

```dart
Eulerian.track([
  EAProducts(path: '/add/products')
    ..addProduct(Product(ref: 'p1', name: 'Product 1', group: 'test_group'))
]);
```

Les événements standards sont envoyés en lot via **POST** au collecteur Eulerian. Si la requête échoue, les payloads sont stockés localement et rejoués au prochain appel à `Eulerian.track` ou au prochain lancement de l'application (après `Eulerian.init`).

## Référence de l'API

### `Eulerian` (singleton)

| Méthode | Description |
| --- | --- |
| `Eulerian.init(domain, {requestTrackingAuthorization, enableLogger})` | Initialise le SDK et rejoue les payloads stockés localement |
| `Eulerian.track(List<EAProperty> properties)` | Tracke une liste de propriétés. `EATpView` / `EATpClick` sont envoyés via GET, tout le reste est regroupé dans un unique POST |
| `Eulerian.uid()` | Retourne l'identifiant de l'appareil utilisé comme `euidl` (Android ID sur Android, `identifierForVendor` sur iOS), ou une chaîne vide si le SDK n'est pas initialisé |

### `EAProperty` — événement trackable de base

`EAProperty` est la classe de base de tout événement trackable. Elle peut aussi être utilisée directement pour tracker une simple vue de page. Le constructeur requiert un `path` (le chemin de la page ; un `/` initial est ajouté automatiquement s'il est absent).

```dart
Eulerian.track([
  EAProperty(path: '/home')
    ..setEmail('johndoe@example.com')
    ..setUID('user-42')
    ..setPageGroup('homepage')
]);
```

Setters disponibles (hérités par tous les modèles d'événements) :

| Méthode | Clé du payload | Description |
| --- | --- | --- |
| `setPath(String path)` | `path` | Chemin de la page de l'événement |
| `setLocation({latitude, longitude})` | `ea-lat`, `ea-lon` | Coordonnées géographiques |
| `setNewCustomer(bool isNew)` | `newcustomer` | Marque le visiteur comme nouveau client (`1` / `0`) |
| `setStandalone()` | `ereplay-notag` | Marque le hit comme un appel autonome (aucune vue de page comptabilisée) |
| `setEmail(String email)` | `email` | Adresse e-mail du visiteur |
| `setLabel(String label)` | `pagelabel` | Libellé de la page (valeurs séparées par des virgules autorisées) |
| `setUID(String uid)` | `uid` | Votre propre identifiant de visiteur |
| `setProfile(String profile)` | `profile` | Profil du visiteur |
| `setPageGroup(String group)` | `pagegroup` | Groupe de pages |
| `setAction(Action action)` | `action` | Attache une [`Action`](#action) à la page |
| `setProperty(SiteCentric property)` | `property` | Propriétés site-centric |
| `setCFlag(SiteCentric cFlag)` | `cflag` | Indicateurs de conversion site-centric |
| `setCustomParam(String key, String value)` | `<key>` | Paire clé/valeur personnalisée arbitraire |

### Modèles d'événements

Tous les modèles ci-dessous étendent `EAProperty`, chaque setter ci-dessus est donc également disponible sur eux.

#### `EAProducts` — affichage de produits

Tracke l'affichage d'un ou plusieurs produits.

```dart
Eulerian.track([
  EAProducts(path: '/product/page')
    ..addProduct(Product(ref: 'p1', name: 'Product 1', group: 'shoes'))
    ..addProduct(Product(ref: 'p2', name: 'Product 2', group: 'shoes')),
]);
```

| Méthode | Description |
| --- | --- |
| `addProduct(Product product)` | Ajoute un produit à la liste `products` |

#### `EACart` — panier d'achat

Tracke le contenu du panier du visiteur. L'indicateur `scart` est positionné automatiquement.

```dart
Eulerian.track([
  EACart(path: '/cart')
    ..setCartCumul(true)
    ..addProduct(product: Product(ref: 'p1'), amount: 19.99, quantity: 2),
]);
```

| Méthode | Description |
| --- | --- |
| `setCartCumul(bool cumul)` | Si `true`, le panier est cumulatif (`scartcumul`) |
| `addProduct({product, amount, quantity})` | Ajoute un produit ; `amount` / `quantity` sont appliqués au produit s'ils n'y sont pas déjà définis |

#### `EAEstimate` — devis / estimation

Tracke un devis (avant-vente). L'indicateur `estimate` est positionné automatiquement.

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

| Méthode | Clé du payload | Description |
| --- | --- | --- |
| `setAmount(double amount)` | `amount` | Montant total |
| `setCurrency(String currency)` | `currency` | Code de la devise |
| `setType(String type)` | `type` | Type de devis |
| `setPayment(String payment)` | `payment` | Moyen de paiement |
| `addProduct({product, amount, quantity})` | `products` | Ajoute un produit au devis |

#### `EAOrder` — achat

Tracke une commande confirmée. Étend `EAEstimate`, tous ses setters sont donc disponibles. Le constructeur relie la commande à un devis antérieur via `estimateRef`.

```dart
Eulerian.track([
  EAOrder(path: '/order/confirmation', estimateRef: 'EST-001')
    ..setAmount(149.90)
    ..setCurrency('EUR')
    ..setPayment('card')
    ..addProduct(product: Product(ref: 'p1'), amount: 149.90, quantity: 1),
]);
```

| Méthode | Clé du payload | Description |
| --- | --- | --- |
| `setEstimateRef(String ref)` | `estimateref` | Référence du devis d'origine |

#### `EASearch` — moteur de recherche interne

Tracke une requête sur votre moteur de recherche interne.

```dart
Eulerian.track([
  EASearch(
    path: '/search',
    search: Search(name: 'shoes', results: 42),
  ),
]);
```

#### `EAActions` — actions utilisateur

Tracke une ou plusieurs actions utilisateur (clics, interactions…). À combiner avec `setStandalone()` pour des hits ne contenant que des actions et qui ne doivent pas être comptabilisés comme une vue de page.

```dart
Eulerian.track([
  EAActions(path: '')
    ..setStandalone()
    ..addAction(Action(name: 'button1', mode: 'in'))
    ..addAction(Action(name: 'newsletter', label: 'footer')
      ..setParams(Params()..addParam('input', 'test'))),
]);
```

| Méthode | Description |
| --- | --- |
| `addAction(Action action)` | Ajoute une [`Action`](#action) à la liste `actions` |

### Classes utilitaires

Ces classes sont les briques de base des modèles d'événements ci-dessus.

#### `Product`

```dart
Product(
  ref: 'p1',                       // requis
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

`name` est requis ; `mode`, `label` et `ref` sont optionnels.

#### `Params`

Paramètres clé/valeur arbitraires pouvant être attachés aux produits, actions et recherches.

```dart
Params.fromEntries([MapEntry('foo', 'bar'), MapEntry('baz', [1, 2, 3])]);
// ou
Params()..addParam('foo', 'bar');
```

#### `Search`

Décrit une recherche interne pour `EASearch` : `Search(name: 'shoes', results: 42, parameters: Params()...)`.

#### `SiteCentric`

Clés/valeurs site-centric (chaque valeur est une liste de chaînes) pour `setProperty` / `setCFlag` :

```dart
SiteCentric()..addParam('prop', ['foo', 'baz']);
```

## Tracking merchandising (`EATpView` / `EATpClick`)

Un flux de tracking **merchandising** dédié envoie les impressions et les clics sur les vitrines produits, listes de recommandations et surfaces similaires.

- **`EATpView`** — événements d'impression, envoyés via `GET /tpview/`
- **`EATpClick`** — événements de clic, envoyés via `GET /tpclick/`

Contrairement aux autres événements, qui sont envoyés en POST au collecteur standard, les événements merchandising sont envoyés sous forme de requêtes **GET** sur ces deux chemins dédiés. Si une requête échoue, le payload est stocké localement en solution de repli et rejoué avec le lot POST en attente.

Les requêtes sont construites ainsi :

```
https://<domain>/tpview/<siteName>/<campaignName>/<placement>/<siteName>/generic/<random>
       ?evprdr0=<ref>&evprdpos0=<position>&...&url=<encoded page url>&<global context>

https://<domain>/tpclick/<siteName>/<campaignName>/<placement>/<siteName>/generic/<random>
       ?ecprdr=<ref>&ecpos=<position>&ecnbr=<total>&eurl=<encoded landing url>&<global context>
```

Le SDK **ajoute automatiquement les paramètres de contexte global** à chaque requête merchandising — les mêmes valeurs que celles utilisées lors des appels au collecteur : `euidl`, `ea-appname`, `eos`, `ehw`, les identifiants publicitaires (`ea-android-adid` / `ea-ios-idfa` / `ea-ios-idfv`) et la qualification de l'appareil `edev` (`AppNativeIOSphone`, `AppNativeIOStablet`, `AppNativeAndroidphone`, `AppNativeAndroidtablet`), qui force la qualification du trafic en application native. Aucun code supplémentaire n'est nécessaire de votre côté.

L'identifiant de visiteur `uid` est lui aussi ajouté lorsqu'il est défini sur l'événement via `setUID()`, exactement comme lors des appels au collecteur.

Les deux modèles exposent les mêmes descripteurs de campagne : `siteName`, `campaignName`, `placement` et `url`. Notez la différence de signification de `url` : sur `EATpView`, il s'agit de l'**URL de la page courante** (envoyée en tant que `url`), sur `EATpClick`, il s'agit de l'**URL de destination** du produit cliqué (envoyée en tant que `eurl`).

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

| Méthode | Description |
| --- | --- |
| `addProduct(String ref, {int? position})` | Ajoute un produit affiché (avec sa position optionnelle dans le bloc) |
| `setProducts(List<List<dynamic>> products)` | Remplace l'intégralité de la liste de produits (entrées `[ref]` ou `[ref, position]`) |

### `EATpClick` — clic

```dart
final click = EATpClick(path: 'homepage')
  ..siteName = 'my-site'
  ..campaignName = 'summer_sale'
  ..placement = 'banner_top'
  ..url = 'https://example.com/home'
  ..setProduct('PROD_001', 2);

Eulerian.track([click]);
```

| Méthode | Description |
| --- | --- |
| `setProduct(String ref, int position, {int? totalProducts})` | Définit le produit cliqué, sa position et, en option, le nombre total de produits dans le bloc |
| `setProductMap(Map<String, dynamic> product)` | Définit le produit à partir d'une map brute (clés `ref`, `position`, `totalProducts`) |

## Propriétés globales

Le SDK attache automatiquement les propriétés suivantes à chaque payload, selon la plateforme :

| Nom de la propriété | EAPropertyKey | iOS | Android | Web |
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

> (\*) la propriété `url` correspond à l'identifiant de bundle sur iOS, au nom du package sur Android, et au chemin de l'URL courante sur le Web.

> (\**) `ea-ios-idfa` requiert l'option `requestTrackingAuthorization` lors de l'initialisation du SDK sur iOS.

## Configuration iOS 📱

Si vous prévoyez d'utiliser l'identifiant publicitaire (IDFA), mettez à jour le fichier `Info.plist` situé dans le répertoire `ios/Runner` et ajoutez la clé `NSUserTrackingUsageDescription` avec un message décrivant votre usage :

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized analytics.</string>
```

> Si votre application appelle l'API App Tracking Transparency, vous devez fournir une chaîne de description d'usage, qui s'affiche sous la forme d'une alerte système de permission.

Passez ensuite l'option `requestTrackingAuthorization` lors de l'initialisation du SDK pour solliciter l'utilisateur :

```dart
@override
void initState() {
  Eulerian.init('your.tracking-domain.com', requestTrackingAuthorization: true);
  super.initState();
}
```

## Reprise hors ligne

Les requêtes de tracking en échec (erreur réseau, réponse non 2xx) sont stockées dans le stockage local (`shared_preferences`) et automatiquement rejouées :

- au prochain appel à `Eulerian.track` (fusionnées avec le nouveau lot), ou
- au prochain lancement de l'application, une fois `Eulerian.init` terminé.

## Application d'exemple

Une application d'exemple complète (iOS / Android / Web) est disponible dans le répertoire [example/](example/).

## Licence

Voir [LICENSE](LICENSE).
