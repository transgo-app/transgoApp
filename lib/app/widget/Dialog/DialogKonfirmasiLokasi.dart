import 'package:transgomobileapp/app/modules/detailitems/controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/Button/ReusableButton.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/data.dart';

class DialogTentukanLokasi extends StatelessWidget {
  final bool isLokasiPengambilan;
  const DialogTentukanLokasi({super.key, required this.isLokasiPengambilan});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailitemsController>();
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: FlutterMap(
                    options: MapOptions(
                        initialCenter: LatLng(-6.200000, 106.816666),
                        initialZoom: 15.0,
                        onPositionChanged: (camera, hasGesture) {
                          controller.onPositionChanged(camera, hasGesture);
                        }),
                    children: [
                     TileLayer(
                        urlTemplate: 'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                        subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                      ),
                      Center(
                          child: Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: 30.0,
                      )),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    poppinsText(
                      text: "Titik Lokasi",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Obx(
                      () {
                        if (controller.isLoading.value == true) {
                          return poppinsText(text: "Harap Tunggu...");
                        } else if (controller.titikJalanGeolocator.value !=
                            '') {
                          return poppinsText(
                              text: controller.titikJalanGeolocator.value);
                        } else {
                          return poppinsText(
                              text: "Geser Untuk Cari Lokasi Anda");
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReusableButton(
                      title: "Konfirmasi",
                      bgColor: primaryColor,
                      height: 40,
                      ontap: () {
                        Get.back();
                        controller.focusNode1.unfocus();
                        controller.focusNode2.unfocus();
                        controller.focusNode3.unfocus();
                        if (isLokasiPengambilan) {
                          controller.lokasiPengambilanC.text =
                              controller.titikJalanGeolocator.value;
                        } else {
                          controller.lokasiPengembalianC.text =
                              controller.titikJalanGeolocator.value;
                        }
                      },
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}