
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:lottie/lottie.dart';
// import 'package:transgomobileapp/app/data/data.dart';
// import 'package:transgomobileapp/app/widget/widgets.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ModalMaintenance {
//   static void showModalMaintenance() {
//     showModalBottomSheet(
//       isDismissible: false,
//       enableDrag: false,
//       backgroundColor: Colors.white,
//       context: Get.context!,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) => const _ModalContent(),
//     );
//   }
// }

// class _ModalContent extends StatelessWidget {
//   const _ModalContent();

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Container(
//           color: Colors.white,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 height: 300,
//                 width: 300,
//                 child: Lottie.asset('assets/maintenanceicon.json')),
//               poppinsText(text: "Saat ini, sistem kami sedang dalam proses pemeliharaan. Untuk informasi lebih lanjut, silakan hubungi WhatsApp resmi kami di bawah ini. Kami mohon maaf atas ketidaknyamanannya dan terima kasih atas pengertiannya.", textAlign: TextAlign.center, fontWeight: FontWeight.w600,),
//               const SizedBox(height: 15,),
//               ReusableButton(
//               bgColor: Colors.green,
//               height: 50,
//               ontap: () {
//               launchUrl(Uri.parse('https://wa.me/$whatsAppNumberAdmin?text=Halo admin Transgo')).then((value) {
//               },);
//               },
//               widget: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset('assets/wa_white.png', scale: 18,),
//                   const SizedBox(width: 8,),
//                   Expanded(child: poppinsText(text: "Hubungi admin transgo untuk informasi lainnya", 
//                   textColor: Colors.white, 
//                   fontWeight: FontWeight.w600, 
//                   fontSize: 11,
//                   textAlign: TextAlign.center,
//                   ))
//                 ],
//               ),
//             ),
//               const SizedBox(height: 10,)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
