enum ProdPrivacyTypeEnum { public, supporters, private }

class ProdPrivacyTypeEnumConvertor {
  static String enumToString({required ProdPrivacyTypeEnum privacy}) {
    if (privacy == ProdPrivacyTypeEnum.public) {
      return 'public';
    } else if (privacy == ProdPrivacyTypeEnum.supporters) {
      return 'supporters';
    } else {
      return 'private';
    }
  }

  static ProdPrivacyTypeEnum stringToEnum({required String privacy}) {
    if (privacy == 'public') {
      return ProdPrivacyTypeEnum.public;
    } else if (privacy == 'supporters') {
      return ProdPrivacyTypeEnum.supporters;
    } else {
      return ProdPrivacyTypeEnum.private;
    }
  }
}
