import 'package:flutter/material.dart';
import '../../../../widget/widgets.dart';
import '../../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalBottomSheet.dart';
import 'package:transgomobileapp/app/data/helper/FormatRupiah.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class BottomEstimation extends StatelessWidget {
  final DetailitemsController controller;
  const BottomEstimation({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              gabaritoText(
                text: "Total Biaya:",
                textColor: textPrimary,
                fontSize: 18,
              ),
              Obx(() {
                final grandTotal = controller.detailData['grand_total'] ?? 0;
                return gabaritoText(
                  text: "Rp ${formatRupiah(grandTotal)}",
                  textColor: primaryColor,
                  fontSize: 18,
                );
              }),
            ],
          ),
          const SizedBox(height: 10),
          ReusableButton(
            height: 50,
            ontap: () {
              // Validate location fields
              if (controller.detailLokasiPengambilan.value.isEmpty) {
                CustomSnackbar.show(
                  title: "Terjadi Kesalahan",
                  message: "Silahkan pilih lokasi pengambilan terlebih dahulu.",
                  icon: Icons.location_on,
                );
                return;
              }
              
              if (controller.detailLokasiPengembalian.value.isEmpty) {
                CustomSnackbar.show(
                  title: "Terjadi Kesalahan",
                  message: "Silahkan pilih lokasi pengembalian terlebih dahulu.",
                  icon: Icons.location_on,
                );
                return;
              }
              
              // Validate address if not self pickup/return
              if (!controller.pengambilanSendiri.value &&
                  controller.lokasiPengambilanC.text.trim().isEmpty) {
                CustomSnackbar.show(
                  title: "Terjadi Kesalahan",
                  message: "Silahkan isi alamat pengambilan terlebih dahulu.",
                  icon: Icons.location_on,
                );
                return;
              }
              
              if (!controller.pengembalianSendiri.value &&
                  controller.lokasiPengembalianC.text.trim().isEmpty) {
                CustomSnackbar.show(
                  title: "Terjadi Kesalahan",
                  message: "Silahkan isi alamat pengembalian terlebih dahulu.",
                  icon: Icons.location_on,
                );
                return;
              }
              
              if (!controller.isKendaraan &&
                  controller.deskripsiPermintaanKhusus.text.trim().isEmpty) {
                CustomSnackbar.show(
                  title: "Terjadi Kesalahan",
                  message:
                      "Tujuan pemakaian dan permintaan khusus wajib diisi.",
                );
                return;
              }

              if (!controller.validateRentTime()) {
                return;
              }

              _showConfirmationModal(context);
            },
            bgColor: primaryColor,
            widget: Center(
              child: Obx(() {
                return controller.isLoadingRincian.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const gabaritoText(
                        text: "Lihat Rincian",
                        textColor: Colors.white,
                        fontSize: 16,
                      );
              }),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showConfirmationModal(BuildContext context) {
    final dateStr = controller.dataClient['date'];
    final duration = int.tryParse(controller.dataClient['duration']?.toString() ?? '1') ?? 1;
    DateTime? rentDate;
    if (dateStr != null && dateStr.toString().isNotEmpty) {
      rentDate = DateTime.tryParse(dateStr.toString())?.toLocal();
    }
    
    if (rentDate == null) {
      // fallback if date is somehow null
      _showRincian(context);
      return;
    }

    final String formattedDate = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(rentDate);
    final DateTime endDate = rentDate.add(Duration(days: duration));
    final String formattedEndDate = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(endDate);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const gabaritoText(
                    text: 'Konfirmasi Waktu Sewa',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const gabaritoText(
                text: 'Pastikan waktu mulai dan selesai sewa Anda sudah sesuai.',
                fontSize: 14,
                textColor: Colors.black54,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.calendar_today, color: primaryColor, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const gabaritoText(
                                text: 'Waktu Mulai',
                                fontSize: 12,
                                textColor: Colors.black54,
                              ),
                              gabaritoText(
                                text: formattedDate,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: Colors.black12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.event_available, color: primaryColor, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const gabaritoText(
                                text: 'Waktu Selesai',
                                fontSize: 12,
                                textColor: Colors.black54,
                              ),
                              gabaritoText(
                                text: formattedEndDate,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ReusableButton(
                height: 50,
                bgColor: primaryColor,
                ontap: () {
                  Navigator.pop(context);
                  _showRincian(context);
                },
                widget: const Center(
                  child: gabaritoText(
                    text: 'Ya, Lanjutkan',
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ReusableButton(
                height: 50,
                bgColor: Colors.white,
                borderSideColor: primaryColor,
                ontap: () => Navigator.pop(context),
                widget: Center(
                  child: gabaritoText(
                    text: 'Ubah Waktu',
                    textColor: primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRincian(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const Wrap(
          children: [
            RincianOrderModal(),
          ],
        );
      },
    );
  }
}
