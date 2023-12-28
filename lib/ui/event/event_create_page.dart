import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
class EventCreatePage extends StatelessWidget {
  const EventCreatePage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios, size: 20,color: Colors.white,),
        title: Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Gap(20),
               Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 19, 194, 25)
                                .withOpacity(0.2),
                           
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.grey[300],
                    ),
                  ),
              
            ],
          ),
        ),
       
        
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                Container(
                  height: height * 0.3,
                  width: width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(name)

                )
              ],
            ),
          )),
    );
  }
}
