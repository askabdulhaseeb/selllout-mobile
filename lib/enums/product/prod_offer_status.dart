enum ProdOfferStatusEnum {
  pending,
  approved,
  rejected,
}

class ProdOfferStatusEnumConvertor {
  static String toMap(ProdOfferStatusEnum status) {
    if (status == ProdOfferStatusEnum.pending) {
      return 'pending';
    } else if (status == ProdOfferStatusEnum.approved) {
      return 'approved';
    } else {
      return 'rejected';
    }
  }

  static ProdOfferStatusEnum fromMap(String status) {
    if (status == 'pending') {
      return ProdOfferStatusEnum.pending;
    } else if (status == 'approved') {
      return ProdOfferStatusEnum.approved;
    } else {
      return ProdOfferStatusEnum.rejected;
    }
  }
}
