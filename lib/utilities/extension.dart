// ignore_for_file: inference_failure_on_instance_creation

import "package:picsa/utilities/color_constants.dart";

import "../utilities/packages.dart";
import "size_config.dart";

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.capitalize())
      .join(' ');

  String toException() {
    return split(":")[1].trim();
  }

  String toCamelCase() {
    return this[0].toLowerCase() + substring(1);
  }

  String toDate() {
    final date = DateTime.parse(this);
    return DateFormat.yMMMMd().format(date);
  }

  String toAgo() {
    final date = DateTime.parse(this);
    final diff = DateTime.now().difference(date);
    return diff.toString();
  }
}

extension ErrorToast on BuildContext {
  void showErrorToast({
    required String title,
    required String message,
    required BuildContext context,
  }) {
    Toastification().show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: red,
          fontWeight: FontWeight.w600,
        ),
      ),
      description: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: red,
          fontWeight: FontWeight.w400,
        ),
      ),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  void showSuccessToast(
      {required String title,
      required String message,
      required BuildContext context}) {
    Toastification().show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: green,
          fontWeight: FontWeight.w600,
        ),
      ),
      description: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: green,
          fontWeight: FontWeight.w400,
        ),
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
    return;
  }

  void showInfoToast(
      {required String title,
      required String message,
      required BuildContext context}) {
    Toastification().show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 2.2 * SizeConfig.textMultiplier,
          color: Color.fromARGB(255, 209, 157, 11),
          fontWeight: FontWeight.w600,
        ),
      ),
      description: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 1.8 * SizeConfig.textMultiplier,
          color: const Color(0xff606873),
          fontWeight: FontWeight.w400,
        ),
      ),
      icon: const Icon(
        Icons.close,
        size: 20,
        color: Color(0xff606873),
      ),
      alignment: Alignment.bottomCenter,
      closeOnClick: true,
      autoCloseDuration: const Duration(seconds: 10),
    );
  }

  void showSuccessSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 2 * SizeConfig.textMultiplier,
            color: white,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        backgroundColor: green,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showInfoSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 2 * SizeConfig.textMultiplier,
            color: white,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        backgroundColor: green,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showWarningSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 2 * SizeConfig.textMultiplier,
            color: white,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.yellow.shade700,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showErrorSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 2 * SizeConfig.textMultiplier,
            color: white,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 230, 82, 82),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void hideToast() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  void debouncer({required Duration duration}) {
    Future.delayed(duration);
    return;
  }

  
}
