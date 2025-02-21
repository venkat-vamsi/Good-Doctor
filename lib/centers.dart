import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autism Centers Nearby',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // WebViewController for the WebView
  late final WebViewController _webViewController;

  // Google Maps link
  final String _mapsUrl =
      'https://www.google.com/maps/search/?api=1&query=17.4065,78.4772';

  @override
  void initState() {
    super.initState();

    // Initialize the WebViewController
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..loadRequest(Uri.parse(_mapsUrl)); // Load the Google Maps URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autism Centers Nearby'),
      ),
      body: Column(
        children: [
          // WebView to display Google Maps
          Expanded(
            child: WebViewWidget(
              controller: _webViewController,
            ),
          ),
          // List of autism centers
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildCenterCard(
                  name: 'Flora Autism',
                  address: 'Kukatpally',
                  phone: '9084554602',
                ),
                _buildCenterCard(
                  name: 'Autistic speciality',
                  address: 'Jubille Hills',
                  phone: '8054618372',
                ),
                _buildCenterCard(
                  name: 'AutismTeach',
                  address: 'Nizampet',
                  phone: '77895134681',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterCard(
      {required String name, required String address, required String phone}) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              address,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              phone,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
