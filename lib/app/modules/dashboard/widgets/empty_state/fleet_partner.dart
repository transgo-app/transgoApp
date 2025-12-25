import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class FleetPartnerSection extends StatelessWidget {
  const FleetPartnerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryColor.withOpacity(0.4)),
            ),
            child: gabaritoText(
              text: 'Fleet Partner',
              fontSize: 12,
              textColor: primaryColor,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 14),
          gabaritoText(
            text:
                'Transgo juga bisa sewa mobil & motor untuk ojol loh! Mulai dari 50rb aja!',
            fontSize: 24,
            textColor: textHeadline,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          gabaritoText(
            text:
                'TransGo Fleet Partner menyediakan layanan sewa mobil driver online untuk Gocar, Grab, Maxim, dan InDrive, serta sewa milik motor listrik yang hemat biaya dan ramah lingkungan. Armada terawat, siap pakai, pembayaran fleksibel, dan proses cepat hanya 1 menit via web. Tersedia di Jakarta, Bogor, Depok, Tangerang, Bekasi, dan Bandung.',
            textColor: textSecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                _buildChecklist('Sistem sewa lepas kunci fleksibel 24 jam'),
                _buildChecklist('Deposit hanya sebesar 2 hari masa sewa unit'),
                _buildChecklist(
                    'Armada terbaru, tampil modis dan nyaman di jalan'),
                _buildChecklist('Sistem self-checkpoint berbasis digital form'),
                _buildChecklist('Tim maintenance siap tanggap'),
                _buildChecklist(
                    'Bisa digunakan ke luar Jabodetabek (sesuai permintaan)'),
                _buildChecklist(
                    'Dapatkan cashback hingga 2 hari masa sewa per-bulannya'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Image.asset(
            'assets/dashboard/fleetpartner.png',
            height: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () async {
                await launchUrl(
                  Uri.parse('https://sewamotormobilojol.com/'),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: gabaritoText(
                text: 'Sewa Sekarang',
                textColor: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildChecklist(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            IconsaxPlusBold.tick_circle,
            size: 20,
            color: primaryColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: gabaritoText(
              text: text,
              textColor: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
