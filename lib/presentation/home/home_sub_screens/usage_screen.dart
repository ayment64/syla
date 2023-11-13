import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syla/controller/authentication_controller/coverage_controller.dart';
import 'package:syla/shared/Styles/text_styles.dart';

import '../../../controller/authentication_controller/usage_controller.dart';

class UsageScreen extends StatelessWidget {
  const UsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: UsageController(),
      child: Consumer<UsageController>(builder:
          (BuildContext context, UsageController controller, Widget? _) {
        if (controller.usageState == UsageState.initial) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            controller.initilize();
          });
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Usage"),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.52),
                itemCount: controller.activeOffers.length,
                itemBuilder: (context, index) =>
                    GridViewItem(element: controller.activeOffers[index])),
          ),
        );
      }),
    );
  }
}

class GridViewItem extends StatelessWidget {
  final OfferScheme element;
  const GridViewItem({
    required this.element,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 5))
          ]),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            element.offerName,
            style: usageCardTitle,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 0),
            child: SleekCircularSlider(
              min: 0,
              max: element.moreThenOneGb
                  ? element.internetQuotaInGb
                  : element.internetQuotaInMb.toDouble(),
              initialValue: element.moreThenOneGb
                  ? element.internetQuotaInGb
                  : element.internetQuotaInMb.toDouble(),
              appearance: circularSliderAppearance(element),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Flexible(
              child: Text(
            "Date: 19-06-2023",
            style: usageCardInfo,
          )),
          Flexible(
              child: Text(
            "Country: ${element.country} ",
            style: usageCardInfo,
          )),
          Flexible(
              child: Text(
            "Operator: ooredoo",
            style: usageCardInfo,
          )),
        ],
      ),
    );
  }
}

circularSliderAppearance(OfferScheme element) {
  return CircularSliderAppearance(
      size: 150,
      customWidths: CustomSliderWidths(
        progressBarWidth: 12,
        trackWidth: 2,
      ),
      customColors: CustomSliderColors(
        dotColor: Colors.transparent,
        trackColor: Colors.grey[300],
        progressBarColors: [
          const Color(0xff4369AE),
          const Color(0xff4197D0),
        ],
        trackColors: [
          const Color(0xff4369AE),
          const Color(0xff4197D0),
        ],
        hideShadow: true,
      ),
      infoProperties: InfoProperties(
        modifier: (double value) {
          return '${value.toInt()} ${element.moreThenOneGb ? "Gb" : "MB"}';
        },
        mainLabelStyle: const TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
      ));
}
