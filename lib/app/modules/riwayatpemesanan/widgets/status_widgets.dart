import '../../../data/data.dart';

class StatusRiwayatStyle extends StatelessWidget {
  final String? orderStatus;
  final String? paymentStatus;

  const StatusRiwayatStyle({
    super.key,
    required this.orderStatus,
    required this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = _resolveStatus(
      orderStatus: orderStatus,
      paymentStatus: paymentStatus,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: resolved.bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        resolved.label,
        style: gabaritoTextStyle.copyWith(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _ResolvedStatus _resolveStatus({
    required String? orderStatus,
    required String? paymentStatus,
  }) {
    final order = orderStatus?.toLowerCase() ?? '';
    final payment = paymentStatus?.toLowerCase() ?? '';

    if (order == 'waiting') {
      return _ResolvedStatus(
        label: 'Menunggu Konfirmasi',
        bgColor: Colors.orange,
      );
    }

    if ((order == 'confirmed' || order == 'on_going' || order == 'done') &&
        (payment == 'pending' || payment == 'waiting')) {
      return _ResolvedStatus(
        label: 'Belum Dibayar',
        bgColor: Colors.redAccent,
      );
    }

    if ((order == 'on_going') && payment == 'done') {
      return _ResolvedStatus(
        label: 'Sedang Berjalan',
        bgColor: Colors.blue,
      );
    }
    if (order == 'confirmed' && payment == 'done') {
      return _ResolvedStatus(
        label: 'Sudah Dibayar',
        bgColor: Colors.green.shade700,
      );
    }

    if (order == 'rejected' || payment == 'failed') {
      return _ResolvedStatus(
        label: 'Dibatalkan',
        bgColor: Colors.red,
      );
    }

    if (order == 'done' && payment == 'done') {
      return _ResolvedStatus(
        label: 'Telah Selesai',
        bgColor: Colors.green,
      );
    }

    return _ResolvedStatus(
      label: 'Status Tidak Diketahui',
      bgColor: Colors.grey,
    );
  }
}

class _ResolvedStatus {
  final String label;
  final Color bgColor;

  _ResolvedStatus({
    required this.label,
    required this.bgColor,
  });
}
