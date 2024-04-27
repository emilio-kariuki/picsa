import 'package:picsa/utilities/packages.dart';

class PopButton extends StatelessWidget {
  const PopButton({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: height * 0.08,
      left: width * 0.04,
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.4),
            ),
            child: GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: SvgPicture.asset(
                  AppImages.back,
                  height: 2.5 * SizeConfig.heightMultiplier,
                  width: 2.5 * SizeConfig.heightMultiplier,
                  color: Colors.grey[400],
                )),
          ),
        ),
      ),
    );
  }
}
