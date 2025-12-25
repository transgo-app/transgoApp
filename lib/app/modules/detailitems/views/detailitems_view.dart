import 'package:iconsax_plus/iconsax_plus.dart';
import '../controllers/detailitems_controller.dart';
import '../../../widget/widgets.dart';
import '../../../data/data.dart';
import '../widgets/detailitems_content.dart';
import '../widgets/detailitems_bottom_sheet.dart';

class DetailitemsView extends GetView<DetailitemsController> {
  const DetailitemsView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              IconsaxPlusBold.arrow_left_1,
              size: 33,
            ),
          ),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: gabaritoText(
          text: controller.isKendaraan ? "Detail Kendaraan" : "Detail Produk",
          fontSize: 16,
          textColor: textHeadline,
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoadinggetdetailkendaraan.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: DetailitemsContent(controller: controller),
              ),
              DetailitemsBottomSheet(controller: controller),
            ],
          );
        }
      }),
    );
  }
}