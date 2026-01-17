import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../../../widget/widgets.dart';
import '../controllers/register_controller.dart';
import 'register_input.dart';
import '../../../data/theme.dart';
import 'package:transgomobileapp/app/widget/GroupModalBottomSheet/ModalBottomSheet.dart';
import 'register_file_input.dart';
import 'package:transgomobileapp/app/widget/General/newTextfFieldComponent.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.find<RegisterController>();

    final productData = controller.dataArgumentsDetailKendaraan['product'];
final fleetData = controller.dataArgumentsDetailKendaraan['fleet'];

final bool isProductItem =
    productData != null && productData is Map && productData.isNotEmpty;

final bool isFleetItem =
    fleetData != null && fleetData is Map && fleetData.isNotEmpty;

final bool isItemAvailable = isProductItem || isFleetItem;
final bool isDefaultMode = !isItemAvailable;

final Map<String, dynamic>? itemData =
    isFleetItem ? fleetData : productData;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.initRoleByItem(
    //     isFleetItem: isFleetItem,
    //     isProductItem: isProductItem,
    //   );
    // });

    String getPhotoUrl() {
      if (!isItemAvailable) return '';

      if (isFleetItem) {
        // Logic for fleet photos
        return itemData!['photo']?['photo'] ??
            (itemData['photos'] != null && itemData['photos'].isNotEmpty
                ? itemData['photos'][0]['photo']
                : '');
      } else {
        // Logic for product photos
        return itemData!['photos']?[0]?['photo'] ?? '';
      }
    }

    // Helper to get the name
    String getName() => itemData?['name'] ?? '';

    // Helper to get the type/category label
    String getTypeLabel() {
      if (!isItemAvailable) return '';
      return isFleetItem
          ? itemData!['type_label'] ?? ''
          : itemData!['category'] ?? '';
    }

    // Helper to get the type icon
    IconData getTypeIcon() {
      if (!isItemAvailable) return Icons.info_outline; // Default
      return isFleetItem
          ? (itemData!['type'] == 'car'
              ? Icons.directions_car_filled_outlined
              : Icons.motorcycle)
          : Icons.shopping_bag; // Default icon for product
    }

    // Helper to get the color
    String getColor() {
      if (!isItemAvailable) return '';
      return isFleetItem
          ? itemData!['color'] ?? ''
          : itemData!['specifications']?['color'] ?? '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Refactored item detail display section
        if (isItemAvailable) // Only show if fleet or product data exists
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return const Wrap(
                    children: [
                      RincianOrderModal(
                        isWithButton: false,
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        getPhotoUrl(), // Use helper function
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        poppinsText(
                          text: getName(), // Use helper function
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 5),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Icon(
                                getTypeIcon(), // Use helper function
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: poppinsText(
                                  text: getTypeLabel(), // Use helper function
                                  fontSize: 11,
                                  textColor: Colors.black,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  height: 12,
                                  child: VerticalDivider(color: Colors.black),
                                ),
                              ),
                              Icon(
                                Icons.invert_colors,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: poppinsText(
                                  text: getColor(), // Use helper function
                                  fontSize: 11,
                                  textColor: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: poppinsText(
                              text: "Klik Untuk Lihat Detail Sewa",
                              textColor: primaryColor,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        // End of Refactored item detail display section
        RegisterInput(
            title: "Nama Lengkap*",
            hintText: "Masukkan nama lengkap...",
            controller: controller.namaLengkapC,
            errText: controller.errorTextNama),
        RegisterInput(
            title: "Email*",
            hintText: "Masukkan email..",
            controller: controller.emailC,
            errText: controller.errorTextEmail,
            inputType: TextInputType.emailAddress),
        RegisterInput(
            title: "Nomor Telepon*",
            hintText: "Masukkan no telepon..",
            controller: controller.nomorTelpC,
            errText: controller.errorTextNomorTelp,
            inputType: TextInputType.number),
        RegisterInput(
            title: "Nomor Telepon Darurat*",
            hintText: "Masukkan no telepon darurat..",
            controller: controller.nomorDaruratC,
            errText: controller.errorTextNomorTelpDarurat,
            inputType: TextInputType.number),
        const SizedBox(
          height: 6,
        ),
        gabaritoText(
          text: "Jenis Kelamin",
          fontSize: 15,
          fontWeight: FontWeight.w500,
          textColor: textPrimary,
        ),
        const SizedBox(
          height: 5,
        ),
        Obx(() => CustomDropdown(
              hintText: "Pilih Jenis Kelamin..",
              items: controller.jenisKelamin,
              selectedValue: controller.selectedJenisKelamin.value,
              onChanged: (value) {
                controller.selectedJenisKelamin.value = value ?? '';
              },
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down_rounded),
            )),
        const SizedBox(
          height: 12,
        ),
        gabaritoText(
          text: "Tanggal Lahir*",
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () {
            picker.DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(1900),
              maxTime: DateTime.now(),
              onConfirm: (date) {
                final selectedDate = DateTime(date.year, date.month, date.day);
                controller.pickedDate.value = selectedDate.toIso8601String();
                print('confirm!@ ${controller.pickedDate.value}');
                controller.validateInput();
              },
              locale: picker.LocaleType.id,
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black54)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () {
                    if (controller.pickedDate.value == '') {
                      return Expanded(
                        child: gabaritoText(
                          text: "Pilih Tanggal Lahir...",
                          textColor: textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    } else {
                      return Expanded(
                        child: gabaritoText(
                          text: DateFormat('dd MMMM yyyy', "id_ID").format(
                              DateTime.parse(controller.pickedDate.value)),
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                  },
                ),
                const Icon(IconsaxPlusBold.calendar_edit)
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 6,
        ),

        if (isDefaultMode) ...[
          gabaritoText(
            text: "Jenis Akun*",
            fontSize: 15,
            fontWeight: FontWeight.w500,
            textColor: textPrimary,
          ),
          const SizedBox(height: 5),
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropdown(
                    hintText: "Pilih Jenis Akun",
                    items: controller.roles,
                    selectedValue: controller.selectedRole.value,
                    onChanged: (value) {
                      controller.selectedRole.value = value ?? '';
                    },
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                  ),
                  const SizedBox(height: 5),
                  if (controller.selectedRole.value == 'product_customer')
                    _supportingDocumentSection(),
                ],
              )),
        ],

        if (isProductItem) ...[
          _supportingDocumentSection(),
        ],

        RegisterInput(
          title: "Referral",
          hintText: "Masukkan referral..",
          controller: controller.referralCodeC,
          errText: controller.errorTextReferral,
          inputType: TextInputType.text,
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(() => newReusableTextField(
              title: "Password",
              hintText: "Masukan password...",
              icon: IconButton(
                icon: Icon(controller.isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  controller.isPasswordVisible.toggle();
                },
              ),
              obscureText: !controller.isPasswordVisible.value,
              controller: controller.passwordC,
              errorText: controller.errorTextPassword.value,
            )),
        const SizedBox(
          height: 10,
        ),
        Obx(() => newReusableTextField(
              title: "Konfirmasi Password",
              hintText: "Masukan password...",
              icon: IconButton(
                icon: Icon(controller.isConfirmPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  controller.isConfirmPasswordVisible.toggle();
                },
              ),
              obscureText: !controller.isConfirmPasswordVisible.value,
              controller: controller.confirmPasswordC,
              errorText: controller.errorTextPasswordConfirmation.value,
            )),
        const SizedBox(
          height: 20,
        ),
        Obx(
          () => ReusableButton(
            height: 55,
            bgColor: controller.allowedToRegistrasi.value
                ? primaryColor
                : Colors.grey,
            widget: Center(
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : gabaritoText(
                      text: "Lanjut",
                      textColor: Colors.white,
                      fontSize: 16,
                    ),
            ),
            ontap: () {
              controller.validateInput();
              if (controller.passwordC.text !=
                  controller.confirmPasswordC.text) {
                return CustomSnackbar.show(
                    title: "Terjadi Kesalahan",
                    message: "Konfirmasi Password Tidak Sesuai");
              }
              if (controller.allowedToRegistrasi.value) {
                controller.isUploadFile.value = true;
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(children: <Widget>[
            const Expanded(child: Divider()),
            gabaritoText(
              text: "Atau",
              fontSize: 14,
              textColor: textPrimary,
            ),
            const Expanded(child: Divider()),
          ]),
        ),
        Obx(
          () => ReusableButton(
            height: 55,
            bgColor: Colors.white,
            borderSideColor: Colors.grey.shade300,
            widget: Center(
              child: controller.isLoadingGoogle.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Logo
                        Image.network(
                          'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                          height: 24,
                          width: 24,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback: Use Google's official logo
                            return Image.network(
                              'https://www.google.com/images/branding/googleg/1x/googleg_standard_color_128dp.png',
                              height: 24,
                              width: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.g_mobiledata,
                                  size: 24,
                                  color: Color(0xFF4285F4), // Google Blue
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        const gabaritoText(
                          text: "Daftar dengan Google",
                          textColor: Colors.black87,
                          fontSize: 16,
                        ),
                      ],
                    ),
            ),
            ontap: () {
              controller.registerWithGoogle();
            },
          ),
        ),
        const SizedBox(height: 10),
        ReusableButton(
          height: 55,
          bgColor: Colors.white,
          borderSideColor: Colors.grey,
          textColor: solidPrimary,
          title: "Mode Tamu",
          ontap: () {
            Get.toNamed('/dashboard');
          },
        ),
      ],
    );
  }
}

Widget _supportingDocumentSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RegisterFileInput(
        keyFile: 'supporting_documents_url',
        title: "Dokumen Pendukung",
      ),
      const SizedBox(height: 5),
      Text(
        "*Wajib diisi untuk akun Product Customer. Upload dokumen pendukung seperti tiket Event, Konser, Pendakian, Hotel, dan Transportasi.*",
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
        ),
      ),
    ],
  );
}
