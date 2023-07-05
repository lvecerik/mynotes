import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {

  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [const SizedBox(height: 5),
              Text(
                "MyNotes",
                style: GoogleFonts.permanentMarker(fontSize: 40),
              ),
              const SizedBox(height: 30)],
    );
}
}