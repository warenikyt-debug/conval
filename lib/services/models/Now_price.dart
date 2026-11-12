class NowPrice {
  final String base;
  final Map<String, num> kurs;
  final String updatedAt;
  
  NowPrice({required this.base, required this.kurs, required this.updatedAt});
  factory NowPrice.fromJson(Map<String, dynamic> json)
  {
    final baseCode = json["base_code"] as String;
    final kursMap = Map<String,num>.from(json['rates'] as Map<String, dynamic>);
    final date = json["time_last_update_utc"] as String;
    return NowPrice(base: baseCode, kurs: kursMap, updatedAt: date);
  }
}
