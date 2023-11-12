import 'package:intl/intl.dart';

removeTrailingZerosAndNumberfy(String n) {
  if(n.contains('.')){
    return double.parse(
        n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "") //remove all trailing 0's and extra decimals at end if any
    );
  }
  else{
    return double.parse(
        n
    );
  }
}

removeTrailingZeros(double value) {
  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 3,
  );

  final String formatted = formatter.format(value);
  return formatted.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
}