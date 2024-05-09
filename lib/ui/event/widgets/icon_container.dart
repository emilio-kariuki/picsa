

import 'package:picsa/common_widgets/loading_circle.dart';
import 'package:picsa/utilities/packages.dart';

class IconContainer extends StatelessWidget {
  const IconContainer(
      {super.key,
      required this.icon,
      required this.function,
      this.isLoading = false});

  final IconData icon;
  final Function() function;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 35, 35, 35)),
        child: isLoading ?? false
            ? LoadingCircle(
                color: Colors.grey[500],
                size: 20,
              )
            : Icon(icon,
                size: 16, color: const Color.fromARGB(255, 103, 103, 103)),
      ),
    );
  }
}
