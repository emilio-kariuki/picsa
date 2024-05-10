import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picsa/utilities/supabase_config.dart';

class ShotsContainer extends StatelessWidget {
  const ShotsContainer({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase.from('Images').stream(
                  primaryKey: ['id']).eq('eventId', eventId),
              builder: (context, snapshot) {
                final data = snapshot.data;
                return Text(
                  '${data!.length}',
                  style: GoogleFonts.rubikMaze(
                      fontSize: 32,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w700),
                );
              }),
          const Gap(15),
          Column(
            children: [
              Text(
                'SHOTS',
                style: GoogleFonts.rubikBubbles(
                    fontSize: 13,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w700),
              ),
              Text(
                'TAKEN',
                style: GoogleFonts.rubikBubbles(
                    fontSize: 13,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
