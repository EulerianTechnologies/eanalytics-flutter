# EAnalytics — Flutter SDK

> [🇬🇧 English](README.md) · [🇫🇷 Français](README-fr.md) · 🇪🇸 Español · [🇮🇹 Italiano](README-it.md)

SDK oficial de Flutter para la plataforma de analítica aumentada de [Eulerian Technologies](https://eulerian.io/). Le permite rastrear páginas, productos, carritos, pedidos, búsquedas, acciones y eventos de merchandising (impresiones / clics) desde una única API, en **iOS**, **Android** y **Web**.

## Requisitos

| | |
| --- | --- |
| Flutter | `>=3.3.0` |
| Dart SDK | `>=2.18.0 <4.0.0` |
| Plataformas | iOS, Android, Web |

## Instalación

Añada el paquete a su aplicación:

```sh
flutter pub add eanalytics
```

O declárelo manualmente en su `pubspec.yaml`:

```yaml
dependencies:
  eanalytics: ^1.1.1
```

Luego impórtelo:

```dart
import 'package:eanalytics/eanalytics.dart';
```

## Inicio rápido

### 1. Inicializar el SDK

Llame a `Eulerian.init` **una sola vez**, antes de cualquier solicitud de seguimiento, en el nivel superior de su aplicación (por ejemplo, en el `initState` de su widget raíz). También intentará sincronizar los intentos de seguimiento fallidos almacenados localmente.

```dart
await Eulerian.init('your.tracking-domain.com');
```

| Parámetro | Tipo | Por defecto | Descripción |
| --- | --- | --- | --- |
| `domain` | `String` | — | Su dominio de seguimiento Eulerian dedicado (**no** debe contener `.eulerian.com`) |
| `requestTrackingAuthorization` | `bool` | `false` | Solo iOS — muestra al usuario el diálogo de App Tracking Transparency para recopilar el IDFA |
| `enableLogger` | `bool` | `true` | Activa / desactiva el registro del SDK en la consola |

### 2. Rastrear eventos

Llame a `Eulerian.track` desde cualquier parte de su aplicación con una lista de propiedades rastreables:

```dart
Eulerian.track([
  EAProducts(path: '/add/products')
    ..addProduct(Product(ref: 'p1', name: 'Product 1', group: 'test_group'))
]);
```

Los eventos estándar se envían como un lote **POST** al colector de Eulerian. Si la solicitud falla, las cargas útiles se almacenan localmente y se reintentan en la siguiente llamada a `Eulerian.track` o en el siguiente arranque de la aplicación (después de `Eulerian.init`).

## Referencia de la API

### `Eulerian` (singleton)

| Método | Descripción |
| --- | --- |
| `Eulerian.init(domain, {requestTrackingAuthorization, enableLogger})` | Inicializa el SDK y reenvía las cargas útiles almacenadas localmente |
| `Eulerian.track(List<EAProperty> properties)` | Rastrea una lista de propiedades. `EATpView` / `EATpClick` se envían vía GET, todo lo demás se agrupa en un único POST |
| `Eulerian.uid()` | Devuelve el identificador del dispositivo usado como `euidl` (Android ID en Android, `identifierForVendor` en iOS), o una cadena vacía si el SDK no está inicializado |

### `EAProperty` — evento rastreable base

`EAProperty` es la clase base de todos los eventos rastreables. También puede usarse directamente para rastrear una simple vista de página. El constructor requiere un `path` (la ruta de la página; se añade automáticamente una `/` inicial si falta).

```dart
Eulerian.track([
  EAProperty(path: '/home')
    ..setEmail('johndoe@example.com')
    ..setUID('user-42')
    ..setPageGroup('homepage')
]);
```

Setters disponibles (heredados por todos los modelos de eventos):

| Método | Clave del payload | Descripción |
| --- | --- | --- |
| `setPath(String path)` | `path` | Ruta de la página del evento |
| `setLocation({latitude, longitude})` | `ea-lat`, `ea-lon` | Coordenadas geográficas |
| `setNewCustomer(bool isNew)` | `newcustomer` | Marca al visitante como nuevo cliente (`1` / `0`) |
| `setStandalone()` | `ereplay-notag` | Marca el hit como una llamada independiente (sin contar una vista de página) |
| `setEmail(String email)` | `email` | Dirección de correo electrónico del visitante |
| `setLabel(String label)` | `pagelabel` | Etiqueta de la página (se permiten valores separados por comas) |
| `setUID(String uid)` | `uid` | Su propio identificador de visitante |
| `setProfile(String profile)` | `profile` | Perfil del visitante |
| `setPageGroup(String group)` | `pagegroup` | Grupo de páginas |
| `setAction(Action action)` | `action` | Adjunta una [`Action`](#action) a la página |
| `setProperty(SiteCentric property)` | `property` | Propiedades site-centric |
| `setCFlag(SiteCentric cFlag)` | `cflag` | Indicadores de conversión site-centric |
| `setCustomParam(String key, String value)` | `<key>` | Par clave/valor personalizado arbitrario |

### Modelos de eventos

Todos los modelos siguientes extienden `EAProperty`, por lo que todos los setters anteriores también están disponibles en ellos.

#### `EAProducts` — visualización de productos

Rastrea la visualización de uno o varios productos.

```dart
Eulerian.track([
  EAProducts(path: '/product/page')
    ..addProduct(Product(ref: 'p1', name: 'Product 1', group: 'shoes'))
    ..addProduct(Product(ref: 'p2', name: 'Product 2', group: 'shoes')),
]);
```

| Método | Descripción |
| --- | --- |
| `addProduct(Product product)` | Añade un producto a la lista `products` |

#### `EACart` — carrito de compra

Rastrea el contenido del carrito del visitante. El indicador `scart` se establece automáticamente.

```dart
Eulerian.track([
  EACart(path: '/cart')
    ..setCartCumul(true)
    ..addProduct(product: Product(ref: 'p1'), amount: 19.99, quantity: 2),
]);
```

| Método | Descripción |
| --- | --- |
| `setCartCumul(bool cumul)` | Si es `true`, el carrito es acumulativo (`scartcumul`) |
| `addProduct({product, amount, quantity})` | Añade un producto; `amount` / `quantity` se aplican al producto si aún no están definidos en él |

#### `EAEstimate` — presupuesto / cotización

Rastrea un presupuesto (preventa). El indicador `estimate` se establece automáticamente.

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

| Método | Clave del payload | Descripción |
| --- | --- | --- |
| `setAmount(double amount)` | `amount` | Importe total |
| `setCurrency(String currency)` | `currency` | Código de moneda |
| `setType(String type)` | `type` | Tipo de presupuesto |
| `setPayment(String payment)` | `payment` | Método de pago |
| `addProduct({product, amount, quantity})` | `products` | Añade un producto al presupuesto |

#### `EAOrder` — compra

Rastrea un pedido confirmado. Extiende `EAEstimate`, por lo que todos sus setters están disponibles. El constructor vincula el pedido a un presupuesto previo mediante `estimateRef`.

```dart
Eulerian.track([
  EAOrder(path: '/order/confirmation', estimateRef: 'EST-001')
    ..setAmount(149.90)
    ..setCurrency('EUR')
    ..setPayment('card')
    ..addProduct(product: Product(ref: 'p1'), amount: 149.90, quantity: 1),
]);
```

| Método | Clave del payload | Descripción |
| --- | --- | --- |
| `setEstimateRef(String ref)` | `estimateref` | Referencia del presupuesto de origen |

#### `EASearch` — motor de búsqueda interno

Rastrea una consulta en su motor de búsqueda interno.

```dart
Eulerian.track([
  EASearch(
    path: '/search',
    search: Search(name: 'shoes', results: 42),
  ),
]);
```

#### `EAActions` — acciones de usuario

Rastrea una o varias acciones de usuario (clics, interacciones…). Combínelo con `setStandalone()` para hits de solo acciones que no deban contarse como una vista de página.

```dart
Eulerian.track([
  EAActions(path: '')
    ..setStandalone()
    ..addAction(Action(name: 'button1', mode: 'in'))
    ..addAction(Action(name: 'newsletter', label: 'footer')
      ..setParams(Params()..addParam('input', 'test'))),
]);
```

| Método | Descripción |
| --- | --- |
| `addAction(Action action)` | Añade una [`Action`](#action) a la lista `actions` |

### Clases auxiliares

Estas clases son los componentes básicos de los modelos de eventos anteriores.

#### `Product`

```dart
Product(
  ref: 'p1',                       // obligatorio
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

`name` es obligatorio; `mode`, `label` y `ref` son opcionales.

#### `Params`

Parámetros clave/valor arbitrarios que pueden adjuntarse a productos, acciones y búsquedas.

```dart
Params.fromEntries([MapEntry('foo', 'bar'), MapEntry('baz', [1, 2, 3])]);
// o bien
Params()..addParam('foo', 'bar');
```

#### `Search`

Describe una búsqueda interna para `EASearch`: `Search(name: 'shoes', results: 42, parameters: Params()...)`.

#### `SiteCentric`

Pares clave/valor site-centric (cada valor es una lista de cadenas) para `setProperty` / `setCFlag`:

```dart
SiteCentric()..addParam('prop', ['foo', 'baz']);
```

## Seguimiento de merchandising (`EATpView` / `EATpClick`)

Un flujo de seguimiento dedicado de **merchandising** envía las impresiones y los clics en escaparates de productos, listas de recomendaciones y superficies similares.

- **`EATpView`** — eventos de impresión, enviados mediante `GET /tpview/`
- **`EATpClick`** — eventos de clic, enviados mediante `GET /tpclick/`

A diferencia de los demás eventos, que se envían por POST al colector estándar, los eventos de merchandising se envían como solicitudes **GET** a estas dos rutas dedicadas. Si una solicitud falla, la carga útil se almacena localmente como respaldo y se reenvía junto con el lote POST pendiente.

Las solicitudes se construyen así:

```
https://<domain>/tpview/<siteName>/<campaignName>/<placement>/<siteName>/generic/<random>
       ?evprdr0=<ref>&evprdpos0=<position>&...&url=<encoded page url>&<global context>

https://<domain>/tpclick/<siteName>/<campaignName>/<placement>/<siteName>/generic/<random>
       ?ecprdr=<ref>&ecpos=<position>&ecnbr=<total>&eurl=<encoded landing url>&<global context>
```

El SDK **añade automáticamente los parámetros de contexto global** a cada solicitud de merchandising — los mismos valores usados en las llamadas al colector: `euidl`, `ea-appname`, `eos`, `ehw`, los identificadores publicitarios (`ea-android-adid` / `ea-ios-idfa` / `ea-ios-idfv`) y la cualificación de dispositivo `edev` (`AppNativeIOSphone`, `AppNativeIOStablet`, `AppNativeAndroidphone`, `AppNativeAndroidtablet`), que fuerza a que el tráfico se cualifique como aplicación nativa. No se necesita ningún código adicional por su parte.

El identificador de visitante `uid` también se añade cuando se ha definido en el evento mediante `setUID()`, exactamente igual que en las llamadas al colector.

Ambos modelos exponen los mismos descriptores de campaña: `siteName`, `campaignName`, `placement` y `url`. Tenga en cuenta el significado diferente de `url`: en `EATpView` es la **URL de la página actual** (enviada como `url`), en `EATpClick` es la **URL de destino** del producto clicado (enviada como `eurl`).

### `EATpView` — impresión

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

| Método | Descripción |
| --- | --- |
| `addProduct(String ref, {int? position})` | Añade un producto mostrado (con su posición opcional en el bloque) |
| `setProducts(List<List<dynamic>> products)` | Sustituye la lista completa de productos (entradas `[ref]` o `[ref, position]`) |

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

| Método | Descripción |
| --- | --- |
| `setProduct(String ref, int position, {int? totalProducts})` | Define el producto clicado, su posición y opcionalmente el número total de productos del bloque |
| `setProductMap(Map<String, dynamic> product)` | Define el producto a partir de un mapa sin procesar (claves `ref`, `position`, `totalProducts`) |

## Propiedades globales

El SDK adjunta automáticamente las siguientes propiedades a cada carga útil, según la plataforma:

| Nombre de la propiedad | EAPropertyKey | iOS | Android | Web |
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

> (\*) la propiedad `url` se corresponde con el identificador de bundle en iOS, el nombre del paquete en Android y la ruta de la URL actual en Web.

> (\**) `ea-ios-idfa` requiere el indicador `requestTrackingAuthorization` al inicializar el SDK en iOS.

## Configuración en iOS 📱

Si tiene previsto usar el identificador publicitario (IDFA), actualice el archivo `Info.plist` ubicado en el directorio `ios/Runner` y añada la clave `NSUserTrackingUsageDescription` con un mensaje que describa su uso:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized analytics.</string>
```

> Si su aplicación llama a la API de App Tracking Transparency, debe proporcionar una cadena de descripción de uso, que se muestra como una alerta de permiso del sistema.

A continuación, pase el indicador `requestTrackingAuthorization` al inicializar el SDK para mostrar el diálogo al usuario:

```dart
@override
void initState() {
  Eulerian.init('your.tracking-domain.com', requestTrackingAuthorization: true);
  super.initState();
}
```

## Reintento sin conexión

Las solicitudes de seguimiento que fallan (error de red, respuesta no 2xx) se almacenan en el almacenamiento local (`shared_preferences`) y se reenvían automáticamente:

- en la siguiente llamada a `Eulerian.track` (fusionadas con el nuevo lote), o
- en el siguiente arranque de la aplicación, cuando `Eulerian.init` finaliza.

## Aplicación de ejemplo

Una aplicación de ejemplo completa (iOS / Android / Web) está disponible en el directorio [example/](example/).

## Licencia

Consulte [LICENSE](LICENSE).
