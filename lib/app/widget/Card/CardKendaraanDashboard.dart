import 'package:iconsax_plus/iconsax_plus.dart';
import '../../data/data.dart';
import '../widgets.dart';

class CustomGestureCard extends StatelessWidget {
  final Function()? onTap;
  final String imagePath;
  final String vehicleName;
  final String location;
  final String typeVehicle;
  final String vehicleColor;
  final String vehicleLocation;
  final String typeLabel;
  final String price;
  final String? pricelineThrough;
  final String? paymentStatus;
  final String? orderStatus;
  final String? orderStatusText;
  final String? durasiSewa;
  final bool showOrderStatus;

  const CustomGestureCard({
    super.key,
    this.onTap,
    required this.imagePath,
    required this.location,
    required this.typeVehicle,
    required this.vehicleColor,
    required this.typeLabel,
    required this.price,
    this.pricelineThrough,
    required this.vehicleName,
    required this.vehicleLocation,
    this.paymentStatus,
    this.orderStatus,
    this.orderStatusText,
    this.durasiSewa,
    required this.showOrderStatus,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 225,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/iconapp.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            if (!showOrderStatus) const SizedBox(height: 15),

            if (showOrderStatus)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: StatusRiwayatStyle(
                        orderStatus: orderStatus ?? '',
                        paymentStatus: paymentStatus ?? '',
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (paymentStatus != null)
                      Flexible(
                        child: StatusRiwayatStyle(
                          orderStatus: orderStatus ?? '',
                          paymentStatus: paymentStatus ?? '',
                        ),
                      ),
                  ],
                ),
              ),

            gabaritoText(
              text: vehicleName,
              fontSize: 16,
              textColor: textHeadline,
            ),

            const SizedBox(height: 8),

            if (durasiSewa != null)
              iconTitle(IconsaxPlusBold.calendar_edit, durasiSewa ?? '-'),

            iconTitle(IconsaxPlusBold.location, vehicleLocation),

            iconTitle(
              typeVehicle == 'car'
                  ? IconsaxPlusBold.car
                  : Icons.motorcycle_rounded,
              typeLabel,
            ),

            iconTitle(IconsaxPlusBold.color_swatch, vehicleColor),

            const SizedBox(height: 15),

            if (pricelineThrough == null)
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: gabaritoText(text: 'Estimasi Biaya'),
              ),

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: price,
                    style: gabaritoTextStyle.copyWith(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (orderStatus == null)
                    TextSpan(
                      text: '/ Hari',
                      style: poppinsTextStyle.copyWith(fontSize: 12),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 2),

            if (pricelineThrough != null)
              Text(
                pricelineThrough ?? '',
                style: gabaritoTextStyle.copyWith(
                  fontSize: 14,
                  decorationThickness: 0.8,
                  color: textSecondary,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget iconTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: solidPrimary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: gabaritoText(
              text: title.isNotEmpty ? title : '-',
              fontSize: 14,
              textColor: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
