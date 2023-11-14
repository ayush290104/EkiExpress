import 'package:sixam_mart/controller/rider_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:sixam_mart/view/base/paginated_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/trip_history_item.dart';


class TripHistoryList extends StatelessWidget {
  final String type;
  TripHistoryList({@required this.type});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      body: GetBuilder<RiderController>(builder: (riderController) {


        return riderController.runningTrip != null ? riderController.runningTrip.orders.data.length > 0 ?
        RefreshIndicator(
          onRefresh: () async {
            await riderController.getRunningTripList(1, isUpdate: true);
          },
          child: Scrollbar(child: SingleChildScrollView(
            controller: scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: SizedBox(
                width: Dimensions.WEB_MAX_WIDTH,
                child: PaginatedListView(
                  scrollController: scrollController,
                  onPaginate: (int offset) => Get.find<RiderController>().getRunningTripList(offset, isUpdate: true),
                  totalSize: riderController.runningTrip != null ? riderController.runningTrip.totalSize : null,
                  offset: riderController.runningTrip != null ? int.parse(riderController.runningTrip.offset) : null,
                  itemView: ListView.builder(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    itemCount: riderController.runningTrip.orders.data.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      return TripHistoryItem(trip: riderController.runningTrip.orders.data[index]);
                    },
                  ),
                ),
              ),
            ),
          )),
        ) : NoDataScreen(text: 'no_trip_found'.tr, showFooter: true) : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
