import '../../../../widget/widgets.dart';
import '../../../../data/data.dart';
import '../../controllers/detailitems_controller.dart';

class DetailKendaraanImportantInfo extends StatelessWidget {
  final DetailitemsController controller;

  const DetailKendaraanImportantInfo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isKendaraan = controller.isKendaraan;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gabaritoText(
            text: 'Wajib Dibaca Sebelum Lanjut',
            textColor: textHeadline,
          ),
          gabaritoText(
            text: !isKendaraan
                ? 'Sebelum kamu booking, yuk baca info penting berikut khusus penyewaan Produk'
                : 'Sebelum kamu booking, yuk baca info penting berikut agar proses sewa lancar!',
            textColor: textPrimary,
            fontSize: 14,
          ),
          const SizedBox(height: 20),
          !isKendaraan ? _peraturanProduk() : _peraturanKendaraan(),
          const Divider(),
          !isKendaraan ? _biayaOvertimeProduk() : _biayaOvertime(),
          const Divider(),
          _biayaKerugian(),
          const Divider(),
          _pasal378(),
          const Divider(),
          _wanprestasi(),
          const Divider(),
        ],
      ),
    );
  }

  Widget _peraturanKendaraan() {
    return _buildExpansionTile(
      'Peraturan Sebelum Melakukan Pemesanan Sewa Kendaraan',
      '''
1. Untuk menghindari ketidaknyamanan dalam penggunaan, diharapkan Anda melakukan pemesanan minimal 1x24 jam sebelum waktu penggunaan. Setelah pesanan dikonfirmasi, penyewa wajib menyediakan foto dokumen yang diperlukan, yaitu:
  1. Kartu identitas (SIM A, KK, KTP, ID Kerja atau ID Pelajar, NPWP, Bukti Tempat Tinggal).
  2. Akun media sosial yang aktif.

2. Tentukan detail lokasi pengambilan mobil dengan pihak penyedia rental.

3. Proses verifikasi dokumen harus dilengkapi minimal 4 (empat) jam sebelum penggunaan.

4. Pada saat serah terima mobil, penyewa harus membawa dan menunjukkan dokumen asli yang telah disebutkan di atas sesuai dengan kesepakatan yang telah ditentukan sebelumnya.

5. Pihak penyedia rental akan melakukan pengecekan keaslian data dan kondisi kendaraan saat serah terima kendaraan. Apabila data tidak sesuai dan syarat sewa tidak dapat dilengkapi, penyedia rental berhak untuk membatalkan pesanan.

6. Selama masa sewa, penyewa dilarang untuk membawa penumpang dan barang melebihi kapasitas maksimal mobil yang disewa.

7. Penyewa bertanggung jawab atas denda parkir, lalu lintas, dan lainnya yang terjadi akibat pelanggaran hukum selama periode rental.

8. Kehilangan dan kerusakan barang selama perjalanan di luar tanggung jawab penyedia rental.

9. Penyewa harus bertanggung jawab atas biaya penggantian atau perbaikan atas kehilangan atau kerusakan, seperti STNK, kunci mobil, aksesoris, alat mobil, head unit, tools set, kursi mobil, noda, goresan, dan biaya lain yang timbul akibat kelalaian penyewa.

10. Bensin wajib dikembalikan dengan sistem range to range, atau posisi bensin tidak boleh berkurang dari pengambilan unit. Jika pada saat pengembalian bar bensin tidak sama dengan pada saat pengambilan dan berkurang 1 bar, maka akan dikenakan charge 50 ribu/bar.

11. Setelah penyewaan mobil berakhir, unit kendaraan harus dikembalikan dalam keadaan di steam bersih. Jika mobil dalam keadaan belum dicuci, akan dikenakan denda penalti sebesar (besar) 200k! Maka 2 jam sebelum unit dikembalikan, pastikan customer sudah mempersiapkan untuk steam mobil.
''',
    );
  }

