import 'package:transgomobileapp/app/data/helper/FormatRupiah.dart';

/// Mirrors web [price-detail.tsx] delivery breakdown for calculate-price payload.
class DeliveryPricingLines {
  final int servicePriceTotal;
  final bool hasStartDelivery;
  final bool hasEndDelivery;
  final int startLegRupiah;
  final int endLegRupiah;
  final String? startSubtitle;
  final String? endSubtitle;

  DeliveryPricingLines({
    required this.servicePriceTotal,
    required this.hasStartDelivery,
    required this.hasEndDelivery,
    required this.startLegRupiah,
    required this.endLegRupiah,
    this.startSubtitle,
    this.endSubtitle,
  });

  bool get showSection => servicePriceTotal > 0;
}

Map<String, dynamic>? _deliveryPricingMap(Map<String, dynamic> detail) {
  final top = detail['delivery_pricing'];
  if (top is Map<String, dynamic>) return top;
  final pc = detail['price_calculation'];
  if (pc is Map<String, dynamic>) {
    final dp = pc['delivery_pricing'];
    if (dp is Map<String, dynamic>) return dp;
  }
  return null;
}

int? _num(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.round();
  return int.tryParse(v.toString());
}

DeliveryPricingLines buildDeliveryPricingLines(Map<String, dynamic> detail) {
  final servicePriceTotal = _num(detail['service_price']) ?? 0;
  final dp = _deliveryPricingMap(detail);
  final startReq = detail['start_request'];
  final endReq = detail['end_request'];

  int? startMeters = dp != null ? _num(dp['start_meters']) : null;
  int? endMeters = dp != null ? _num(dp['end_meters']) : null;

  if (startMeters == null &&
      startReq is Map &&
      startReq['distance'] != null) {
    final km = (startReq['distance'] as num?)?.toDouble();
    if (km != null) startMeters = (km * 1000).round();
  }
  if (endMeters == null && endReq is Map && endReq['distance'] != null) {
    final km = (endReq['distance'] as num?)?.toDouble();
    if (km != null) endMeters = (km * 1000).round();
  }

  final startSelf =
      startReq is Map ? startReq['is_self_pickup'] == true : true;
  final endSelf = endReq is Map ? endReq['is_self_pickup'] == true : true;

  final startRatePerKm =
      (dp?['start_rate_per_km'] ?? dp?['rate_per_km'])?.toDouble();
  final endRatePerKm =
      (dp?['end_rate_per_km'] ?? dp?['rate_per_km'])?.toDouble();

  final hasStartDelivery =
      !startSelf && startMeters != null && startRatePerKm != null;
  final hasEndDelivery =
      !endSelf && endMeters != null && endRatePerKm != null;

  int startSub = dp != null ? (_num(dp['start_subtotal']) ?? -1) : -1;
  int endSub = dp != null ? (_num(dp['end_subtotal']) ?? -1) : -1;

  int startLeg;
  int endLeg;

  if (startSub >= 0 || endSub >= 0) {
    startLeg = startSub >= 0
        ? startSub
        : (hasStartDelivery && !hasEndDelivery ? servicePriceTotal : 0);
    endLeg = endSub >= 0
        ? endSub
        : (hasEndDelivery && !hasStartDelivery ? servicePriceTotal : 0);
  } else if (hasStartDelivery && hasEndDelivery) {
    final sm = startMeters;
    final em = endMeters;
    final totalM = sm + em;
    if (totalM > 0) {
      startLeg = ((servicePriceTotal * sm) / totalM).round();
      endLeg = (servicePriceTotal - startLeg).clamp(0, servicePriceTotal);
    } else {
      startLeg = (servicePriceTotal / 2).round();
      endLeg = servicePriceTotal - startLeg;
    }
  } else {
    startLeg = hasStartDelivery ? servicePriceTotal : 0;
    endLeg = hasEndDelivery ? servicePriceTotal : 0;
  }

  String? legText(String label, int? meters, double? ratePerKm) {
    if (meters == null || ratePerKm == null) return null;
    final km = meters / 1000.0;
    final kmStr = (km == km.floorToDouble()) ? km.toInt().toString() : km.toStringAsFixed(1);
    return '$label: ${kmStr}Km (Rp ${formatRupiah(ratePerKm.round())}/km)';
  }

  return DeliveryPricingLines(
    servicePriceTotal: servicePriceTotal,
    hasStartDelivery: hasStartDelivery,
    hasEndDelivery: hasEndDelivery,
    startLegRupiah: startLeg,
    endLegRupiah: endLeg,
    startSubtitle: legText('Antar', startMeters, startRatePerKm),
    endSubtitle: legText('Jemput', endMeters, endRatePerKm),
  );
}
