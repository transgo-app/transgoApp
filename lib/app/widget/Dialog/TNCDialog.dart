import 'package:transgomobileapp/app/data/data.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';

class TncDialog extends StatelessWidget {
  TncDialog({super.key});

  final List<Map<String, String>> dataTnc = [
    {
      'title': "Ketentuan Sewa",
      'body':
          '1. Untuk menghindari ketidaknyamanan dalam penggunaan, diharapkan Anda melakukan pemesanan minimal 1x24 jam sebelum waktu penggunaan. Setelah pesanan dikonfirmasi, penyewa wajib menyediakan foto dokumen yang diperlukan, yaitu:\nKartu Identitas (Sim A, KK, KTP, ID Kerja atau ID Pelajar, NPWP, Bukti Tempat Tinggal)Akun media sosial yang aktif\n2. Tentukan detail lokasi pengambilan mobil dengan pihak penyedia rental\n3. Proses verifikasi dokumen harus dilengkapi minimal 4 (empat) jam sebelum penggunaan\n4. Pada saat serah terima mobil, penyewa harus membawa dan menunjukkan dokumen asli yang telah disebuthkan di atas sesuai dengan kesepakatan yang telah ditentukan sebelumnya.\n5. Pihak penyedia rental akan melakukan pengecekan keaslian data dan kondisi kendaraan saat serah terima kendaraan. Apabila data tidak sesuai dan syarat sewa tidak dapat dilengkapi, penyedia rental berhak untuk membatalkan pesanan\n6. Selama masa sewa, penyewa dilarang untuk membawa penumpang dan barang melebihi kapasitas maksimal mobil yang disewa\n7. Penyewa bertanggung jawab atas denda parkir, lalu lintas, dan lainnya yang terjadi akibat pelanggaran hukum selama periode rental\n8. Kehilangan dan kerusakan barang selama perjalanan diluar tanggung jawab penyedia rental\n9. Penyewa harus bertanggung jawab atas biaya penggantian atau perbaikan atas kehilangan atau kerusakan, seperti STNK, kunci mobil, aksesoris, alat mobil, head unit, tools set, kursi mobil, noda, goresan, dan biaya lain yang timbul akibat kelalaian penyewa\n10. Bensin wajib dikembalikan dengan sistem range to range, atau posisi bensin tidak boleh berkurang dari pengambilan unit. Jika pada saat pengembalian bar bensin tidak sama dengan pada saat pengambilan dan berkurang 1 bar, maka akan dikenakan charge 50ribu/bar\n11. Setelah penyewaan mobil berakhir, unit harus dikembalikan dalam keadaan di steam bersih. Jika mobil dalam keadaan belum dicuci, akan dikenakan denda penalti sebesar (besar) 200k! Maka 2 jam sebelum unit dikembalikan, pastikan customer sudah mempersiapkan untuk steam mobil.'
    },
    {
      'title': "Biaya Overtime",
      'body':
          'Biaya Overtime Apabila penggunaan kendaraan melebihi waktu rental yang telah disepakati, maka akan dikenakan biaya overtime. Berikut ketentuannya:\n1. Pelanggan harus melakukan konfirmasi untuk waktu penggunaan tambahan maksimum 8 (delapan) jam sebelum waktu sewa kendaraan berakhir\n2. Biaya overtime sebesar 15% per jam dari harga sewa\n3. Waktu maksimal overtime adalah 3 (tiga) jam. Jika waktu lebih dari 3 jam, maka akan dihitung biaya satu hari rental\n4. Penyewa harus mengembalikan mobil selambat-lambatnya pada waktu selesai rental yang tertera pada kesepakatan harga.\nBiaya Kerugian:\nUntuk menghindari risiko kecelakaan, penyewa diwajibkan untuk menyerahkan kepada penyedia semua dokumen yang dibutuhkan oleh bengkel. Selain itu, penyewa wajib menanggung beban biaya kerusakan untuk setiap kejadian kecelakaan (per panel) dan Biaya Risiko Kehilangan.\nApabila terjadi kecelakaan yang disebabkan oleh penyewa yang menyebabkan kendaraan rental mengalami kerusakan di atas 40%, penyewa akan dikenakan biaya penggantian suku cadang, cat, mesin, dil nya'
    },
    {
      'title': "Legal",
      'body':
          'Pasal 378 KUHP\nBarangsiapa dengan maksud untuk menguntungkan diri sendiri atau orang lain secara melawan hukum, dengan memakai nama palsu atau martabat (hoedanigheid) palsu ; dengan tipu muslihat, ataupun rangkaian kebohongan, menggerakkan orang lain untuk menyerahkan barang sesuatu kepadanya, atau supaya memberi hutang maupun menghapuskan piutang, diancam karena penipuan dengan pidana penjara paling lama empat tahun.\nPasal 378 KUHP\nAkibat dari wanprestasi itu biasanya dapat dikenakan sanksi berupa ganti rugi, pembatalan kontrak, peralihan risiko, maupun membayar biaya perkara. Sebagai contoh seorang debitur (si berutang) dituduh melakukan perbuatan melawan hukum, lalai atau secara sengaja tidak melaksanakan sesuai bunyi yang telah disepakati dalam kontrak, jika terbukti, maka debitur harus mengganti kerugian (termasuk ganti rugi + bunga + biaya perkara).'
    },
    {
      'title': "Waspada Penipuan",
      'body':
          'Waspada Selalu Berhati-hati terhadap semua tindakan KRIMINAL dimanapun kamu berada\n1. Selalu lakukan riset lebih lanjut, kumpulkan referensi dari orang-orang yang telah menggunakan layanan mereka sebelumnya, dan berhati-hati sebelum memberikan informasi pribadi atau melakukan pembayaran.\n2. Penipuan leasing kendaraan adalah jenis penipuan berkedok leasing untuk menyita motor karena pemilik disebut menunggak pembayaran. Strateginya Pelaku biasanya mencegat korban di tengah jalan, dan kemudian memaksa membawa kendaraan. Pemilik motor yang mungkin saja memang belum menunaikan kewajibannya, tidak bisa berkutik dan menyerahkan motor. Jadi, pastikan tindakan tersebut sudah mempunyai surat tugas dari perusahan leasing atau belum.\nPerhatian! Transgo.id tidak pernah meminta\n1. Uang Deposit atau Jaminan dsb\n2. Pembayaran sebelum Serah Terima\n*Semua pembayaran dilakukan saat serah terima Unit!'
    },
    {
      'title': "Delivery Terms",
      'body':
          'Berikut tarif charge untuk delivery-pickup (antar-ambil) per unit diluar jam kerja:\n06:30 - 21:00 -- biaya antar\n21:01 - 21:29 -- biaya antar +20.000\n21:30 - 22:29 -- biaya antar +40.000\n22:30 - 05:29 -- biaya antar +50.000\n05:30 - 05:59 -- biaya antar +40.000\n06:00 - 06:29 -- biaya antar +20.000'
    },
    {
      'title': "Pembayaran",
      'body':
          'Perhatian Kami menerima pembayaran via\n1. PAPER atas nama PT MARIFAH CIPTA BANGSA\n2. Bank Mandiri 0060012999888 a/n PT MARIFAH CIPTA BANGSA\n3. Transfer Rekening BCA 3190257168 a/n PT MARIFAH CIPTA BANGSA\nJika transfer diluar metode pembayaran diatas kami tidak bertanggung jawab atas kerugian yang dialami!'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            poppinsText(text: 'Syarat & Ketentuan Sewa di Transgo', fontSize: 14, fontWeight: FontWeight.w600),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Divider(),
            ),
            for (var i = 0; i < dataTnc.length; i++)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.all(0),
                  shape: Border(),
                  title: poppinsText(
                    text: dataTnc[i]['title'] ?? '',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  childrenPadding: EdgeInsets.all(0),
                  children: [
                    poppinsText(
                      text: dataTnc[i]['body'] ?? '',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.justify,
                      heightText: 2.0,
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            ReusableButton(
              bgColor: primaryColor,
              ontap: () {
                Get.back();
              },
              title: 'Mengerti & Tutup',
            )
          ],
        ),
      ),
    );
  }
}
