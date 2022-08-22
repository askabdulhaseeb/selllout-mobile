enum GenderTypesEnum { male, female, others }

class GenderConverter {
  static String genderToString(GenderTypesEnum gender) {
    if (GenderTypesEnum.male == gender) {
      return 'male';
    } else if (GenderTypesEnum.female == gender) {
      return 'female';
    } else {
      return 'others';
    }
  }

  static GenderTypesEnum stringToGender(String gender) {
    if (gender == 'male') {
      return GenderTypesEnum.male;
    } else if (gender == 'female') {
      return GenderTypesEnum.female;
    } else {
      return GenderTypesEnum.others;
    }
  }
}
