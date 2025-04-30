class WaveDateUtils {
  /// Returns formatted date like: 14 April 2005
  static String formatDate(DateTime dateTime) =>
      '${dateTime.day} ${_monthName(dateTime.month)} ${dateTime.year}';

  /// Returns formatted time like: 12:00 PM
  static String formatTime(DateTime dateTime) =>
      '${dateTime.hour}:${dateTime.minute} ${dateTime.hour < 12 ? 'AM' : 'PM'}';

  /// Returns relative time like "10 minutes ago", "1 hour ago", etc.
  /// If more than a year ago, returns full formatted date.
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minute${_plural(diff.inMinutes)} ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hour${_plural(diff.inHours)} ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} day${_plural(diff.inDays)} ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks week${_plural(weeks)} ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months month${_plural(months)} ago';
    } else {
      return formatDate(dateTime); // More than a year ago
    }
  }

  /// Helper to get month name
  static String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }

  /// Adds 's' for plural
  static String _plural(int count) => count == 1 ? '' : 's';
}
