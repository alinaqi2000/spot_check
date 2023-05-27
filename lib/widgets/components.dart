import 'package:flutter/material.dart';
import 'package:spot_check/constants/sizes.dart';

class HeadingText extends StatelessWidget {
  final String text;
  const HeadingText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: AppSizes.headingSize),
    );
  }
}

class ParaText extends StatelessWidget {
  final String text;
  const ParaText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: AppSizes.paraSize),
    );
  }
}

class PromText extends StatelessWidget {
  final String text;
  const PromText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: AppSizes.prominentSize),
    );
  }
}
