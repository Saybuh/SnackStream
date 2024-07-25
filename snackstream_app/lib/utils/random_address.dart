import 'dart:math';

class RandomAddress {
  static const List<String> atlantaAddresses = [
    '123 Peachtree St NE, Atlanta, GA 30303',
    '456 Ponce De Leon Ave NE, Atlanta, GA 30308',
    '789 Northside Dr NW, Atlanta, GA 30318',
    '321 Piedmont Ave NE, Atlanta, GA 30308',
    '654 Moreland Ave SE, Atlanta, GA 30312',
    '987 Dekalb Ave NE, Atlanta, GA 30307',
    '246 Ivan Allen Jr Blvd NW, Atlanta, GA 30313',
    '135 Auburn Ave NE, Atlanta, GA 30303',
    '864 Capitol Ave SE, Atlanta, GA 30315',
    '753 Baker St NW, Atlanta, GA 30313',
  ];

  static String getRandomAddress() {
    final random = Random();
    return atlantaAddresses[random.nextInt(atlantaAddresses.length)];
  }
}
