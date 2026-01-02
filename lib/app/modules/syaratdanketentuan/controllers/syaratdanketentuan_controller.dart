import 'package:get/get.dart';

class SyaratSection {
  final String title;
  final List<String> items;

  SyaratSection({
    required this.title,
    required this.items,
  });
}

class SyaratKetentuanController extends GetxController {
  final String mainTitle =
      'PERJANJIAN SEWA, SYARAT & KETENTUAN SERTA SERAH TERIMA KENDARAAN TRANSGO.ID';

  final String description =
      'Dokumen ini merupakan perjanjian resmi antara Transgo.id selaku penyedia jasa rental kendaraan dan Penyewa, yang mengatur hak, kewajiban, serta tanggung jawab kedua belah pihak selama masa sewa kendaraan.';

  final List<SyaratSection> sections = [
    SyaratSection(
      title: 'I. Ketentuan Umum',
      items: [
        'Pemesanan dan/atau perpanjangan sewa wajib dilakukan minimal 1 x 24 jam sebelum waktu penggunaan.',
        'Setiap perpanjangan masa sewa wajib dikonfirmasi kepada admin Transgo.id sesuai ketentuan yang berlaku.',
        'Penyewa wajib menyediakan dokumen berupa KTP, SIM A, NPWP, Kartu Keluarga, ID kerja atau kartu pelajar, serta akun media sosial aktif.',
        'Proses verifikasi dokumen wajib diselesaikan minimal 4 jam sebelum waktu penggunaan.',
        'Verifikasi mendadak hanya dapat dilakukan atas persetujuan admin Transgo.id.',
        'Lokasi pengambilan dan pengembalian unit ditentukan berdasarkan kesepakatan antara Penyewa dan Transgo.id.',
        'Transgo.id menyediakan layanan antar-jemput maupun pengambilan unit di lokasi tertentu.',
      ],
    ),
    SyaratSection(
      title: 'II. Serah Terima Unit (Awal Sewa)',
      items: [
        'Penyewa wajib menunjukkan dokumen asli saat serah terima kendaraan.',
        'Penyewa wajib menyerahkan 1 (satu) jaminan kepada Tim Serah Terima Transgo.id.',
        'Transgo.id berhak melakukan pemeriksaan kondisi kendaraan sebelum unit digunakan.',
        'Apabila data atau dokumen tidak sesuai, Transgo.id berhak membatalkan pesanan.',
      ],
    ),
    SyaratSection(
      title: 'III. Kewajiban dan Larangan Penyewa',
      items: [
        'Penyewa bertanggung jawab penuh atas penggunaan kendaraan selama masa sewa.',
        'Segala bentuk pelanggaran lalu lintas, parkir, dan denda hukum menjadi tanggung jawab Penyewa.',
        'Penyewa dilarang menggadaikan, memindahtangankan, atau menyewakan kembali kendaraan kepada pihak lain.',
        'Kendaraan hanya boleh digunakan pada wilayah yang telah disepakati.',
        'Penyewa dilarang membawa penumpang atau barang melebihi kapasitas kendaraan.',
        'Penyewa dilarang merokok, membawa hewan, atau meninggalkan sampah yang menimbulkan bau tidak sedap di dalam kendaraan.',
        'Penyewa dilarang mengemudikan kendaraan dalam kondisi mabuk, tidak sadar, atau melanggar hukum.',
        'Kendaraan wajib dikembalikan dalam kondisi bersih dan dengan bahan bakar sesuai kondisi awal.',
      ],
    ),
    SyaratSection(
      title: 'IV. Biaya Tambahan dan Overtime',
      items: [
        'Konfirmasi perpanjangan wajib dilakukan maksimal 8 jam sebelum masa sewa berakhir.',
        'Biaya overtime dikenakan sebesar 15% per jam dari harga sewa unit.',
        'Keterlambatan lebih dari 3 jam dikenakan biaya 1 (satu) hari sewa penuh.',
        'Kekurangan bahan bakar dikenakan denda Rp50.000 per bar untuk mobil dan Rp10.000 per bar untuk motor.',
        'Pengembalian unit dalam kondisi kotor dikenakan denda Rp200.000 untuk mobil dan Rp50.000 untuk motor.',
        'Pengembalian unit di luar jam operasional pukul 06.30 – 21.00 WIB dikenakan biaya tambahan.',
        'Penggunaan kendaraan luar kota tanpa konfirmasi dikenakan penalti sebesar 2 (dua) kali harga sewa luar kota.',
      ],
    ),
    SyaratSection(
      title: 'V. Fasilitas Tambahan (Special Package)',
      items: [
        'Charger Type C merek Log On sebesar Rp25.000.',
        'Charger iPhone merek Log On sebesar Rp30.000.',
        'Senter sebesar Rp10.000.',
        'Lighter mobil sebesar Rp60.000.',
        'Kartu Flazz atau e-money (kartu saja) sebesar Rp50.000.',
      ],
    ),
    SyaratSection(
      title: 'VI. Kerusakan, Kehilangan, dan Kecelakaan',
      items: [
        'Penyewa bertanggung jawab penuh atas seluruh kerusakan atau kehilangan kendaraan dan kelengkapannya.',
        'Penyewa bertanggung jawab atas biaya sewa kendaraan selama masa perbaikan.',
        'Kerusakan di atas 40% mewajibkan Penyewa menanggung biaya suku cadang, cat, mesin, serta biaya sewa selama perbaikan.',
        'Penyewa wajib menyerahkan seluruh dokumen yang dibutuhkan apabila menggunakan klaim asuransi.',
      ],
    ),
    SyaratSection(
      title: 'VII. Serah Terima Pengembalian Unit (Akhir Sewa)',
      items: [
        'Kendaraan dikembalikan dalam kondisi bersih dan bahan bakar sesuai ketentuan awal.',
        'Pemeriksaan fisik kendaraan dilakukan bersama Penyewa dan didokumentasikan.',
        'Kerusakan yang tidak ada saat pengambilan menjadi tanggung jawab Penyewa.',
        'Pengembalian unit dengan bau menyengat, bekas banjir, atau membawa hewan dikenakan biaya tambahan.',
        'Penyewa wajib mengembalikan seluruh dokumen dan kunci kendaraan secara lengkap.',
      ],
    ),
    SyaratSection(
      title: 'VIII. Barang Bawaan Penyewa',
      items: [
        'Transgo.id tidak bertanggung jawab atas kehilangan atau kerusakan barang bawaan Penyewa.',
      ],
    ),
    SyaratSection(
      title: 'IX. Pernyataan dan Persetujuan Penyewa',
      items: [
        'Penyewa menyatakan telah membaca, memahami, dan menyetujui seluruh isi perjanjian.',
        'Penyewa bersedia mematuhi seluruh ketentuan selama masa sewa.',
        'Penyewa bertanggung jawab penuh atas seluruh biaya tambahan, kerusakan, dan pelanggaran.',
      ],
    ),
  ];
}
