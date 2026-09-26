import 'package:easy_localization/easy_localization.dart';
import 'package:rawg/features/dashboard/domain/entities/sort_item.dart';

abstract final class SortOptionConstants {
  static List<SortItem> get platforms => [SortItem(id: 1, name: 'sort.playstation'.tr(), value: '18,16,15,27,19,17,14,80'), SortItem(id: 2, name: 'sort.xbox'.tr(), value: '1,186,14,80'), SortItem(id: 3, name: 'sort.pc'.tr(), value: '4')];
}
