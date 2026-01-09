import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transgomobileapp/app/widget/widgets.dart';
import '../../../data/data.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxString teksLokasi = 'Harap Tunggu....'.obs;
  RxString teksCari = 'Harap Tunggu....'.obs;
  late TabController tabController;
  RxBool showWhatsApp = true.obs;
  double _lastScrollOffset = 0;

  RxMap jumlahData = {}.obs;

  RxString role = ''.obs;
  RxString userType = ''.obs;

  void _setDefaultDate() {
    DateTime now = DateTime.now();
    DateTime defaultDate;

    if (now.hour >= 22) {
      defaultDate = now.add(const Duration(days: 1));
    } else {
      defaultDate = now;
    }

    pickedDate.value = DateFormat('yyyy-MM-dd').format(defaultDate);
  }

  void setDefaultTime() {
    DateTime now = DateTime.now();
    DateTime defaultTime = now.add(const Duration(minutes: 120));
    pickedTime.value = DateFormat('HH:mm').format(defaultTime);
  }

  String getGreetingText() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Selamat Pagi!";
    } else if (hour >= 12 && hour < 15) {
      return "Selamat Siang!";
    } else if (hour >= 15 && hour < 18) {
      return "Selamat Sore!";
    } else {
      return "Selamat Malam!";
    }
  }

  void _handleScrollVisibility() {
    final currentOffset = scrollController.offset;
    final delta = currentOffset - _lastScrollOffset;
    if (delta > 5 && currentOffset > 0) {
      if (showWhatsApp.value) showWhatsApp.value = false;
    } else if (delta < -5) {
      if (!showWhatsApp.value) showWhatsApp.value = true;
    }

    _lastScrollOffset = currentOffset;
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      _handleScrollVisibility();

      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          hasMore.value &&
          showDataMobil.value == true) {
        getList(true);
      }
    });
    GlobalVariables.initializeData();
    loadRole();
    getKotaKendaraan();

    _setDefaultDate();
    setDefaultTime();
    _startAutoScroll();
  }

  @override
  void onClose() {
    scrollController.dispose();
    scrollContentController.dispose();
    scrollControllerLayanan.dispose();
    super.onClose();
  }

  RxString selectedKategori = ''.obs;
  RxString selectedLokasiKendaraan = ''.obs;
  RxString selectedDurasiSewa = '1'.obs;
  RxString searchValue = ''.obs;
  RxString pickedDate = ''.obs;
  RxString pickedTime = ''.obs;
  var selectedOption = ''.obs;
  RxString searchQuery = ''.obs;

  RxString pickedDateTimeISO = ''.obs;

  void pickedDateAndTime() {
    if (pickedDate.value.isEmpty || pickedTime.value.isEmpty) return;
    final dateTime =
        DateTime.tryParse("${pickedDate.value}T${pickedTime.value}") ??
            DateTime.now();
    pickedDateTimeISO.value = dateTime.toUtc().toIso8601String();
  }

  TextEditingController querySearch = TextEditingController();
  FocusNode focusNode = FocusNode();

  RxInt jenisSewa = 1.obs;

  RxBool showDataMobil = false.obs;
  RxBool isLoading = false.obs;

  RxList dataKota = [].obs;
  RxList listKendaraan = [].obs;
  RxList listProduk = [].obs;

  // Charge settings
  RxMap chargeSettings = {}.obs;
  Rxn<Map<String, dynamic>> currentChargeAlert = Rxn<Map<String, dynamic>>();

  RxList<Map<String, String>> kategori = [
    {'id': 'car', 'name': 'Mobil'},
    {'id': 'motorcycle', 'name': 'Motor'},
    {'id': 'iphone', 'name': 'iPhone'},
    {'id': 'camera', 'name': 'Kamera'},
    {'id': 'outdoor', 'name': 'Outdoor'},
    {'id': 'starlink', 'name': 'Starlink'},
  ].obs;

  RxList<Map<String, String>> durasiSewa = RxList.generate(
      30, (index) => {'id': '${index + 1}', 'name': '${index + 1} Hari'});

  RxBool isFetching = false.obs;
  int currentPage = 1;
  var hasMore = true.obs;
  ScrollController scrollController = ScrollController();
  bool isFetchingMore = false;

  bool validateFilter() {
    if (jenisSewa.value == 0) {
      CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message:
              "Silahkan pilih jenis sewa terlebih dahulu dengan driver atau tanpa driver",
          icon: Icons.key);
      return false;
    } else if (selectedLokasiKendaraan.value == '') {
      CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Silahkan pilih lokasi kendaraan terlebih dahulu",
          icon: Icons.location_on);
      return false;
    } else if (pickedDate.value == '') {
      CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Silahkan pilih tanggal terlebih dahulu",
          icon: Icons.calendar_month_rounded);
      return false;
    } else if (pickedTime.value == '') {
      CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Silahkan pilih jam terlebih dahulu",
          icon: Icons.timelapse_sharp);
      return false;
    } else if (selectedDurasiSewa.value == '') {
      CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Silahkan pilih durasi sewa terlebih dahulu",
          icon: Icons.timer);
      return false;
    } else if (selectedKategori.value == '') {
      CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Silahkan pilih kategori terlebih dahulu",
          icon: Icons.category);
      return false;
    }
    return true;
  }

  Future<void> loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    String savedRole = prefs.getString('role') ?? '';

    if (savedRole != 'customer' && savedRole != 'product_customer') {
      savedRole = '';
      await prefs.remove('role');
    }

    role.value = savedRole;

    if (savedRole == "product_customer") {
      userType.value = "product";
      kategori.value = [
        {"id": "iphone", "name": "iPhone"},
        {"id": "camera", "name": "Kamera"},
        {"id": "outdoor", "name": "Outdoor"},
        {"id": "starlink", "name": "Starlink"},
      ];
      selectedKategori.value = "iphone";
    } else if (savedRole == "customer") {
      userType.value = "vehicle";
      kategori.value = [
        {"id": "car", "name": "Mobil"},
        {"id": "motorcycle", "name": "Motor"},
      ];
      selectedKategori.value = "car";
    } else {
      kategori.value = [
        {"id": "car", "name": "Mobil"},
        {"id": "motorcycle", "name": "Motor"},
        {"id": "iphone", "name": "iPhone"},
        {"id": "camera", "name": "Kamera"},
        {"id": "outdoor", "name": "Outdoor"},
        {"id": "starlink", "name": "Starlink"},
      ];
      selectedKategori.value = kategori.first['id']!;
    }
    tabController = TabController(length: kategori.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int index = kategori.indexWhere((k) => k['id'] == selectedKategori.value);
      if (index != -1) tabController.index = index;
    });

    await getKotaKendaraan();
  }

  Future<void> getList([bool isPagination = false]) async {
    if (isFetchingMore) return;

    if (selectedKategori.value == '') {
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Silahkan pilih kategori terlebih dahulu",
        icon: Icons.category,
      );
      return;
    }

    if (!isPagination) {
      isLoading.value = true;
      listKendaraan.clear();
      listProduk.clear();
      currentPage = 1;
      hasMore.value = true;
    }

    isFetchingMore = true;
    pickedDateAndTime();

    try {
      String apiUrl;
      bool isKendaraan = (selectedKategori.value == 'car' ||
          selectedKategori.value == 'motorcycle');

      if (isKendaraan) {
        apiUrl =
            '/fleets/available?limit=10&page=$currentPage&q=${searchQuery.value}&location_id=${selectedLokasiKendaraan.value}&date=${pickedDateTimeISO.value}&duration=${selectedDurasiSewa.value}${selectedKategori.value != '-' ? '&type=${selectedKategori.value}' : ''}';
      } else {
        apiUrl =
            '/products/available?limit=10&page=$currentPage&q=${searchQuery.value}&category=${selectedKategori.value}&date=${pickedDateTimeISO.value}&duration=${selectedDurasiSewa.value}&location_id=${selectedLokasiKendaraan.value}';
      }

      var data = await APIService().get(apiUrl);

      List newItems = data['items'];

      if (isKendaraan) {
        final filtered = newItems
            .where((item) =>
                !listKendaraan.any((existing) => existing['id'] == item['id']))
            .toList();
        listKendaraan.addAll(filtered);
      } else {
        final filtered = newItems
            .where((item) =>
                !listProduk.any((existing) => existing['id'] == item['id']))
            .toList();
        listProduk.addAll(filtered);
      }

      currentPage++;
      if (newItems.length < 10) {
        hasMore.value = false;
      }

      jumlahData.value = data['meta'];
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isFetchingMore = false;
      isLoading.value = false;
      showDataMobil.value = true;
      // Check charge settings after search
      await checkChargeSettings();
    }
  }

  void checkDataWhenHaveList() {
    if (showDataMobil.value) {
      getList();
    }
  }

  Future<void> getKotaKendaraan() async {
    try {
      var data = await APIService().get('/locations?limit=100&page=1&q=');
      List allKota = data['items'];

      if (selectedKategori.value == 'iphone' ||
          selectedKategori.value == 'camera') {
        teksLokasi.value = "Lokasi Produk";
        teksCari.value = "Cari Produk";
        dataKota.value = allKota.where((item) => item['id'] == 10).toList();
      } else if (selectedKategori.value == 'outdoor' ||
          selectedKategori.value == 'starlink') {
        teksLokasi.value = "Lokasi Produk";
        teksCari.value = "Cari Produk";
        dataKota.value = allKota.where((item) => item['id'] == 11).toList();
      } else {
        teksLokasi.value = "Lokasi Kendaraan";
        teksCari.value = "Cari Kendaraan";
        dataKota.assignAll(allKota);
      }

      if (dataKota.isNotEmpty) {
        dataKota.sort((a, b) => a['id'].compareTo(b['id']));
        selectedLokasiKendaraan.value = dataKota.first['id'].toString();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  final List<Map<String, String>> cardDataLayanan = [
    {
      'imagePath': '24jam.png',
      'title': 'Sewa Mobil & Motor 24 Jam (Harian, Mingguan, Bulanan)',
      'subtitle':
          'Layanan sewa mobil motor Jakarta yang fleksibel dengan pilihan harian, mingguan, atau bulanan. Nikmati armada terawat, harga bersaing, dan perjalanan yang nyaman serta bebas repot.'
    },
    {
      'imagePath': 'hiace.png',
      'title': 'Sewa Hiace & City Tour Jakarta',
      'subtitle':
          'Nikmati perjalanan keliling Jakarta dengan Hiace yang nyaman. Cocok untuk wisata keluarga, rombongan, atau perjalanan bisnis dengan layanan terbaik.'
    },
    {
      'imagePath': 'nyetir.png',
      'title': 'Sewa Hiace & City Tour Jakarta',
      'subtitle':
          'Nikmati layanan antar-jemput kendaraan yang praktis dan efisien. Kami siap mengantarkan atau menjemput rental mobil dan motor langsung ke lokasi yang Anda tentukan, sehingga perjalanan Anda menjadi lebih nyaman dan tanpa repot'
    },
    {
      'imagePath': 'note.png',
      'title': 'Tanpa DP/Deposit dan Survey',
      'subtitle':
          'Sewa Mobil Jakarta & Sewa Motor Jakarta dengan mudah tanpa perlu membayar DP, deposit, atau melalui proses survei yang merepotkan. Nikmati pengalaman rental yang cepat, praktis, dan tanpa ribet.'
    },
  ];

  final List<Map<String, String>> cardDataLayananLainnya = [
    {
      'imagePath': 'dashboard/car.png',
      'title': 'Transgo.id 🚗',
      'subtitle':
          'Sewa mobil harian di Jakarta mulai dari Rp 200.000 per hari. Armada terawat, pilihan lepas kunci atau pakai driver, tanpa DP/deposit, serta tersedia layanan antar-jemput kendaraan.'
    },
    {
      'imagePath': 'dashboard/motor.png',
      'title': 'Transgo.motor 🏍',
      'subtitle':
          'Sewa motor untuk wilayah Jakarta, Bogor, Depok, Tangerang, dan Bekasi, mulai dari Rp 50.000 per hari. Tersedia opsi lepas kunci atau pakai driver, dengan proses booking cepat dan admin responsif.'
    },
    {
      'imagePath': 'dashboard/camera.png',
      'title': 'Transgo.kamera & Sewa iPhone 📸',
      'subtitle':
          'Tersedia layanan sewa kamera, iPhone, dan aksesori seperti DJI Osmo Pocket 3, mulai dari Rp 25.000 per hari. Cocok untuk content creator, event, atau dokumentasi digital profesional.'
    },
    {
      'imagePath': 'dashboard/network.png',
      'title': 'Transgo.connect 🌐',
      'subtitle':
          'Layanan sewa Starlink pertama di Indonesia dan Modem Orbit, dengan akses internet satelit hingga 450 Mbps. Layanan 24 jam, tarif mulai Rp 200.000/hari.'
    },
    {
      'imagePath': 'dashboard/outdoor.png',
      'title': 'Transgo.outdoor 🏕',
      'subtitle':
          'Sewa perlengkapan naik gunung dan outdoor—mulai dari Rp 5.000 per hari. Menyediakan tenda, sleeping bag, carrier, matras, dan gear trekking untuk kegiatan alam atau event luar ruangan.'
    },
    {
      'imagePath': 'dashboard/fleetpartner.png',
      'title': 'Transgofleetpartner 🚘',
      'subtitle':
          'Layanan sewa motor & mobil untuk ojol atau driver online, mulai dari Rp 40.000 per hari untuk motor & Rp 155.000 per hari untuk mobil—ideal untuk fleet UMKM transportasi.'
    },
    {
      'imagePath': 'dashboard/bengkel.png',
      'title': 'Transgo.garage 🔧',
      'subtitle':
          'Bengkel full-service dengan home service: mekanik profesional siap datang ke rumah untuk servis motor atau mobil secara praktis dan efisien.'
    },
    {
      'imagePath': 'dashboard/autocare.png',
      'title': 'Transgo.autocare 🧼',
      'subtitle':
          'Salon mobil lengkap: detailing, poles, repair bodi, dan perawatan interior—menjaga kendaraan tetap prima dan bersih.'
    },
    {
      'imagePath': 'dashboard/setir.png',
      'title': 'Transgo.course 🎓',
      'subtitle':
          'Kursus mengemudi dan pelatihan safety riding untuk motor dan mobil—materi lengkap, cocok untuk berbagai usia dan keperluan.'
    },
    {
      'imagePath': 'dashboard/motor-ev.png',
      'title': 'Transgo.ev ⚡',
      'subtitle':
          'Sewa motor listrik (EV) mulai Rp 40.000 per hari. Ramah lingkungan, cocok untuk wisatawan dan operasional harian, tersedia di area Jabodetabek.'
    },
    {
      'imagePath': 'dashboard/motor-sport.png',
      'title': 'Toprent.motosports 🏁',
      'subtitle':
          'Sewa motor ZX premium bike (ZX25R) untuk sensasi turing atau gaya berkendara sporty—harga mulai Rp 250.000 per hari.'
    },
    {
      'imagePath': 'dashboard/motor-vespa.png',
      'title': 'Toprent.vespa 🛵',
      'subtitle':
          'Rental Vespa matic tipe S dan Sprint, mulai dari Rp 170.000 per hari—bergaya klasik dan nyaman untuk jelajah kota.'
    },
  ];

  final List<Map<String, String>> testimoni = [
    {
      'title':
          'nemu transgo dari hasil searching tiktok, fast respon n proses nya cepet, admin live nya juga fast respon, padahal aku dah plin plan ganti ganti jam dan hari penyewaan, tapi tetep dibantu. Untuk unit nya sendiri overall good, mesin fisik dan keseluruhannya bagus,thanks yaaa, kalo main ke jkt lagi ntar mau sewa disini dehh rekomend🫶🏻',
      'author': 'Icha Lovilia'
    },
    {
      'title':
          'Mantepp bangett nih pelayanannya ajib banget cuy unitnya nyaman² terus juga pelayanannya ramah dan sopan bngt, skrng jadi tempat favorit buat ngerental kendaraan',
      'author': 'chiko'
    },
    {
      'title':
          'Pelayanan di Transgo.id sangat memuaskan! Proses sewa mobilnya cepat dan mudah, kondisi mobil sangat bersih dan terawat, serta harganya sangat kompetitif. Stafnya ramah dan sangat membantu. Sangat direkomendasikan untuk kebutuhan rental mobil di Jakarta. Terima kasih atas pelayanannya!',
      'author': 'Aeliefyan Naro'
    },
    {
      'title':
          'Pertama kali sewa motor di Jakarta, kondisi motor oke, sesuai dengan permintaan. Cukup fleksibel untuk permintaan tambahan seperti pindah lokasi pengantaran/penjemputan kendaraan. Overall good buat rekomendasi bagi yang mau sewa kendaraan di sekitaran Jakarta',
      'author': 'Rufino Dwi'
    },
    {
      'title':
          'tempatnya nyaman banget benerann! terus juga karyawannya ramah ramah bangett. servicenyaa okelahh, top markotop banget. fasilitasnya pun okeee',
      'author': 'Nasysilla Fahriyah'
    },
    {
      'title':
          'Bagus pelayanannya, mobilnya baguss ga ada masalah apapunnn, puas sewa di Transgo, bakalan sewa lagiii klo lagi butuh',
      'author': 'Tri Hartini'
    },
  ];

  final List<Map<String, String>> faqContent = [
    {
      'title': 'Bagaimana cara memesan mobil atau motor di Transgo.id?',
      'subtitle':
          'Anda dapat memesan mobil atau motor melalui website kami di transgo.id. Pilih jenis kendaraan yang diinginkan, isi detail pemesanan, dan ikuti langkah-langkah untuk menyelesaikan proses pemesanan. Kami juga menyediakan layanan pemesanan melalui WhatsApp jika Anda membutuhkan bantuan lebih lanjut.'
    },
    {
      'title':
          'Apa saja dokumen yang diperlukan untuk menyewa kendaraan di Transgo.id?',
      'subtitle':
          'NPWP KTP atau KK SIM (Opsional) ID Kerja atau kartu pelajar / kartu mahasiswa Akun Instagram yang aktif untuk verifikasi lebih lanjut. Dokumen-dokumen ini akan diperiksa sebelum pemesanan dikonfirmasi.'
    },
    {
      'title': 'Apakah tersedia layanan lepas kunci atau dengan driver?',
      'subtitle':
          'Lepas Kunci: Anda dapat mengemudikan kendaraan sendiri setelah proses verifikasi selesai. Dengan Driver: Jika Anda lebih memilih layanan dengan driver, kami memiliki driver profesional untuk perjalanan dalam kota maupun luar kota.'
    },
    {
      'title': 'Apa syarat usia minimum untuk menyewa kendaraan di Transgo.id?',
      'subtitle':
          'Minimal sewa kendaraan ialah 15 Tahun dan memiliki pendamping / penanggung jawab jika belum memiliki data pendukung.'
    },
    {
      'title':
          'Apakah ada biaya tambahan untuk penggunaan kendaraan di luar kota?',
      'subtitle':
          'Ya, ada biaya tambahan untuk penggunaan kendaraan di luar kota, tergantung pada wilayah tujuan. Biaya ini akan dikonfirmasi oleh tim kami berdasarkan lokasi yang Anda pilih.'
    },
    {
      'title': 'Apakah Transgo.id menyediakan layanan antar jemput kendaraan?',
      'subtitle':
          'Ya, kami menyediakan layanan antar jemput kendaraan dengan biaya mulai dari 50 ribu untuk motor dan 100 ribu untuk mobil. Biaya ini bervariasi tergantung pada jarak dan jenis kendaraan. Untuk memesan layanan antar jemput, silakan pilih menu “Layanan Antar Jemput” saat memesan di website.'
    },
    {
      'title': 'Bagaimana cara melakukan pembayaran?',
      'subtitle':
          'Pembayaran dapat dilakukan melalui transfer bank, kartu kredit, atau e-wallet. Semua pembayaran dilakukan saat serah terima kendaraan (Tidak diperlukan DP / Uang Muka maupun Uang Deposit).'
    },
    {
      'title':
          'Apakah saya perlu mengisi bahan bakar sebelum mengembalikan kendaraan?',
      'subtitle':
          'Ya, kendaraan harus dikembalikan dengan kondisi bahan bakar seperti saat diterima. Jika tidak, akan ada biaya tambahan sesuai ketentuan yang berlaku.'
    },
  ];

  final ScrollController scrollContentController = ScrollController();
  final List<String> logos = [
    'viva.png',
    'jpnn.png',
    'tribunseleb.svg',
    'qontak.svg',
    'papericon.png',
    'liputan6.png',
    'halloid.png',
    'kabardki.svg',
    'kabarinews.png',
    'mediaindonesia.png',
    'planetberita.svg',
    'portonews.png',
    'sindonews.png',
    'trans7.png',
    'xnews.png'
  ];

  String getImageUrl(String fileName) {
    return 'https://main-transgo.s3.ap-southeast-1.amazonaws.com/assets/newsmedia/$fileName';
  }

  void _startAutoScroll() async {
    await Future.delayed(Duration(seconds: 2));

    if (!scrollContentController.hasClients) return;

    double maxScroll = scrollContentController.position.maxScrollExtent;

    scrollContentController
        .animateTo(
      maxScroll,
      duration: Duration(seconds: 60),
      curve: Curves.linear,
    )
        .then((_) async {
      if (scrollContentController.hasClients) {
        await Future.delayed(Duration(seconds: 2));
        scrollContentController.jumpTo(0);
        _startAutoScroll();
      }
    });
  }

  final ScrollController scrollControllerLayanan = ScrollController();
  final double itemWidth = 310;

  void scrollLeft() {
    if (!scrollControllerLayanan.hasClients) return;
    double newPos = (scrollControllerLayanan.offset - itemWidth).clamp(
      0.0,
      scrollControllerLayanan.position.maxScrollExtent,
    );
    scrollControllerLayanan.animateTo(
      newPos,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() {
    if (!scrollControllerLayanan.hasClients) return;
    double newPos = (scrollControllerLayanan.offset + itemWidth).clamp(
      0.0,
      scrollControllerLayanan.position.maxScrollExtent,
    );
    scrollControllerLayanan.animateTo(
      newPos,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // Charge settings methods
  Future<void> fetchChargeSettings() async {
    try {
      var data = await APIService().get('/order-calculation-settings');
      chargeSettings.value = data ?? {};
    } catch (e) {
      print("Error fetching charge settings: $e");
      chargeSettings.value = {};
    }
  }

  String formatFleetNames(List<dynamic> fleets) {
    if (fleets.isEmpty) return '';
    
    final fleetMap = {
      'car': 'Mobil',
      'motorcycle': 'Motor',
    };
    
    final names = fleets
        .map((f) => fleetMap[f.toString()] ?? f.toString())
        .where((name) => name.isNotEmpty)
        .toList();
    
    if (names.isEmpty) return '';
    if (names.length == 1) return names.first;
    if (names.length == 2) return '${names[0]} dan ${names[1]}';
    return names.join(', ');
  }

  Future<void> checkChargeSettings() async {
    if (pickedDate.value.isEmpty || selectedKategori.value.isEmpty) {
      currentChargeAlert.value = null;
      return;
    }

    // Only check for car and motorcycle
    if (selectedKategori.value != 'car' && selectedKategori.value != 'motorcycle') {
      currentChargeAlert.value = null;
      return;
    }

    // Fetch settings if not already fetched
    if (chargeSettings.isEmpty) {
      await fetchChargeSettings();
    }

    final calendarRanges = chargeSettings['calendar_dates_ranges'] as List?;
    if (calendarRanges == null || calendarRanges.isEmpty) {
      currentChargeAlert.value = null;
      return;
    }

    try {
      final selectedDate = DateTime.parse(pickedDate.value);
      final selectedTimeStr = pickedTime.value;
      int selectedHour = 12; // default
      
      if (selectedTimeStr.isNotEmpty) {
        final timeParts = selectedTimeStr.split(':');
        if (timeParts.length == 2) {
          selectedHour = int.tryParse(timeParts[0]) ?? 12;
        }
      }

      Map<String, dynamic>? mostRelevantAlert;
      DateTime? mostRelevantDate;

      for (var range in calendarRanges) {
        final fleets = range['fleets'] as List?;
        if (fleets == null || fleets.isEmpty) continue;

        // Check if selected category matches fleets
        if (!fleets.contains(selectedKategori.value)) continue;

        final startDateStr = range['start_date'] as String?;
        final endDateStr = range['end_date'] as String?;
        if (startDateStr == null || endDateStr == null) continue;

        // Parse dates - extract date part from ISO string to avoid timezone issues
        // startDateStr format: "2026-01-12T00:00:00+07:00"
        final startDateMatch = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(startDateStr);
        final endDateMatch = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(endDateStr);
        
        if (startDateMatch == null || endDateMatch == null) continue;
        
        final startYear = int.parse(startDateMatch.group(1)!);
        final startMonth = int.parse(startDateMatch.group(2)!);
        final startDay = int.parse(startDateMatch.group(3)!);
        
        final endYear = int.parse(endDateMatch.group(1)!);
        final endMonth = int.parse(endDateMatch.group(2)!);
        final endDay = int.parse(endDateMatch.group(3)!);
        
        // Normalize to date only (remove time)
        final startDateOnly = DateTime(startYear, startMonth, startDay);
        final endDateOnly = DateTime(endYear, endMonth, endDay);
        final selectedDateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

        // Convert dates to comparable integer format (YYYYMMDD)
        final selectedDays = selectedDateOnly.year * 10000 + selectedDateOnly.month * 100 + selectedDateOnly.day;
        final startDays = startYear * 10000 + startMonth * 100 + startDay;
        final endDays = endYear * 10000 + endMonth * 100 + endDay;
        final d1Days = startDays - 1; // One day before start date
        
        // Check D-1 (one day before start date)
        // Only show D-1 alert if booking time is 12:00 WIB or later
        final isD1 = selectedDays == d1Days && selectedHour >= 12;
        
        if (isD1) {
          // D-1 alert
          final fleetNames = formatFleetNames(fleets);
          final chargePercent = selectedHour > 18 ? 50 : 30;
          final timeRange = selectedHour > 18 
              ? 'setelah pukul 18.00 WIB' 
              : 'pukul 12.00-18.00 WIB';
          
          final alert = {
            'type': 'd1',
            'name': range['name'] ?? '',
            'fleets': fleetNames,
            'chargePercent': chargePercent,
            'timeRange': timeRange,
            'range': range,
          };

          // Keep the most relevant (earliest start date)
          if (mostRelevantAlert == null || 
              (mostRelevantDate == null || startDateOnly.isBefore(mostRelevantDate))) {
            mostRelevantAlert = alert;
            mostRelevantDate = startDateOnly;
          }
        }

        // Check D-DAY (within the period, inclusive) - only if not D-1
        if (!isD1) {
          // Check if selected date is within the period (inclusive)
          if (selectedDays >= startDays && selectedDays <= endDays) {
            final fleetNames = formatFleetNames(fleets);
            
            final alert = {
              'type': 'dday',
              'name': range['name'] ?? '',
              'formatted_start_date': range['formatted_start_date'] ?? '',
              'formatted_end_date': range['formatted_end_date'] ?? '',
              'fleets': fleetNames,
              'range': range,
            };

            // Keep the most relevant (earliest start date)
            if (mostRelevantAlert == null || 
                (mostRelevantDate == null || startDateOnly.isBefore(mostRelevantDate))) {
              mostRelevantAlert = alert;
              mostRelevantDate = startDateOnly;
            }
          }
        }
      }

      currentChargeAlert.value = mostRelevantAlert;
    } catch (e) {
      print("Error checking charge settings: $e");
      currentChargeAlert.value = null;
    }
  }
}
