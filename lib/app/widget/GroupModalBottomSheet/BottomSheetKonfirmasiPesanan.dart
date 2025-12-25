import 'package:info_widget/info_widget.dart';
import '../widgets.dart';
import '../../data/data.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ParentModal.dart';

class BottomSheetKonfirmasiPemesanan extends StatelessWidget {
  final RxMap<dynamic, dynamic> data;
  final Widget buttonConfirmation;
  final int duration;

  const BottomSheetKonfirmasiPemesanan({
    super.key,
    required this.data,
    required this.buttonConfirmation,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final isProductType = data['product'] != null || data['type'] == 'product';

    return BottomSheetComponent(
      widget: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              poppinsText(
                text: isProductType
                    ? "Rincian Harga Produk"
                    : "Rincian Harga ${data['total_driver_price'] == 0 ? "Lepas Kunci" : "Dengan Driver"}",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 10),
              buildRincianList(isProductType),
              if (!isProductType && data['total_driver_price'] != 0)
                buildDriverList(),
              if ((data['additional_services'] ?? []).isNotEmpty)
                buildAdditionalServicesList(),
              if ((data['addons'] ?? []).isNotEmpty) buildAddonsList(),
              buildSubtotalList(),
              const SizedBox(height: 20),
              buttonConfirmation,
              const SizedBox(height: 10),
              ReusableButton(
                bgColor: Colors.white,
                borderSideColor: primaryColor,
                textColor: primaryColor,
                ontap: () => Get.back(),
                title: "Tutup",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRincianList(bool isProductType) {
    List<Widget> items = [
      RincianBookingText(
        isProductType
            ? "${data['product']?['name'] ?? '-'}"
            : "${data['fleet']['name']}\n(per 24 Jam)",
        "Rp ${formatRupiah(data['rent_price'].toString())}",
      ),
      RincianBookingText(
        "$duration Hari",
        "Rp ${formatRupiah(data['total_rent_price'].toString())}",
      ),
    ];

    if ((data['total_weekend_price'] ?? 0) > 0) {
      items.add(RincianBookingText(
        "Harga Akhir Pekan",
        "Rp ${formatRupiah(data['total_weekend_price'].toString())}",
      ));
    }

    items.add(RincianBookingText(
      "Diskon ( ${data['discount_percentage']}% )",
      "Rp ${formatRupiah(data['discount'].toString())}",
    ));

    if (!isProductType) {
      items.add(Divider());
      items.add(RincianBookingText("Biaya Asuransi", ''));
      if (data['insurance'] != null) {
        items.add(RincianBookingText(
          "${data['insurance']['name']}",
          "Rp ${formatRupiah(data['insurance']['price'].toString())}",
        ));
      } else {
        items.add(RincianBookingText("Tidak Ada", 'Rp 0'));
      }
      items.add(Divider());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  Widget buildDriverList() {
    return Column(
      children: [
        RincianBookingText(
          "Harga Dengan Supir\n${data['out_of_town_price'] == 0 ? "(Dalam Kota)" : "(Luar Kota)"}",
          "Rp ${formatRupiah(data['total_driver_price'].toString())}",
        ),
        InfoWidget(
          infoText:
              "Harga Dengan Driver Per Hari (${data['out_of_town_price'] == 0 ? "Dalam Kota" : "Luar Kota"}) adalah Rp ${formatRupiah(data['driver_price'].toString())}",
          iconData: Icons.info_outline,
          iconColor: Colors.blueAccent,
          infoTextStyle:
              poppinsTextStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        Divider(),
      ],
    );
  }

  Widget buildAdditionalServicesList() {
    List<Widget> list = [
      poppinsText(
        text: "Layanan Tambahan",
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      const SizedBox(height: 5),
    ];
    for (var service in data['additional_services']) {
      list.add(Row(
        children: [
          Expanded(child: poppinsText(text: service['name'].toString())),
          poppinsText(
            text: "Rp ${formatRupiah(service['price'].toString())}",
            textColor: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ],
      ));
      list.add(const SizedBox(height: 10));
    }
    return Column(children: list);
  }

  Widget buildAddonsList() {
    List<Widget> list = [
      Align(
        alignment: Alignment.centerLeft,
        child: poppinsText(
          text: "Addons",
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
    ];

    for (var i = 0; i < data['addons'].length; i++) {
      var addon = data['addons'][i];
      list.add(Row(
        children: [
          Expanded(child: poppinsText(text: addon['name'].toString())),
          poppinsText(
            text: "Rp ${formatRupiah(addon['price'].toString())}",
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ],
      ));
      if (i != data['addons'].length - 1) {
        list.add(const SizedBox(height: 10));
      }
    }

    if (data['addons'] != null && (data['addons'] as List).isNotEmpty) {
      list.add(const Divider());
    }

    return Column(children: list);
  }

  Widget buildSubtotalList() {
    return Column(
      children: [
        RincianBookingText(
            "Subtotal", "Rp ${formatRupiah(data['sub_total'].toString())}"),
      ],
    );
  }

  Widget RincianBookingText(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: poppinsText(
              text: title,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 10),
          poppinsText(
            text: subtitle,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          )
        ],
      ),
    );
  }
}
