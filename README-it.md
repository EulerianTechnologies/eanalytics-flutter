# EAnalytics — Flutter SDK

> [🇬🇧 English](README.md) · [🇫🇷 Français](README-fr.md) · [🇪🇸 Español](README-es.md) · 🇮🇹 Italiano

SDK Flutter ufficiale per la piattaforma di analisi aumentata [Eulerian Technologies](https://eulerian.io/). Permette di tracciare pagine, prodotti, carrelli, ordini, ricerche, azioni ed eventi merchandise (impression / clic) da un'unica API, su **iOS**, **Android** e **Web**.

## Requisiti

| | |
| --- | --- |
| Flutter | `>=3.3.0` |
| Dart SDK | `>=2.18.0 <4.0.0` |
| Piattaforme | iOS, Android, Web |

## Installazione

Aggiungi il pacchetto alla tua app:

```sh
flutter pub add eanalytics
```

Oppure dichiaralo manualmente nel tuo `pubspec.yaml`:

```yaml
dependencies:
  eanalytics: ^1.1.1
```

Quindi importalo:

```dart
import 'package:eanalytics/eanalytics.dart';
```

## Guida rapida

### 1. Inizializza l'SDK

Chiama `Eulerian.init` **una sola volta**, prima di qualsiasi richiesta di tracciamento, al livello più alto della tua app (ad es. nell'`initState` del widget radice). Tenterà inoltre di sincronizzare gli eventuali tentativi di tracciamento falliti memorizzati localmente.

```dart
await Eulerian.init('your.tracking-domain.com');
```

| Parametro | Tipo | Predefinito | Descrizione |
| --- | --- | --- | --- |
| `domain` | `String` | — | Il tuo dominio di tracciamento Eulerian dedicato (**non** deve contenere `.eulerian.com`) |
| `requestTrackingAuthorization` | `bool` | `false` | Solo iOS — mostra all'utente la finestra di dialogo App Tracking Transparency per raccogliere l'IDFA |
| `enableLogger` | `bool` | `true` | Abilita / disabilita la registrazione su console dell'SDK |

### 2. Traccia gli eventi

Chiama `Eulerian.track` da qualsiasi punto della tua app con una lista di proprietà tracciabili:

```dart
Eulerian.track([
  EAProducts(path: '/add/products')
    ..addProduct(Product(ref: 'p1', name: 'Product 1', group: 'test_group'))
]);
```

Gli eventi standard vengono inviati come batch **POST** al collector Eulerian. Se la richiesta fallisce, i payload vengono memorizzati localmente e ritentati alla successiva chiamata di `Eulerian.track` oppure al successivo avvio dell'app (dopo `Eulerian.init`).

## Riferimento API

### `Eulerian` (singleton)

| Metodo | Descrizione |
| --- | --- |
| `Eulerian.init(domain, {requestTrackingAuthorization, enableLogger})` | Inizializza l'SDK e ritrasmette i payload memorizzati localmente |
| `Eulerian.track(List<EAProperty> properties)` | Traccia una lista di proprietà. `EATpView` / `EATpClick` vengono inviati via GET, tutto il resto viene raggruppato in un'unica POST |
| `Eulerian.uid()` | Restituisce l'identificatore del dispositivo usato come `euidl` (Android ID su Android, `identifierForVendor` su iOS), oppure una stringa vuota se l'SDK non è inizializzato |

### `EAProperty` — evento tracciabile di base

`EAProperty` è la classe di base di ogni evento tracciabile. Può anche essere usata direttamente per tracciare una semplice visualizzazione di pagina. Il costruttore richiede un `path` (il percorso della pagina; se manca, il carattere `/` iniziale viene aggiunto automaticamente).

```dart
Eulerian.track([
  EAProperty(path: '/home')
    ..setEmail('johndoe@example.com')
    ..setUID('user-42')
    ..setPageGroup('homepage')
]);
```

Setter disponibili (ereditati da tutti i modelli di evento):

| Metodo | Chiave payload | Descrizione |
| --- | --- | --- |
| `setPath(String path)` | `path` | Percorso della pagina dell'evento |
| `setLocation({latitude, longitude})` | `ea-lat`, `ea-lon` | Coordinate geografiche |
| `setNewCustomer(bool isNew)` | `newcustomer` | Contrassegna il visitatore come nuovo cliente (`1` / `0`) |
| `setStandalone()` | `ereplay-notag` | Contrassegna l'hit come chiamata autonoma (nessuna visualizzazione di pagina conteggiata) |
| `setEmail(String email)` | `email` | Indirizzo e-mail del visitatore |
| `setLabel(String label)` | `pagelabel` | Etichetta della pagina (sono ammessi valori separati da virgola) |
| `setUID(String uid)` | `uid` | Il tuo identificatore visitatore personalizzato |
| `setProfile(String profile)` | `profile` | Profilo del visitatore |
| `setPageGroup(String group)` | `pagegroup` | Gruppo di pagine |
| `setAction(Action action)` | `action` | Associa una [`Action`](#action) alla pagina |
| `setProperty(SiteCentric property)` | `property` | Proprietà site-centric |
| `setCFlag(SiteCentric cFlag)` | `cflag` | Flag di conversione site-centric |
| `setCustomParam(String key, String value)` | `<key>` | Coppia chiave/valore personalizzata arbitraria |

### Modelli di evento

Tutti i modelli seguenti estendono `EAProperty`, quindi anche su di essi è disponibile ogni setter sopra elencato.

#### `EAProducts` — visualizzazione di prodotti

Traccia la visualizzazione di uno o più prodotti.

```dart
Eulerian.track([
  EAProducts(path: '/product/page')
    ..addProduct(Product(ref: 'p1', name: 'Product 1', group: 'shoes'))
    ..addProduct(Product(ref: 'p2', name: 'Product 2', group: 'shoes')),
]);
```

| Metodo | Descrizione |
| --- | --- |
| `addProduct(Product product)` | Aggiunge un prodotto alla lista `products` |

#### `EACart` — carrello

Traccia il contenuto del carrello del visitatore. Il flag `scart` viene impostato automaticamente.

```dart
Eulerian.track([
  EACart(path: '/cart')
    ..setCartCumul(true)
    ..addProduct(product: Product(ref: 'p1'), amount: 19.99, quantity: 2),
]);
```

| Metodo | Descrizione |
| --- | --- |
| `setCartCumul(bool cumul)` | Se `true`, il carrello è cumulativo (`scartcumul`) |
| `addProduct({product, amount, quantity})` | Aggiunge un prodotto; `amount` / `quantity` vengono applicati al prodotto se non già impostati su di esso |

#### `EAEstimate` — preventivo

Traccia un preventivo (pre-vendita). Il flag `estimate` viene impostato automaticamente.

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

| Metodo | Chiave payload | Descrizione |
| --- | --- | --- |
| `setAmount(double amount)` | `amount` | Importo totale |
| `setCurrency(String currency)` | `currency` | Codice valuta |
| `setType(String type)` | `type` | Tipo di preventivo |
| `setPayment(String payment)` | `payment` | Metodo di pagamento |
| `addProduct({product, amount, quantity})` | `products` | Aggiunge un prodotto al preventivo |

#### `EAOrder` — acquisto

Traccia un ordine confermato. Estende `EAEstimate`, quindi tutti i suoi setter sono disponibili. Il costruttore collega l'ordine a un preventivo precedente tramite `estimateRef`.

```dart
Eulerian.track([
  EAOrder(path: '/order/confirmation', estimateRef: 'EST-001')
    ..setAmount(149.90)
    ..setCurrency('EUR')
    ..setPayment('card')
    ..addProduct(product: Product(ref: 'p1'), amount: 149.90, quantity: 1),
]);
```

| Metodo | Chiave payload | Descrizione |
| --- | --- | --- |
| `setEstimateRef(String ref)` | `estimateref` | Riferimento del preventivo di origine |

#### `EASearch` — motore di ricerca interno

Traccia una query sul tuo motore di ricerca interno.

```dart
Eulerian.track([
  EASearch(
    path: '/search',
    search: Search(name: 'shoes', results: 42),
  ),
]);
```

#### `EAActions` — azioni utente

Traccia una o più azioni utente (clic, interazioni…). Combinalo con `setStandalone()` per hit di sole azioni che non devono essere conteggiati come visualizzazione di pagina.

```dart
Eulerian.track([
  EAActions(path: '')
    ..setStandalone()
    ..addAction(Action(name: 'button1', mode: 'in'))
    ..addAction(Action(name: 'newsletter', label: 'footer')
      ..setParams(Params()..addParam('input', 'test'))),
]);
```

| Metodo | Descrizione |
| --- | --- |
| `addAction(Action action)` | Aggiunge una [`Action`](#action) alla lista `actions` |

### Classi di supporto

Queste classi sono i mattoni di base dei modelli di evento sopra descritti.

#### `Product`

```dart
Product(
  ref: 'p1',                       // obbligatorio
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

`name` è obbligatorio; `mode`, `label` e `ref` sono facoltativi.

#### `Params`

Parametri chiave/valore arbitrari associabili a prodotti, azioni e ricerche.

```dart
Params.fromEntries([MapEntry('foo', 'bar'), MapEntry('baz', [1, 2, 3])]);
// oppure
Params()..addParam('foo', 'bar');
```

#### `Search`

Descrive una ricerca interna per `EASearch`: `Search(name: 'shoes', results: 42, parameters: Params()...)`.

#### `SiteCentric`

Coppie chiave/valore site-centric (ogni valore è una lista di stringhe) per `setProperty` / `setCFlag`:

```dart
SiteCentric()..addParam('prop', ['foo', 'baz']);
```

## Tracciamento merchandise (`EATpView` / `EATpClick`)

Un flusso di tracciamento **merchandise** dedicato invia le impression e i clic su vetrine di prodotti, liste di raccomandazioni e superfici simili.

- **`EATpView`** — eventi di impression, inviati su `GET /tpview/`
- **`EATpClick`** — eventi di clic, inviati su `GET /tpclick/`

A differenza degli altri eventi, che vengono inviati in POST al collector standard, gli eventi merchandise vengono inviati come richieste **GET** su questi due percorsi dedicati. Se una richiesta fallisce, il payload viene memorizzato localmente come fallback e ritrasmesso con il batch POST in sospeso.

Le richieste sono costruite così:

```
https://<domain>/tpview/<siteName>/<campaignName>/<placement>/<siteName>/generic/<random>
       ?evprdr0=<ref>&evprdpos0=<position>&...&url=<encoded page url>&<global context>

https://<domain>/tpclick/<siteName>/<campaignName>/<placement>/<siteName>/generic/<random>
       ?ecprdr=<ref>&ecpos=<position>&ecnbr=<total>&eurl=<encoded landing url>&<global context>
```

L'SDK **aggiunge automaticamente i parametri di contesto globale** a ogni richiesta merchandise — gli stessi valori usati nelle chiamate al collector: `euidl`, `ea-appname`, `eos`, `ehw`, gli identificatori pubblicitari (`ea-android-adid` / `ea-ios-idfa` / `ea-ios-idfv`) e la qualificazione del dispositivo `edev` (`AppNativeIOSphone`, `AppNativeIOStablet`, `AppNativeAndroidphone`, `AppNativeAndroidtablet`), che impone la qualificazione del traffico come applicazione nativa. Non è necessario alcun codice aggiuntivo da parte tua.

Anche l'identificatore visitatore `uid` viene aggiunto quando impostato sull'evento tramite `setUID()`, esattamente come nelle chiamate al collector.

Entrambi i modelli espongono gli stessi descrittori di campagna: `siteName`, `campaignName`, `placement` e `url`. Nota il diverso significato di `url`: su `EATpView` è l'**URL della pagina corrente** (inviato come `url`), su `EATpClick` è l'**URL di destinazione** del prodotto cliccato (inviato come `eurl`).

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

| Metodo | Descrizione |
| --- | --- |
| `addProduct(String ref, {int? position})` | Aggiunge un prodotto visualizzato (con la sua posizione facoltativa nel blocco) |
| `setProducts(List<List<dynamic>> products)` | Sostituisce l'intera lista di prodotti (voci `[ref]` oppure `[ref, position]`) |

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

| Metodo | Descrizione |
| --- | --- |
| `setProduct(String ref, int position, {int? totalProducts})` | Imposta il prodotto cliccato, la sua posizione e, facoltativamente, il numero totale di prodotti nel blocco |
| `setProductMap(Map<String, dynamic> product)` | Imposta il prodotto a partire da una mappa grezza (chiavi `ref`, `position`, `totalProducts`) |

## Proprietà globali

L'SDK allega automaticamente le seguenti proprietà a ogni payload, a seconda della piattaforma:

| Nome proprietà | EAPropertyKey | iOS | Android | Web |
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

> (\*) la proprietà `url` corrisponde al bundle identifier su iOS, al nome del package su Android e al percorso URL corrente su Web.

> (\**) `ea-ios-idfa` richiede il flag `requestTrackingAuthorization` all'inizializzazione dell'SDK su iOS.

## Configurazione iOS 📱

Se prevedi di usare l'identificatore pubblicitario (IDFA), aggiorna il file `Info.plist` situato nella directory `ios/Runner` e aggiungi la chiave `NSUserTrackingUsageDescription` con un messaggio che descriva il tuo utilizzo:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized analytics.</string>
```

> Se la tua app chiama l'API App Tracking Transparency, devi fornire una stringa di descrizione dell'utilizzo, che viene mostrata come avviso di autorizzazione di sistema.

Passa quindi il flag `requestTrackingAuthorization` all'inizializzazione dell'SDK per mostrare la richiesta all'utente:

```dart
@override
void initState() {
  Eulerian.init('your.tracking-domain.com', requestTrackingAuthorization: true);
  super.initState();
}
```

## Ritrasmissione offline

Le richieste di tracciamento che falliscono (errore di rete, risposta non 2xx) vengono memorizzate nello storage locale (`shared_preferences`) e ritrasmesse automaticamente:

- alla successiva chiamata di `Eulerian.track` (unite al nuovo batch), oppure
- al successivo avvio dell'app, al completamento di `Eulerian.init`.

## App di esempio

Un'app di esempio completa (iOS / Android / Web) è disponibile nella directory [example/](example/).

## Licenza

Vedi [LICENSE](LICENSE).
