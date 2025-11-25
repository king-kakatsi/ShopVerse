import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for fetching real-time Bitcoin price from CoinGecko API
class BitcoinService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  static const String _priceEndpoint = '/simple/price';

  /// Fetch current Bitcoin price in XAF (Central African CFA franc)
  /// Returns price in FCFA or null if request fails
  Future<double?> getCurrentPrice() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl$_priceEndpoint?ids=bitcoin&vs_currencies=xaf'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final price = data['bitcoin']['xaf'];
        return price?.toDouble();
      } else {
        print('Bitcoin API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching Bitcoin price: $e');
      return null;
    }
  }

  /// Fetch Bitcoin price with USD for reference
  Future<Map<String, double>?> getPriceWithUSD() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl$_priceEndpoint?ids=bitcoin&vs_currencies=xaf,usd',
            ),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'xaf': data['bitcoin']['xaf']?.toDouble() ?? 0.0,
          'usd': data['bitcoin']['usd']?.toDouble() ?? 0.0,
        };
      }
      return null;
    } catch (e) {
      print('Error fetching Bitcoin price: $e');
      return null;
    }
  }
}
