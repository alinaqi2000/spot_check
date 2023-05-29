import 'package:flutter/material.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/constants/sizes.dart';

class BrandText extends StatelessWidget {
  final String text;
  const BrandText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: AppSizes.brandingSize, height: 1.2),
    );
  }
}

class HeadingText extends StatelessWidget {
  final String text;
  const HeadingText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: AppSizes.headingSize, height: 1.2),
    );
  }
}

class Heading2Text extends StatelessWidget {
  final String text;
  const Heading2Text({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: AppSizes.heading2Size, height: 1.2),
    );
  }
}

class SectionTitleText extends StatelessWidget {
  final String text;
  const SectionTitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: AppSizes.sectionTitleSize),
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
      style: TextStyle(
          fontSize: AppSizes.paraSize, color: AppColors.secondaryText),
    );
  }
}

class PromText extends StatelessWidget {
  final String? text;
  const PromText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: const TextStyle(
          fontSize: AppSizes.prominentSize, overflow: TextOverflow.ellipsis),
    );
  }
}
