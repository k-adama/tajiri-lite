import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/split_paiement.entity.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/components/amount_to_paid.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';

class SplitPaiementScreen extends StatefulWidget {
  final Order? order;
  const SplitPaiementScreen({super.key, required this.order});

  @override
  State<SplitPaiementScreen> createState() => _SplitPaiementScreenState();
}

class _SplitPaiementScreenState extends State<SplitPaiementScreen> {
  List<SplitPaiementItem> paiements = [];

  // Méthode pour ajouter un paiement à la liste
  void addPaiement(SplitPaiementItem splitPaiementItem) {
    setState(() {
      paiements.add(splitPaiementItem);
    });
  }

  // Méthode pour supprimer un paiement de la liste
  void removePaiement(int index) {
    if (paiements.isEmpty) {
      return;
    }
    setState(() {
      paiements.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "Diviser le paiement",
          style: Style.interBold(),
        ),
        elevation: 1,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UnconstrainedBox(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Style.brandColor50,
                              width: .5,
                            ),
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  removePaiement(paiements.length - 1);
                                },
                                icon: const Icon(
                                  Icons.remove,
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Style.brandColor50,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Center(
                                  child: Text(paiements.length.toString()),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  addPaiement(SplitPaiementItem(
                                      idMethodPaiement: null,
                                      nameMethodPaiement: null,
                                      amount: null));
                                },
                                icon: const Icon(
                                  Icons.add,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'Nombre de paiements',
                        style:
                            Style.interNormal(size: 12, color: Style.grey500),
                      ),
                      const SizedBox(height: 30),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: paiements.length,
                        itemBuilder: (context, index) {
                          final paiement = paiements[index];
                          return SplitPaiementItemComponent(
                            downMenuItems: _buildDropdownMenuItems(paiement),
                            valueDropDown: paiement.idMethodPaiement,
                            removePaiement: () {
                              removePaiement(index);
                            },
                            onChanged: (value) {
                              setState(() {
                                paiement.amount = double.tryParse(value);
                              });
                            },
                            onChangedDropDown: (String? newValue) {
                              setState(() {
                                paiement.idMethodPaiement = newValue!;
                                paiement.nameMethodPaiement =
                                    getNamePaiementById(newValue);
                                log(paiement.nameMethodPaiement.toString());
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(thickness: 1.5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  12.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          title: "Suivant",
                          textColor: Style.white,
                          background: Style.brandColor500,
                          radius: 4,
                          onPressed: () {},
                        ),
                      ),
                      12.horizontalSpace,
                      TotalCardComponent(
                        total: widget.order?.grandTotal,
                      )
                    ],
                  ),
                ],
              ),
            ),
            (MediaQuery.of(context).padding.bottom + 10).verticalSpace,
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems(
      SplitPaiementItem paiement) {
    final selectedPaymentIds =
        paiements.map((item) => item.idMethodPaiement).toList();

    return PAIEMENTS.map<DropdownMenuItem<String>>((payment) {
      final name = payment['name'] as String;
      final id = payment['id'] as String;
      return DropdownMenuItem<String>(
        enabled: !selectedPaymentIds.contains(id),
        value: id,
        child: Text(name),
      );
    }).toList();
  }
}

class SplitPaiementItemComponent extends StatelessWidget {
  final Function(String)? onChanged;
  final List<DropdownMenuItem<String>> downMenuItems;
  final String? valueDropDown;
  final VoidCallback removePaiement;
  final void Function(String?)? onChangedDropDown;
  const SplitPaiementItemComponent(
      {super.key,
      this.onChanged,
      required this.downMenuItems,
      required this.valueDropDown,
      required this.removePaiement,
      this.onChangedDropDown});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Style.grey300, width: .5),
                    ),
                    child: DropdownButtonFormField(
                      padding: EdgeInsets.zero,
                      style: Style.interNormal(size: 12, color: Style.grey950),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      items: downMenuItems,
                      onChanged: onChangedDropDown,
                      value: valueDropDown,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child:
                      // ? Container(
                      //     width: 40,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //       color: Style.alertGreen50,
                      //       borderRadius: BorderRadius.circular(3.6),
                      //     ),
                      //     child: Center(
                      //       child: SvgPicture.asset('assets/svgs/check.svg'),
                      //     ),
                      //   )
                      // :
                      CustomButton(
                    title: "Valider",
                    textColor: Style.brandColor500,
                    isUnderline: true,
                    isLoading: false,
                    background: Style.brandColor50,
                    radius: 4,
                    onPressed: () {},
                  ),
                ),
                GestureDetector(
                  onTap: removePaiement,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Style.brandBlue950,
                      borderRadius: BorderRadius.circular(3.6),
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/svgs/delete.svg'),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    cursorColor: Style.brandColor500,
                    style: Style.interBold(),
                    keyboardType: TextInputType.number,
                    onChanged: onChanged,
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Style.brandColor500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            )
          ],
        ),
        48.verticalSpace,
      ],
    );
  }
}
