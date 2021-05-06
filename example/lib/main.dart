import 'package:eanalytics/eanalytics.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home('EAnalytics Integration')));
}

class Home extends StatefulWidget {
  Home(this.title) : super();
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    Eulerian.init('et.eulerian.net', requestTrackingAuthorization: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eularian Analytics TRACKERS'),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: [
          OutlinedButton(
            onPressed: () {
              Eulerian.track([new EAProperty()]);
            },
            child: Text('EAProperty'),
          ),
          OutlinedButton(
            onPressed: () {
              final params = Params();
              params.addParam('foo', 'bar');
              params.addParam('baz', [1, 2, 3]);

              final product = Product(ref: 'p1', name: 'Product 1', group: 'group_of_doom', parameters: params);
              Eulerian.track([new EAProducts()..addProduct(product)]);
            },
            child: Text('Single product'),
          ),
          OutlinedButton(
            onPressed: () {
              final params = Params();
              params.addParam('foo', {'baz': 'bar'});

              final p1 = Product(ref: 'p1', name: 'Product 1', group: 'group_of_doom');
              final p2 = Product(ref: 'p2', name: 'Product 2', group: 'group_of_doom', parameters: params);
              Eulerian.track([new EAProducts()..addProduct(p1)..addProduct(p2)]);
            },
            child: Text('Multiple products'),
          )
        ],
      ),
    );
  }
}
