
import 'package:picsa/utilities/packages.dart';

class SvgContainer extends StatelessWidget {
  const SvgContainer({
    super.key,
    required this.height,
    required this.icon,
    required this.function,
  });

  final double height;
  final String icon;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 22),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 35, 35, 35)),
        child: SvgPicture.asset(
          icon,
          height: height * 0.02,
          width: height * 0.02,
        ),
      ),
    );
  }
}
