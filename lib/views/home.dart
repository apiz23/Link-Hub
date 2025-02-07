import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBF5DD),
      appBar: AppBar(
        backgroundColor: Color(0xFFFBF5DD),
        elevation: 0,
        title: const Text(
          "LinkHub",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.5),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Lottie.asset(
                  'assets/home.json',
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              'Welcome to LinkHub',
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                fontSize:
                MediaQuery.of(context).size.width * 0.08,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16404D),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Collection of URL personally',
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     TextButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Color(0xFF16404D),
            //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            //       ),
            //       child: Text(
            //         'Learn More',
            //         style: GoogleFonts.inter(
            //           fontSize: 18,
            //           fontWeight: FontWeight.w600,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
