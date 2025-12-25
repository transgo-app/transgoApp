import 'dart:ui';
import 'package:hexcolor/hexcolor.dart';
import '../controllers/register_controller.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';
import '../widgets/register_header.dart';
import '../widgets/register_form.dart';
import '../widgets/register_upload_form.dart';
import '../widgets/register_step.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegisterHeader(),
                  gabaritoText(
                    text: 'Daftar dulu, biar makin gampang sewa kendaraan',
                    fontSize: 19,
                    textColor: textHeadline,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  gabaritoText(
                    text:
                        'Buat akunmu dan nikmati kemudahan sewa kendaraan kapan aja, di mana aja.',
                    fontSize: 14,
                    textColor: textSecondary,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: RegisterStep(
                          isVerified: controller.isUploadFile.value)),
                  if (!controller.isUploadFile.value) RegisterForm(),
                  if (controller.isUploadFile.value) RegisterUploadForm(),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class DottedBorderPainter extends CustomPainter {
  final double radius;

  DottedBorderPainter({this.radius = 30});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = HexColor('#BBCFF4')
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dashWidth = 5.0;
    final dashSpace = 3.0;

    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final Path borderPath = Path()..addRRect(rrect);
    final PathMetric pathMetric = borderPath.computeMetrics().first;
    double distance = 0;

    while (distance < pathMetric.length) {
      final extractPath = pathMetric.extractPath(
        distance,
        distance + dashWidth,
      );
      canvas.drawPath(extractPath, paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