Widget _peraturanProduk() {
  return _buildExpansionTile(
    'Peraturan Sebelum Melakukan Pemesanan Sewa Produk',
    '''
1. Persyaratan Penyewa:
Wajib mengirimkan minimal 4 identitas asli (KTP/KK/ID Card/Akun Instagram), data pengganti bisa berupa NPWP/SIM. 
Jika penyewa masih di bawah umur, boleh menggunakan data keluarga terdekat.

2. Durasi Sewa:
Minimum sewa 1 hari (24 jam). Keterlambatan pengembalian dikenakan denda 15% per jam, dan perpanjangan sewa harus diinformasikan minimal H-1 sebelum masa sewa berakhir.

3. Kondisi Barang:
Barang disewa dalam kondisi baik dan diperiksa bersama sebelum diserahkan. Penyewa bertanggung jawab atas kerusakan atau kehilangan selama masa sewa berupa ganti rugi atau denda.

4. Penggunaan:
Dilarang memindahtangankan barang sewaan kepada pihak lain tanpa izin.
Barang hanya digunakan untuk keperluan legal dan sesuai peraturan hukum.
Penyewa iPhone tidak boleh logout iCloud.
Request install aplikasi sebelum unit diantar/diambil.
Pemindahan data wajib dilakukan secara mandiri. Jika ingin dibantu oleh admin, dikenakan charge Rp 50.000 dengan syarat dan ketentuan berlaku.
Baterai yang dikembalikan harus sama kondisi seperti saat pengambilan; jika <50%, dikenakan charge Rp 15.000 per 10%.

5. Pengembalian:
Barang dikembalikan sesuai waktu yang disepakati dan dalam kondisi seperti saat diterima.
Jika pengembalian dilakukan oleh orang lain, perlu konfirmasi admin terlebih dahulu.

6. Pembayaran:
Pembayaran penuh dilakukan saat serah terima unit melalui transfer bank BCA 3190287733 a/n PT Toprent Santuy Abadi.

7. Kerusakan dan Kehilangan:
Penyewa wajib mengganti biaya perbaikan atau harga penuh barang jika hilang/rusak.
  - Kehilangan pouch: Rp 100.000
  - Kehilangan casing: Rp 100.000
  - Kehilangan kabel: Rp 500.000
Pastikan semua perlengkapan dikembalikan lengkap agar terhindar dari denda.

8. Pembatalan:
Pembatalan sewa minimal H-1 sebelum waktu pengambilan, dikenakan charge 50% dari harga sewa.

9. Lain-lain:
Penyewa dianggap telah membaca dan menyetujui peraturan ini saat menyewa barang.
''',
  );
}


  Widget _biayaOvertime() {
    return _buildExpansionTile(
      'Biaya Overtime',
      '''
1. Pelanggan harus melakukan konfirmasi untuk waktu penggunaan tambahan maksimum 8 (Delapan) jam sebelum waktu sewa kendaraan berakhir.

2. Biaya overtime sebesar 15% per jam dari harga sewa.

3. Waktu maksimal overtime adalah 3 (tiga) jam. Jika waktu lebih dari 3 jam, maka akan dihitung biaya satu hari rental.

4. Penyewa harus mengembalikan mobil selambat-lambatnya pada waktu selesai rental yang tertera pada kesepakatan harga.
''',
    );
  }

  Widget _biayaOvertimeProduk() {
  return _buildExpansionTile(
    'Biaya Overtime',
    '''
1. Konfirmasi perpanjangan sewa maksimal 12 jam sebelum waktu sewa berakhir.

2. Biaya overtime 15% per jam dari harga sewa.

3. Waktu maksimal overtime 3 jam; jika lebih, dihitung biaya satu hari rental.

4. Barang harus dikembalikan tepat waktu sesuai kesepakatan harga.
''',
  );
}

  Widget _biayaKerugian() {
    return _buildExpansionTile(
      'Biaya Kerugian',
      '''
Untuk menghindari risiko kerusakan, penyewa diwajibkan untuk menyerahkan kepada penyedia semua dokumen yang diperlukan. Selain itu, penyewa wajib menanggung beban biaya kerusakan untuk setiap kejadian kerusakan barang dan Biaya Risiko Kehilangan.

Apabila terjadi kerusakan yang disebabkan oleh penyewa yang menyebabkan barang rental mengalami kerusakan, penyewa akan dikenakan biaya penggantian komponen, layar, baterai, dll nya.
''',
    );
  }

  Widget _pasal378() {
    return _buildExpansionTile(
      'Pasal 378 KUHP',
      'Barangsiapa dengan maksud untuk menguntungkan diri sendiri atau orang lain secara melawan hukum, dengan memakai nama palsu atau martabat (hoedanigheid) palsu; dengan tipu muslihat, ataupun rangkaian kebohongan, menggerakkan orang lain untuk menyerahkan barang sesuatu kepadanya, atau supaya memberi hutang maupun menghapuskan piutang, diancam karena penipuan dengan pidana penjara paling lama empat tahun.',
    );
  }

  Widget _wanprestasi() {
    return _buildExpansionTile(
      'Pasal 378 KUHP (Wanprestasi)',
      'Akibat dari wanprestasi itu biasanya dapat dikenakan sanksi berupa ganti rugi, pembatalan kontrak, peralihan risiko, maupun membayar biaya perkara. Sebagai contoh seorang debitur (si berutang) dituduh melakukan perbuatan melawan hukum, lalai atau secara sengaja tidak melaksanakan sesuai bunyi yang telah disepakati dalam kontrak, jika terbukti, maka debitur harus mengganti kerugian (termasuk ganti rugi + bunga + biaya perkara).',
    );
  }

  Widget _buildExpansionTile(String title, String content) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      shape: const Border(),
      backgroundColor: Colors.white,
      title: gabaritoText(
        text: title,
        textColor: solidPrimary,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: gabaritoText(text: content),
        ),
      ],
    );
  }

  // Widget _card(Widget child) {
  //   return Container(
  //     padding: const EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.grey),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: child,
  //   );
  // }
}
