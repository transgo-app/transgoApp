
String getPaymentStatusLabel(String paymentStatus) {
  switch (paymentStatus.toUpperCase()) {
    case 'PENDING':
      return 'Belum Dibayar';
    case 'DONE':
      return 'Lunas';
    case 'PARTIALLY_PAID':
      return 'Kurang Bayar';
    case 'FAILED':
      return 'Gagal';
    default:
      return '$paymentStatus';
  }
}

String resolveOrderLabel({required String orderStatus, required String paymentStatus}) {
  // Logic to resolve the overall status for display
  // For example, if payment is pending, show pending, else show order status
  if (paymentStatus.toLowerCase() == 'pending') {
    return 'pending';
  }
  // Map order status to status string
  switch (orderStatus.toLowerCase()) {
    case 'pending':
      return 'pending';
    case 'on going':
    case 'on_going':
      return 'on_going';
    case 'done':
      return 'done';
    case 'cancelled':
      return 'cancelled';
    default:
      return orderStatus.toLowerCase();
  }
}

