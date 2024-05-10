import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:picsa/common_widgets/loading_circle.dart';
import 'package:picsa/utilities/packages.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  final controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(15),
          color: const Color(0xff212121),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 10 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Gap(2 * SizeConfig.heightMultiplier),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: SvgPicture.asset(
                      AppImages.back,
                      height: 3 * SizeConfig.heightMultiplier,
                      width: 3 * SizeConfig.heightMultiplier,
                      color: Colors.grey[600],
                    ),
                  ),
                  Gap(3 * SizeConfig.heightMultiplier),
                  Text(
                    'Scan QR Code',
                    style: GoogleFonts.inter(
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: SvgPicture.asset(
                      AppImages.uplaod,
                      height: 2.5 * SizeConfig.heightMultiplier,
                      width: 2.5 * SizeConfig.heightMultiplier,
                      color: Colors.grey[600],
                    ),
                  ),
                  Gap(2 * SizeConfig.heightMultiplier),
                ],
              ),
              Gap(5 * SizeConfig.heightMultiplier),
              SizedBox(
                height: 30 * SizeConfig.heightMultiplier,
                width: 30 * SizeConfig.heightMultiplier,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: MobileScanner(
                    controller: MobileScannerController(
                      detectionSpeed: DetectionSpeed.noDuplicates,
                    ),
                    errorBuilder: (context, error, child) {
                      return ScannerErrorWidget(error: error);
                    },
                    onDetect: (barcodes) {
                      context.read<EventCubit>().joinEvent(
                            eventId: barcodes.barcodes[0].rawValue.toString(),
                          );
                    },
                  ),
                ),
              ),
              Gap(2 * SizeConfig.heightMultiplier),
              BlocConsumer<EventCubit, EventState>(
                listener: (context, state) {
                  if (state.status == EventStatus.success) {
                    context
                      ..pop()
                      ..showSuccessToast(
                          title: "Error",
                          message: state.message,
                          context: context);
                  }

                  if (state.status == EventStatus.error) {
                    context
                      ..pop()
                      ..showErrorToast(
                          title: "Error",
                          message: state.message,
                          context: context);
                  }
                },
                builder: (context, state) {
                  return state.status == EventStatus.loading
                      ? Center(
                          child: LoadingCircle(
                            color: green,
                          ),
                        )
                      : const SizedBox.shrink();
                },
              )
            ],
          )),
    );
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
