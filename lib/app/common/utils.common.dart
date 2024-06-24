String formatNumber(double number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K';
  } else {
    return number.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
  }
}
