import 'package:currency_formatter/currency_formatter.dart';
import 'package:intl/intl.dart';

class Helpers {
  static String assetUrl = 'assets';
  static String imgUrl = '$assetUrl/images';
  static String appName = 'Hufniture';
  static CurrencyFormat currencySettings = const CurrencyFormat(
    code: 'vnd',
    symbol: 'đ',
    symbolSide: SymbolSide.right,
    thousandSeparator: '.',
    decimalSeparator: ',',
    symbolSeparator: ' ',
  );

  static String formatPrice(double price) {
    return CurrencyFormatter.format(price, Helpers.currencySettings,
        decimal: 3);
  }

  static String formatOrderDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("E, d MMM  - HH:mm").format(now);
    return formattedDate;
  }
}
