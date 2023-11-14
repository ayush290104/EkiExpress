import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/data/model/response/category_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';import 'package:share_plus/share_plus.dart' as share_plus;

import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/item_widget.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/screens/checkout/checkout_screen.dart';
import 'package:sixam_mart/view/screens/store/widget/store_description_view.dart';

import '../../base/item_view.dart';
import '../../base/paginated_list_view.dart';
import 'widget/bottom_cart_widget.dart';

class StoreScreen extends StatefulWidget {
  final Store store;
  final bool fromModule;
  StoreScreen({@required this.store, @required this.fromModule});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ScrollController scrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;

  @override
  void initState() {
    super.initState();

    Get.find<StoreController>().hideAnimation();
    Get.find<StoreController>()
        .getStoreDetails(Store(id: widget.store.id), widget.fromModule)
        .then((value) {
      Get.find<StoreController>().showButtonAnimation();
    });
    if (Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<StoreController>()
        .getRestaurantRecommendedItemList(widget.store.id, false);
    Get.find<StoreController>()
        .getStoreItemList(widget.store.id, 1, 'all', false, null);

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (Get.find<StoreController>().showFavButton) {
          Get.find<StoreController>().changeFavVisibility();
          Get.find<StoreController>().hideAnimation();
        }
      } else {
        if (!Get.find<StoreController>().showFavButton) {
          Get.find<StoreController>().changeFavVisibility();
          Get.find<StoreController>().showButtonAnimation();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
        endDrawer: MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).cardColor,
        body: GetBuilder<StoreController>(builder: (storeController) {
          return GetBuilder<CategoryController>(builder: (catController) {
            Store _store;
            if (storeController.store != null &&
                storeController.store.name != null &&
                catController.categoryList != null) {
              _store = storeController.store;
            }
            storeController.setCategoryList();

            return (storeController.store != null &&
                    storeController.store.name != null &&
                    catController.categoryList != null)
                ? CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    slivers: [
                      ResponsiveHelper.isDesktop(context)
                          ? SliverToBoxAdapter(
                              child: Container(
                                color: Color(0xFF171A29),
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_LARGE),
                                alignment: Alignment.center,
                                child: Center(
                                    child: SizedBox(
                                        width: Dimensions.WEB_MAX_WIDTH,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: Row(children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .RADIUS_SMALL),
                                                child: CustomImage(
                                                  fit: BoxFit.cover,
                                                  height: 220,
                                                  image:
                                                      '${Get.find<SplashController>().configModel.baseUrls.storeCoverPhotoUrl}/${_store.coverPhoto}',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_LARGE),
                                            Expanded(
                                                child: StoreDescriptionView(
                                                    store: _store)),
                                          ]),
                                        ))),
                              ),
                            )
                          : SliverAppBar(
                              expandedHeight: 230,
                              toolbarHeight: 50,
                              pinned: true,
                              floating: false,
                              backgroundColor: Theme.of(context).primaryColor,
                              leading: IconButton(
                                icon: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.chevron_left,
                                      color: Theme.of(context).cardColor),
                                ),
                                onPressed: () => Get.back(),
                              ),
                              flexibleSpace: FlexibleSpaceBar(
                                background: CustomImage(
                                  fit: BoxFit.cover,
                                  image:
                                      '${Get.find<SplashController>().configModel.baseUrls.storeCoverPhotoUrl}/${_store.coverPhoto}',
                                ),
                              ),
                              actions: [
                                IconButton(
                                  onPressed: () => Get.toNamed(
                                      RouteHelper.getSearchStoreItemRoute(
                                          _store.id)),
                                  icon: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor),
                                    alignment: Alignment.center,
                                    child: Icon(Icons.search,
                                        size: 20,
                                        color: Theme.of(context).cardColor),
                                  ),
                                ),
                              ],
                            ),
                      SliverToBoxAdapter(
                          child: Center(
                              child: Container(
                        width: Dimensions.WEB_MAX_WIDTH,
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        color: Theme.of(context).cardColor,
                        child: Column(children: [
                          ResponsiveHelper.isDesktop(context)
                              ? SizedBox()
                              : StoreDescriptionView(store: _store),
                          _store.discount != null
                              ? Container(
                                  width: context.width,
                                  margin: EdgeInsets.symmetric(
                                      vertical: Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      color: Theme.of(context).primaryColor),
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _store.discount.discountType ==
                                                  'percent'
                                              ? '${_store.discount.discount}% OFF'
                                              : '${PriceConverter.convertPrice(_store.discount.discount)} OFF',
                                          style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                              color:
                                                  Theme.of(context).cardColor),
                                          textDirection: TextDirection.ltr,
                                        ),
                                        Text(
                                          _store.discount.discountType ==
                                                  'percent'
                                              ? '${'enjoy'.tr} ${_store.discount.discount}% ${'off_on_all_categories'.tr}'
                                              : '${'enjoy'.tr} ${PriceConverter.convertPrice(_store.discount.discount)}'
                                                  ' ${'off_on_all_categories'.tr}',
                                          style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color:
                                                  Theme.of(context).cardColor),
                                          textDirection: TextDirection.ltr,
                                        ),
                                        SizedBox(
                                            height:
                                                (_store.discount.minPurchase !=
                                                            0 ||
                                                        _store.discount
                                                                .maxDiscount !=
                                                            0)
                                                    ? 5
                                                    : 0),
                                        _store.discount.minPurchase != 0
                                            ? Text(
                                                '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(_store.discount.minPurchase)} ]',
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraSmall,
                                                    color: Theme.of(context)
                                                        .cardColor),
                                                textDirection:
                                                    TextDirection.ltr,
                                              )
                                            : SizedBox(),
                                        _store.discount.maxDiscount != 0
                                            ? Text(
                                                '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(_store.discount.maxDiscount)} ]',
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraSmall,
                                                    color: Theme.of(context)
                                                        .cardColor),
                                                textDirection:
                                                    TextDirection.ltr,
                                              )
                                            : SizedBox(),
                                        Text(
                                          '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(_store.discount.startTime)} '
                                          '- ${DateConverter.convertTimeToTime(_store.discount.endTime)} ]',
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeExtraSmall,
                                              color:
                                                  Theme.of(context).cardColor),
                                        ),
                                      ]),
                                )
                              : SizedBox(),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          storeController.recommendedItemModel != null &&
                                  storeController
                                          .recommendedItemModel.items.length >
                                      0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('recommended_items'.tr,
                                        style: robotoMedium),
                                    SizedBox(
                                        height: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    SizedBox(
                                      height:
                                          ResponsiveHelper.isDesktop(context)
                                              ? 150
                                              : 120,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: storeController
                                            .recommendedItemModel.items.length,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: ResponsiveHelper.isDesktop(
                                                    context)
                                                ? EdgeInsets.symmetric(
                                                    vertical: 20)
                                                : EdgeInsets.symmetric(
                                                    vertical: 10),
                                            child: Container(
                                              width: ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? 500
                                                  : 300,
                                              decoration: ResponsiveHelper
                                                      .isDesktop(context)
                                                  ? null
                                                  : BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .RADIUS_DEFAULT),
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      border: Border.all(
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                          width: 0.2),
                                                      boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                      .grey[
                                                                  Get.isDarkMode
                                                                      ? 700
                                                                      : 300],
                                                              blurRadius: 5)
                                                        ]),
                                              padding: EdgeInsets.only(
                                                  right: Dimensions
                                                      .PADDING_SIZE_SMALL,
                                                  left: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              margin: EdgeInsets.only(
                                                  right: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              child: ItemWidget(
                                                isStore: false,
                                                item: storeController
                                                    .recommendedItemModel
                                                    .items[index],
                                                store: null,
                                                index: index,
                                                length: null,
                                                isCampaign: false,
                                                inStore: true,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ]),
                      ))),
                      (storeController.categoryList.length > 0)
                          ? SliverPersistentHeader(
                              pinned: true,
                              delegate: SliverDelegate(
                                  child: Center(
                                      child: Container(
                                height: 50,
                                width: Dimensions.WEB_MAX_WIDTH,
                                color: Theme.of(context).cardColor,
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      storeController.categoryList.length,
                                  padding: EdgeInsets.only(
                                      left: Dimensions.PADDING_SIZE_SMALL),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () async {
                                        await Get.find<CategoryController>()
                                            .getSubCategoryList(
                                                "${storeController.categoryList[index].id}",
                                                fromStore: true);
                                        storeController.setCategoryIndex(index);

                                        storeController.getProducts(index == 0
                                            ? 0
                                            : storeController
                                                .categoryList[index].id);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: index == 0
                                              ? Dimensions.PADDING_SIZE_LARGE
                                              : Dimensions.PADDING_SIZE_SMALL,
                                          right: index ==
                                                  storeController
                                                          .categoryList.length -
                                                      1
                                              ? Dimensions.PADDING_SIZE_LARGE
                                              : Dimensions.PADDING_SIZE_SMALL,
                                          top: Dimensions.PADDING_SIZE_SMALL,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(
                                              _ltr
                                                  ? index == 0
                                                      ? Dimensions
                                                          .RADIUS_EXTRA_LARGE
                                                      : 0
                                                  : index ==
                                                          storeController
                                                                  .categoryList
                                                                  .length -
                                                              1
                                                      ? Dimensions
                                                          .RADIUS_EXTRA_LARGE
                                                      : 0,
                                            ),
                                            right: Radius.circular(
                                              _ltr
                                                  ? index ==
                                                          storeController
                                                                  .categoryList
                                                                  .length -
                                                              1
                                                      ? Dimensions
                                                          .RADIUS_EXTRA_LARGE
                                                      : 0
                                                  : index == 0
                                                      ? Dimensions
                                                          .RADIUS_EXTRA_LARGE
                                                      : 0,
                                            ),
                                          ),
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                        ),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${storeController.categoryList[index].name}",
                                                style: index ==
                                                        storeController
                                                            .categoryIndex
                                                    ? robotoMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeSmall,
                                                        color: Theme.of(context)
                                                            .primaryColor)
                                                    : robotoRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeSmall,
                                                        color: Theme.of(context)
                                                            .disabledColor),
                                              ),
                                              index ==
                                                      storeController
                                                          .categoryIndex
                                                  ? Container(
                                                      height: 5,
                                                      width: 5,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          shape:
                                                              BoxShape.circle),
                                                    )
                                                  : SizedBox(
                                                      height: 5, width: 5),
                                            ]),
                                      ),
                                    );
                                  },
                                ),
                              ))),
                            )
                          : SliverToBoxAdapter(child: SizedBox()),
                      (catController.subCategoryList != null &&
                              !catController.isSearching &&
                              storeController.categoryIndex != 0)
                          ? SliverToBoxAdapter(
                              child: Center(
                                  child: Container(
                              height: 115,
                              width: Dimensions.WEB_MAX_WIDTH,
                              color: Theme.of(context).cardColor,
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: catController.subCategoryList.length,
                                padding: EdgeInsets.only(
                                    left: Dimensions.PADDING_SIZE_SMALL),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      catController.setSubCategoryIndex(index,
                                          "${storeController.categoryIndex}",
                                          fromStore: true);
                                      storeController.getProducts(index == 0
                                          ? storeController
                                              .categoryList[
                                                  storeController.categoryIndex]
                                              .id
                                          : catController
                                              .subCategoryList[index].id);
                                    },
                                    child: Container(
                                      width: 290,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL,
                                      ),
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.horizontal(
                                        //   left: Radius.circular(
                                        //     _ltr
                                        //         ? index == 0
                                        //             ? Dimensions
                                        //                 .RADIUS_EXTRA_LARGE
                                        //             : 0
                                        //         : index ==
                                        //                 catController
                                        //                         .subCategoryList
                                        //                         .length -
                                        //                     1
                                        //             ? Dimensions
                                        //                 .RADIUS_EXTRA_LARGE
                                        //             : 0,
                                        //   ),
                                        //   right: Radius.circular(
                                        //     _ltr
                                        //         ? index ==
                                        //                 catController
                                        //                         .subCategoryList
                                        //                         .length -
                                        //                     1
                                        //             ? Dimensions
                                        //                 .RADIUS_EXTRA_LARGE
                                        //             : 0
                                        //         : index == 0
                                        //             ? Dimensions
                                        //                 .RADIUS_EXTRA_LARGE
                                        //             : 0,
                                        //   ),
                                        // ),

                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FadeInImage.assetNetwork(
                                                  placeholder:
                                                      "assets/image/placeholder.jpg",
                                                  height: 80,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    return Image.asset(
                                                      "assets/image/placeholder.jpg",
                                                      height: 80,
                                                      width: 80,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                  image:
                                                      '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${catController.subCategoryList[index].image}'),
                                              SizedBox(
                                                width: 180,
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        catController
                                                            .subCategoryList[
                                                                index]
                                                            .name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: index ==
                                                                catController
                                                                    .subCategoryIndex
                                                            ? robotoMedium.copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor)
                                                            : robotoRegular.copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      SizedBox(
                                                        width: 170,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 140,
                                                              child: Text(
                                                                catController
                                                                        .subCategoryList[
                                                                            index]
                                                                        .description ??
                                                                    "",
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: index ==
                                                                        catController
                                                                            .subCategoryIndex
                                                                    ? robotoMedium.copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall -
                                                                                1,
                                                                        color: Theme.of(context)
                                                                            .primaryColor)
                                                                    : robotoRegular.copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall -
                                                                                1,
                                                                        color: Theme.of(context)
                                                                            .disabledColor),
                                                              ),
                                                            ),
                                                            if (catController
                                                                    .subCategoryList[
                                                                        index]
                                                                    .description !=
                                                                null)
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Get.dialog(
                                                                          AlertDialog(
                                                                        iconPadding:
                                                                            EdgeInsets.zero,
                                                                        insetPadding:
                                                                            EdgeInsets.zero,
                                                                        titlePadding:
                                                                            EdgeInsets.zero,
                                                                        actionsPadding:
                                                                            EdgeInsets.zero,
                                                                        buttonPadding:
                                                                            EdgeInsets.zero,
                                                                        contentPadding:
                                                                            EdgeInsets.zero,
                                                                        content:
                                                                            AlertBox(
                                                                          categoryModel:
                                                                              catController.subCategoryList[index],
                                                                        ),
                                                                      ));
                                                                    },
                                                                    child: Icon(
                                                                        Icons
                                                                            .info),
                                                                  ),
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                          String
                                                                          messageToSend =
                                                                              "Look what I found out.\n\n${catController.subCategoryList[index].name}\n\n${catController.subCategoryList[index].description}\n\n https://ekiexpress.com";

                                                                          if(GetPlatform.isAndroid || GetPlatform.isIOS)               {
                                                                        await downloadFile("${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/" + catController.subCategoryList[index].image,
                                                                                catController.subCategoryList[index].name)
                                                                            .then((value) {
                                                                        if (value !=
                                                                              null)
                                                                            Share.shareFiles([
                                                                              value
                                                                            ], text: messageToSend);
                                                                          else
                                                                            Share.share(messageToSend);
                                                                        });
                                                                      }
                                                           else if(GetPlatform.isWeb){
                                                             shareImage(
                                                                ["${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/" + catController.subCategoryList[index].image],
                                                                 messageToSend);
                                                           }
                                                                    },
                                                                    child: Icon(
                                                                        Icons
                                                                            .share),
                                                                  ),
                                                                ],
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                          index ==
                                                  catController.subCategoryIndex
                                              ? Container(
                                                  height: 5,
                                                  width: 5,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      shape: BoxShape.circle),
                                                )
                                              : SizedBox(height: 5, width: 5),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )))
                          : SliverToBoxAdapter(child: SizedBox()),
                      SliverToBoxAdapter(
                          child: FooterView(
                              child: Container(
                        width: Dimensions.WEB_MAX_WIDTH,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                        ),
                        child: PaginatedListView(
                          scrollController: scrollController,
                          onPaginate: (int offset) =>
                              storeController.getStoreItemList(widget.store.id,
                                  offset, storeController.type, false, null),
                          totalSize: storeController.storeItemModel != null
                              ? storeController.storeItemModel.totalSize
                              : null,
                          offset: storeController.storeItemModel != null
                              ? storeController.storeItemModel.offset
                              : null,
                          itemView: ItemsView(
                            isStore: false,
                            stores: null,
                            items: (storeController.categoryList.length > 0 &&
                                    storeController.storeItemModel != null)
                                ? storeController.storeItemModel.items
                                : null,
                            inStorePage: true,
                            type: storeController.type,
                            onVegFilterTap: (String type) {
                              storeController.getStoreItemList(
                                  storeController.store.id,
                                  1,
                                  type,
                                  true,
                                  null);
                            },
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL,
                              vertical: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.PADDING_SIZE_SMALL
                                  : 0,
                            ),
                          ),
                        ),
                      ))),
                    ],
                  )
                : Center(child: CircularProgressIndicator());
          });
        }),
        floatingActionButton:
            GetBuilder<StoreController>(builder: (storeController) {
          return Visibility(
            visible: storeController.showFavButton &&
                Get.find<SplashController>()
                    .configModel
                    .moduleConfig
                    .module
                    .orderAttachment &&
                (storeController.store != null &&
                    storeController.store.prescriptionOrder) &&
                Get.find<SplashController>().configModel.prescriptionStatus,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 800),
                width: storeController.currentState == false
                    ? 0
                    : ResponsiveHelper.isDesktop(context)
                        ? 180
                        : 150,
                height: 30,
                curve: Curves.linear,
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.bodyLarge.color,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                child: storeController.currentState
                    ? Center(
                        child: Text(
                          'prescription_order'.tr,
                          textAlign: TextAlign.center,
                          style: robotoMedium.copyWith(
                              color: Theme.of(context).cardColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : SizedBox(),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              FloatingActionButton(
                onPressed: () => Get.toNamed(
                  RouteHelper.getCheckoutRoute('prescription',
                      storeId: storeController.store.id),
                  arguments: CheckoutScreen(
                      fromCart: false,
                      cartList: null,
                      storeId: storeController.store.id),
                ),
                child: Icon(Icons.assignment_outlined,
                    size: 20, color: Theme.of(context).cardColor),
              ),
            ]),
          );
        }),
        bottomNavigationBar:
            GetBuilder<CartController>(builder: (cartController) {
          return cartController.cartList.length > 0 &&
                  !ResponsiveHelper.isDesktop(context)
              ? BottomCartWidget()
              : SizedBox();
        }));
  }

  Future<String> downloadFile(String url, String name) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final appDir = await getExternalStorageDirectory();
        final filename =
            '$name.png'; // Set the desired file name and extension.
        final file = File('${appDir.path}/$filename');
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      } else {
        print('Failed to download file. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error while downloading file: $e');
      return null;
    }



  }
  Future<void> shareImage(List<String> images, String text) async {
    var imagesString = "Images: \n";
    images.forEach((element) {
      imagesString = imagesString + element + "\n";
    });
    imagesString = imagesString + "\n Details: \n" + text;
    share_plus.Share.share(imagesString);
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}

class CategoryProduct {
  CategoryModel category;
  List<Item> products;
  CategoryProduct(this.category, this.products);
}

class AlertBox extends StatelessWidget {
  const AlertBox({Key key, @required this.categoryModel}) : super(key: key);
  final CategoryModel categoryModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .7,
          maxWidth: MediaQuery.of(context).size.width * .5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              categoryModel.description ?? "",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
