import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/detailitems_controller.dart';
import 'package:transgomobileapp/app/data/theme.dart';

class AddonsListView extends StatelessWidget {
  final DetailitemsController controller;

  const AddonsListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final availableAddons = controller.addonsList
          .where((a) =>
              a['is_available'] == true && (a['available_quantity'] ?? 0) > 0)
          .toList();

      if (availableAddons.isEmpty) {
        return const SizedBox.shrink();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: availableAddons.length,
        itemBuilder: (context, index) {
          final addon = availableAddons[index];

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addon['name'] ?? "-",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          addon['description'] ?? "-",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Rp.${addon['price'] ?? 0}",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Tersedia: ${addon['available_quantity'] ?? 0}",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          final selectedIndex = controller.selectedAddons
                              .indexWhere((e) => e['id'] == addon['id']);
                          final qty = selectedIndex >= 0
                              ? controller.selectedAddons[selectedIndex]
                                  ['quantity'] as int
                              : 0;

                          if (qty > 0) {
                            _updateSelectedAddons(addon, qty - 1);
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: primaryColor,
                      ),
                      Obx(
                        () {
                          final selectedIndex = controller.selectedAddons
                              .indexWhere((e) => e['id'] == addon['id']);
                          final qty = selectedIndex >= 0
                              ? controller.selectedAddons[selectedIndex]
                                  ['quantity'] as int
                              : 0;
                          return Text(
                            qty.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          final selectedIndex = controller.selectedAddons
                              .indexWhere((e) => e['id'] == addon['id']);
                          final qty = selectedIndex >= 0
                              ? controller.selectedAddons[selectedIndex]
                                  ['quantity'] as int
                              : 0;
                          final maxQty = addon['available_quantity'] ?? 0;

                          if (qty < maxQty) {
                            _updateSelectedAddons(addon, qty + 1);
                          }
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: primaryColor,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _updateSelectedAddons(Map<String, dynamic> addon, int qty) {
    final index =
        controller.selectedAddons.indexWhere((e) => e['id'] == addon['id']);
    if (qty <= 0) {
      if (index >= 0) controller.selectedAddons.removeAt(index);
    } else {
      if (index >= 0) {
        controller.selectedAddons[index]['quantity'] = qty;
      } else {
        controller.selectedAddons.add({
          "id": addon['id'],
          "name": addon['name'],
          "price": addon['price'],
          "quantity": qty,
        });
      }
    }

    controller.selectedAddons.refresh();
    controller.getDetailAPI(false);
  }
}
