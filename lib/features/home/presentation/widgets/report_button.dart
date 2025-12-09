import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'report_dialog.dart';

class ReportButton extends StatelessWidget {
  const ReportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF1C433),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF1C433).withOpacity(1),
            offset: const Offset(2, -5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const ReportDialog(),
            );
          },
          customBorder: const CircleBorder(),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/add_incident.svg',
              width: 32,
              height: 32,
            ),
          ),
        ),
      ),
    );
  }
}
