
import 'package:picsa/utilities/packages.dart';

final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.white,
    secondaryHeaderColor: secondaryColor,
    scaffoldBackgroundColor: primaryColor,
    cardColor: primaryColor,
    primaryColorDark: const Color(0xff1E1E1E),
    textTheme: TextTheme(
      titleMedium: GoogleFonts.inter(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.grey[300]!,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.grey[300]!,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF181A21),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF181A21),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xffffffff),
      size: 20,
    ),
    brightness: Brightness.dark,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xff1E1E1E),
      elevation: 0,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey[100]!,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xff1E1E1E),
      border: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30)),
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xffffffff),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[500]!,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          )),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shadowColor: primaryColor,
          foregroundColor: primaryColor,
          enableFeedback: false,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: const BorderSide(
            color: Colors.white,
          ),
          surfaceTintColor: primaryColor,
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          )),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xffffffff),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey[400]!,
      thickness: 1,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: primaryColor,
      surfaceTintColor: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: const Color(0xffffffff),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!, width: 0.2),
            borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!, width: 0.2),
            borderRadius: BorderRadius.circular(25)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
            borderRadius: BorderRadius.circular(25)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 0.2,
            ),
            borderRadius: BorderRadius.circular(25)),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xffffffff),
        ),
        errorStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[200]!,
        ),
      ),
    ));

// final lightTheme = ThemeData(
//   useMaterial3: true,
//   primaryColor: primaryColor,
//   primaryColorDark: const Color(0xffF8FAF9),
//   secondaryHeaderColor: Colors.white,
//   scaffoldBackgroundColor: Colors.white,
//   cardColor:primaryColor,
//   textTheme: TextTheme(
//     titleMedium: GoogleFonts.inter(
//       fontSize: 16.0,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
//     ),
//     titleSmall: GoogleFonts.inter(
//       fontSize: 14.0,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
//     ),
//     bodyMedium: GoogleFonts.inter(
//       fontSize: 16.0,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
//     ),
//     bodySmall: GoogleFonts.inter(
//       fontSize: 14.0,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
//     ),
//     displayLarge: GoogleFonts.inter(
//       fontSize: 16.0,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
      

//     ),
//     displayMedium: GoogleFonts.inter(
//       fontSize: 14.0,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
//     ),
//     displaySmall: GoogleFonts.inter(
//       fontSize: 12.0,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
//     ),
//     headlineLarge: GoogleFonts.inter(
//       fontSize: 16.0,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
//     ),
//     headlineMedium: GoogleFonts.inter(
//       fontSize: 14.0,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
//     ),
//     headlineSmall: GoogleFonts.inter(
//       fontSize: 12.0,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
//     ),
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: Colors.white,
//     elevation: 0,
//     systemOverlayStyle: const SystemUiOverlayStyle(
//       statusBarColor: Colors.white,
//       statusBarIconBrightness: Brightness.dark,
//     ),
//     titleTextStyle: GoogleFonts.inter(
//       fontSize: 16.0,
//       fontWeight: FontWeight.w500,
//       color: const Color(0xFF181A21),
//     ),
//   ),
//   iconTheme: const IconThemeData(
//     color: Color(0xff000000),
//     size: 20,
//   ),
//   datePickerTheme: DatePickerThemeData(
//       backgroundColor: Colors.white,
//       surfaceTintColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
      
//     ),
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     backgroundColor: Color.fromARGB(255, 237, 240, 239),
//     elevation: 0,
//     selectedItemColor: primary,
//     unselectedItemColor: Color(0xFF474849),
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     fillColor: const Color(0xffFBFBFD),
//     filled: true,
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(25),
//       borderSide: const BorderSide(color: primaryColor, width: 0.4),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(25),
//       borderSide: const BorderSide(color: primaryColor, width: 0.4),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(25),
//       borderSide: const BorderSide(color: primaryColor, width: 2),
//     ),
//     errorBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: red, width: 1),
//         borderRadius: BorderRadius.circular(25)),
//     labelStyle: GoogleFonts.inter(
//       fontSize: 14,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
//     ),
//     errorStyle: GoogleFonts.inter(
//         fontSize: 12, fontWeight: FontWeight.w500, color: red),
//     hintStyle: GoogleFonts.inter(
//       fontSize: 14,
//       fontWeight: FontWeight.w500,
//       color: primaryColor,
//     ),
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         textStyle: GoogleFonts.inter(
//           fontSize: 15,
//           fontWeight: FontWeight.w600,
//           color: const Color(0xffffffff),
//         )),
//   ),
//   outlinedButtonTheme: OutlinedButtonThemeData(
//     style: OutlinedButton.styleFrom(
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.white,
//       surfaceTintColor: Colors.white,
//       shadowColor: Colors.white,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30),
//       ),
//       side: const BorderSide(
//         color: primaryColor,
//       ),
//       textStyle: GoogleFonts.inter(
//         fontSize: 15,
//         fontWeight: FontWeight.w600,
//         color: primaryColor,
//       ),
//     ),
//   ),
//   textButtonTheme: TextButtonThemeData(
//     style: TextButton.styleFrom(
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.transparent,
//       surfaceTintColor: Colors.transparent,
//       shadowColor: Colors.transparent,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       textStyle: GoogleFonts.inter(
//         fontSize: 15,
//         fontWeight: FontWeight.w600,
//         color: const Color(0xff000000),
//       ),
//     ),
//   ),
//   dropdownMenuTheme: DropdownMenuThemeData(
//     textStyle: GoogleFonts.inter(
//       fontSize: 15,
//       fontWeight: FontWeight.w500,
//       color: const Color(0xff000000),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(25),
//         borderSide: const BorderSide(color: primaryColor, width: 0.2),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(25),
//         borderSide: const BorderSide(color: primaryColor, width: 0.2),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(25),
//         borderSide: const BorderSide(color: primaryColor, width: 2),
//       ),
//       errorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: red, width: 0.2),
//           borderRadius: BorderRadius.circular(25)),
//       labelStyle: GoogleFonts.inter(
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: primaryColor,
//       ),
//       hintStyle: GoogleFonts.inter(
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: primaryColor,
//       ),
//     ),
//   ),
// );
