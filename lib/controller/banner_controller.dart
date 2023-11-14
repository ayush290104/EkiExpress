import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/banner_model.dart';
import 'package:sixam_mart/data/repository/banner_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';

class BannerController extends GetxController implements GetxService {
  final BannerRepo bannerRepo;
  BannerController({@required this.bannerRepo});

  List<String> _bannerImageList;
  List<String> _taxiBannerImageList;
  List<String> _featuredBannerList;
  List<dynamic> _bannerDataList;
  List<dynamic> _taxiBannerDataList;
  List<dynamic> _featuredBannerDataList;
  int _currentIndex = 0;

  List<String> get bannerImageList => _bannerImageList;
  List<String> get featuredBannerList => _featuredBannerList;
  List<dynamic> get bannerDataList => _bannerDataList;
  List<dynamic> get featuredBannerDataList => _featuredBannerDataList;
  int get currentIndex => _currentIndex;
  List<String> get taxiBannerImageList => _taxiBannerImageList;
  List<dynamic> get taxiBannerDataList => _taxiBannerDataList;

  Future<void> getFeaturedBanner() async {
    Response response = await bannerRepo.getFeaturedBannerList();
    if (response.statusCode == 200) {
      _featuredBannerList = [];
      _featuredBannerDataList = [];
      BannerModel _bannerModel = BannerModel.fromJson(response.body);
      List<int> _moduleIdList = [];
      Get.find<LocationController>().getUserAddress().zoneData.forEach((zone) {
        zone.modules.forEach((module) => _moduleIdList.add(module.id));
      });
      _bannerModel.campaigns.forEach((campaign) {
        _featuredBannerList.add(campaign.image);
        _featuredBannerDataList.add(campaign);
      });
      _bannerModel.banners.forEach((banner) {
        _featuredBannerList.add(banner.image);
        if(banner.item != null && _moduleIdList.contains(banner.item.moduleId)) {
          _featuredBannerDataList.add(banner.item);
        }else if(banner.store != null && _moduleIdList.contains(banner.store.moduleId)) {
          _featuredBannerDataList.add(banner.store);
        }else if(banner.type == 'default') {
          _featuredBannerDataList.add(banner.link);
        }else{
          _featuredBannerDataList.add(null);
        }
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getBannerList(bool reload) async {
    if(_bannerImageList == null || reload) {
      _bannerImageList = null;
      Response response = await bannerRepo.getBannerList();
      if (response.statusCode == 200) {
        _bannerImageList = [];
        _bannerDataList = [];
        BannerModel _bannerModel = BannerModel.fromJson(response.body);
        _bannerModel.campaigns.forEach((campaign) {
          _bannerImageList.add(campaign.image);
          _bannerDataList.add(campaign);
        });
        _bannerModel.banners.forEach((banner) {
          _bannerImageList.add(banner.image);
          if(banner.item != null) {
            _bannerDataList.add(banner.item);
          }else if(banner.store != null){
            _bannerDataList.add(banner.store);
          }else if(banner.type == 'default'){
            _bannerDataList.add(banner.link);
          }else{
            _bannerDataList.add(null);
          }
        });
        if(ResponsiveHelper.isDesktop(Get.context) && _bannerImageList.length % 2 != 0){
          _bannerImageList.add(_bannerImageList[0]);
          _bannerDataList.add(_bannerDataList[0]);
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> getTaxiBannerList(bool reload) async {
    if(_taxiBannerImageList == null || reload) {
      _taxiBannerImageList = null;
      Response response = await bannerRepo.getTaxiBannerList();
      if (response.statusCode == 200) {
        _taxiBannerImageList = [];
        _taxiBannerDataList = [];
        BannerModel _bannerModel = BannerModel.fromJson(response.body);
        _bannerModel.campaigns.forEach((campaign) {
          _taxiBannerImageList.add(campaign.image);
          _taxiBannerDataList.add(campaign);
        });
        _bannerModel.banners.forEach((banner) {
          _taxiBannerImageList.add(banner.image);
          if(banner.item != null) {
            _taxiBannerDataList.add(banner.item);
          }else if(banner.store != null){
            _taxiBannerDataList.add(banner.store);
          }else if(banner.type == 'default'){
            _taxiBannerDataList.add(banner.link);
          }else{
            _taxiBannerDataList.add(null);
          }
        });
        if(ResponsiveHelper.isDesktop(Get.context) && _taxiBannerImageList.length % 2 != 0){
          _taxiBannerImageList.add(_taxiBannerImageList[0]);
          _taxiBannerDataList.add(_taxiBannerDataList[0]);
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }
}
