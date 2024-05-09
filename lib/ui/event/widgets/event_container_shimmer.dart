
import 'package:picsa/utilities/packages.dart';

class EventContainerShimmer extends StatelessWidget {
  const EventContainerShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 28, 28, 28),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 35, 35, 35),
            highlightColor: const Color.fromARGB(255, 49, 49, 49),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 2 * SizeConfig.heightMultiplier,
              width: 30 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 35, 35, 35),
            highlightColor: const Color.fromARGB(255, 49, 49, 49),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 2 * SizeConfig.heightMultiplier,
              width: 15 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 35, 35, 35),
            highlightColor: const Color.fromARGB(255, 49, 49, 49),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 2 * SizeConfig.heightMultiplier,
              width: 20 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Gap(2 * SizeConfig.heightMultiplier),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 35, 35, 35),
                highlightColor: const Color.fromARGB(255, 49, 49, 49),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 35, 35, 35)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox.shrink(),
                  ),
                ),
              ),
              const Spacer(),
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 35, 35, 35),
                highlightColor: const Color.fromARGB(255, 49, 49, 49),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 35, 35, 35)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox.shrink(),
                  ),
                ),
              ),
              const Spacer(),
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 35, 35, 35),
                highlightColor: const Color.fromARGB(255, 49, 49, 49),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 35, 35, 35)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox.shrink(),
                  ),
                ),
              ),
              const Spacer(),
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 35, 35, 35),
                highlightColor: const Color.fromARGB(255, 49, 49, 49),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 35, 35, 35)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox.shrink(),
                  ),
                ),
              ),
              const Spacer()
            ],
          )
        ],
      ),
    );
  }
}