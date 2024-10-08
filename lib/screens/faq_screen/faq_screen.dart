import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/widgets/no_data_found.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/faq_screen/faq_controller.dart';
import 'package:untitled/utilities/const.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FAQsController controller = FAQsController();
    return Scaffold(
      body: Column(children: [
        const TopBarForInView(title: LKeys.faqS),
        GetBuilder(
          init: controller,
          builder: (controller) {
            return Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        var cat = controller.categories[index];
                        return GestureDetector(
                          onTap: () => controller.onTapCategory(cat),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: ShapeDecoration(
                                color: controller.selectedCat?.id == cat.id
                                    ? cPrimary
                                    : cLightBg,
                                shape: const SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius.all(
                                        SmoothRadius(
                                            cornerRadius: 20,
                                            cornerSmoothing:
                                                cornerSmoothing)))),
                            child: Text(
                              cat.title ?? '',
                              style: MyTextStyle.gilroySemiBold(
                                  color: controller.selectedCat?.id == cat.id
                                      ? cBlack
                                      : cDarkText.withOpacity(0.8)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: controller.selectedCat?.faqs?.isEmpty == true
                        ? NoDataFound(controller: controller)
                        : ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: controller.selectedCat?.faqs?.length,
                            itemBuilder: (context, index) {
                              var faq = controller.selectedCat?.faqs?[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                decoration: const ShapeDecoration(
                                    color: cLightBg,
                                    shape: SmoothRectangleBorder(
                                        borderRadius: SmoothBorderRadius.all(
                                            SmoothRadius(
                                                cornerRadius: 8,
                                                cornerSmoothing:
                                                    cornerSmoothing)))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(faq?.question ?? '',
                                        style: MyTextStyle.gilroyBold(
                                            color: cDarkText)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      faq?.answer ?? '',
                                      style: MyTextStyle.gilroyRegular(
                                          color: cLightText),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
            );
          },
        )
      ]),
    );
  }
}
