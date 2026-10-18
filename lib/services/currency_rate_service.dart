import 'dart:convert';
import 'package:http/http.dart' as http;
import 'apis.dart';

class CurrencyRateService {
  /// Fetches the exchange rate between [fromCurrency] and [toCurrency].
  /// Returns the exchange rate as a [double], or `null` if the request fails.
  static Future<double?> getExchangeRate(
    String fromCurrency,
    String toCurrency,
  ) async {
    try {
      final url = Uri.parse('${Apis.currencyApi}/$fromCurrency');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = data['rates']?[toCurrency];
        if (rate is num) {
          return rate.toDouble();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetches all exchange rates for a given [baseCurrency].
  /// Returns a Map of rates data, or `null` if the request fails.
  static Future<Map<String, dynamic>?> getRates(String baseCurrency) async {
    try {
      final url = Uri.parse('${Apis.currencyApi}/$baseCurrency');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
