import 'package:flutter/material.dart';
import '../../../../widget/widgets.dart';
import '../../../../data/data.dart';
import '../../controllers/detailitems_controller.dart';

class CodStationCost extends StatelessWidget {
  final DetailitemsController controller;

  const CodStationCost({super.key, required this.controller});
    final Map<String, List<Map<String, dynamic>>> codStations = const {
    'Stasiun Tangerang Line': [
      {'name': 'St. Tangerang', 'price': 40000},
      {'name': 'St. Tanah Tinggi', 'price': 40000},
      {'name': 'St. Batu Ceper', 'price': 40000},
      {'name': 'St. Poris', 'price': 40000},
      {'name': 'St. Kalideres', 'price': 40000},
      {'name': 'St. Rawa Buaya', 'price': 40000},
      {'name': 'St. Bojong Indah', 'price': 40000},
      {'name': 'St. Taman Kota', 'price': 30000},
      {'name': 'St. Pesing', 'price': 30000},
      {'name': 'St. Grogol', 'price': 30000},
      {'name': 'St. Duri', 'price': 30000},
    ],
    'Stasiun Rangkasbitung Line': [
      {'name': 'St. Tanah Abang', 'price': 25000},
      {'name': 'St. Palmerah', 'price': 30000},
      {'name': 'St. Kebayoran', 'price': 30000},
      {'name': 'St. Pondok Ranji', 'price': 35000},
      {'name': 'St. Jurang Mangu', 'price': 35000},
      {'name': 'St. Sudimara', 'price': 35000},
      {'name': 'St. Rawa Buntu', 'price': 35000},
      {'name': 'St. Cisauk', 'price': 40000},
      {'name': 'St. Cicayur', 'price': 40000},
      {'name': 'St. Parung Panjang', 'price': 40000},
    ],
    'Stasiun Bogor Line': [
      {'name': 'St. Jakarta Kota', 'price': 25000},
      {'name': 'St. Mangga Besar', 'price': 25000},
      {'name': 'St. Sawah Besar', 'price': 25000},
      {'name': 'St. Juanda', 'price': 25000},
      {'name': 'St. Gondangdia', 'price': 15000},
      {'name': 'St. Cikini', 'price': 15000},
      {'name': 'St. Manggarai', 'price': 15000},
      {'name': 'St. Tebet', 'price': 10000},
      {'name': 'St. Cawang', 'price': 10000},
      {'name': 'St. Duren Kalibata', 'price': 10000},
      {'name': 'St. Pasar Minggu Baru', 'price': 10000},
      {'name': 'St. Pasar Minggu', 'price': 10000},
      {'name': 'St. Tanjung Barat', 'price': 20000},
      {'name': 'St. Lenteng Agung', 'price': 20000},
      {'name': 'St. Univ. Indonesia', 'price': 20000},
      {'name': 'St. Univ. Pancasila', 'price': 20000},
      {'name': 'St. Pondok Cina', 'price': 20000},
      {'name': 'St. Depok Baru', 'price': 20000},
      {'name': 'St. Depok', 'price': 20000},
      {'name': 'St. Citayam', 'price': 30000},
      {'name': 'St. Bojong Gede', 'price': 30000},
      {'name': 'St. Cilebut', 'price': 30000},
      {'name': 'St. Bogor', 'price': 30000},
      {'name': 'St. Cibinong', 'price': 40000},
      {'name': 'St. Nambo', 'price': 40000},
    ],
    'Stasiun Cikarang Line': [
      {'name': 'St. Karet', 'price': 25000},
      {'name': 'St. BNI City', 'price': 25000},
      {'name': 'St. Sudirman', 'price': 25000},
      {'name': 'St. Matraman', 'price': 15000},
      {'name': 'St. Angke', 'price': 35000},
      {'name': 'St. Rajawali', 'price': 30000},
      {'name': 'St. Kemayoran', 'price': 30000},
      {'name': 'St. Pasar Senen', 'price': 30000},
      {'name': 'St. Gang Sentiong', 'price': 30000},
      {'name': 'St. Kramat Jati', 'price': 25000},
      {'name': 'St. Pondok Jati', 'price': 25000},
      {'name': 'St. Jatinegara', 'price': 25000},
      {'name': 'St. Klender', 'price': 25000},
      {'name': 'St. Buaran', 'price': 25000},
      {'name': 'St. Klender Baru', 'price': 25000},
      {'name': 'St. Cakung', 'price': 30000},
      {'name': 'St. Kranji', 'price': 30000},
      {'name': 'St. Bekasi', 'price': 30000},
      {'name': 'St. Bekasi Timur', 'price': 30000},
      {'name': 'St. Tambun', 'price': 30000},
      {'name': 'St. Cibitung', 'price': 30000},
      {'name': 'St. Metland Telaga Murni', 'price': 40000},
      {'name': 'St. Cikarang', 'price': 40000},
    ],
    'Stasiun Tanjung Priok Line': [
      {'name': 'St. Kampung Bandan', 'price': 35000},
      {'name': 'St. Ancol', 'price': 35000},
      {'name': 'St. Tanjung Priok', 'price': 35000},
    ],
  };

  String formatRupiah(int number) {
    return 'Rp ${number.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final isKendaraan = controller.isKendaraan;

    if (isKendaraan) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Divider(
            color: Colors.grey,
            height: 10,
            thickness: 0.5,
          ),
          const SizedBox(height: 10),
          gabaritoText(
            text: 'Biaya Antar-Jemput Stasiun',
            fontSize: 18,
          ),
          const SizedBox(height: 5),
          gabaritoText(
            text: 'Biaya antar-jemput = Rp 2.000 per km (10 km = Rp 20.000)',
            fontSize: 14,
            textColor: Colors.grey,
          ),
          const SizedBox(height: 20),
          ...codStations.entries.map((entry) {
            final line = entry.key;
            final stations = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gabaritoText(
                  text: line,
                  fontSize: 16,
                  textColor: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                ...stations.map((station) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: gabaritoText(
                              text: station['name'],
                              fontSize: 14,
                            ),
                          ),
                          gabaritoText(
                            text: formatRupiah(station['price']),
                            fontSize: 14,
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 15),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
