import 'package:flutter/material.dart';
import 'package:picsa/utilities/app_constants.dart';
import 'package:picsa/utilities/size_config.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5 * SizeConfig.widthMultiplier),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: "By using ${APP_NAME}, You agree to our ",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 12.5),
          ),
          TextSpan(
            text: "Terms of Service, Privacy Policy ",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                  color: const Color(
                    0xff70B93E,
                  ),
                ),
          ),
          TextSpan(
            text: "and ",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
          ),
          TextSpan(
            text: "Agreement",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                  color: const Color(
                    0xff70B93E,
                  ),
                ),
          ),
        ]),
      ),
    );
  }
}
