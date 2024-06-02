import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/data/helpers/banner_model.dart';

class BannerService {
  List<BannerModel> getBanners() {
    return [
      BannerModel(imgPath: '${Helpers.imgUrl}/banner_1.png', id: '1'),
      BannerModel(imgPath: '${Helpers.imgUrl}/banner_1.png', id: '2'),
      BannerModel(imgPath: '${Helpers.imgUrl}/banner_1.png', id: '3'),
    ];
  }
}
