import 'package:flutter/material.dart';
import 'detailitems_image_section.dart';
import 'detailitems_info.dart';
import 'kendaraan/detailkendaraan_important_info.dart';
import 'detailitems_warning_section.dart';
import 'kendaraan/detailkendaraan_pickup_terms.dart';
import 'kendaraan/detailkendaraan_return_terms.dart';
import 'kendaraan/detailkendaraan_payment_section.dart';
import '../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'produk/fasilitas_produk.dart';
import 'produk/biaya_cod_produk.dart';
import 'charge_widget.dart';


class DetailitemsContent extends StatelessWidget {
  final DetailitemsController controller;

  const DetailitemsContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: primaryColor,
      color: Colors.white,
      onRefresh: () {
        return controller.getDetailAPI(true, false);
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailitemsImageSection(controller: controller),
              const SizedBox(height: 14),
              DetailitemsInfo(controller: controller),
              DetailChargeWidget(controller: controller),
              FasilitasWidget(controller),
              DetailKendaraanImportantInfo(controller: controller),
              DetailitemsWarningSection(controller: controller),
              DetailKendaraanPickupTerms(controller: controller),
              DetailKendaraanReturnTerms(controller: controller),
              CodStationCost(controller: controller),
              DetailKendaraanPaymentSection(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}