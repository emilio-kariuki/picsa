import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
          text: "By using Comp, You agree to our ",
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontWeight: FontWeight.w600, fontSize: 12.5),
        ),
        TextSpan(
          text: "Terms of Service, Privacy Policy ",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w600, fontSize: 12.5, color: Colors.deepOrange),
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
              fontWeight: FontWeight.w600, fontSize: 12.5, color: Colors.deepOrange),
        ),
      ]),
    );
  }
}