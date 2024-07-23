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

  static String formatDate(String dateTimeStr) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);

      // Tạo một định dạng ngày tiếng Việt
      final dayOfWeek = _getDayOfWeek(dateTime.weekday);
      final day = dateTime.day;
      final month = _getMonth(dateTime.month);
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return '$dayOfWeek, $day/$month, $hour:$minute';
    } catch (e) {
      return 'Ngày giờ không hợp lệ';
    }
  }

  static String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Thứ 2';
      case DateTime.tuesday:
        return 'Thứ 3';
      case DateTime.wednesday:
        return 'Thứ 4';
      case DateTime.thursday:
        return 'Thứ 5';
      case DateTime.friday:
        return 'Thứ 6';
      case DateTime.saturday:
        return 'Thứ 7';
      case DateTime.sunday:
        return 'Chủ nhật';
      default:
        return '';
    }
  }

  static String _getMonth(int month) {
    switch (month) {
      case 1:
        return '1';
      case 2:
        return '2';
      case 3:
        return '3';
      case 4:
        return '4';
      case 5:
        return '5';
      case 6:
        return '6';
      case 7:
        return '7';
      case 8:
        return '8';
      case 9:
        return '9';
      case 10:
        return '10';
      case 11:
        return '11';
      case 12:
        return '12';
      default:
        return '';
    }
  }
}
