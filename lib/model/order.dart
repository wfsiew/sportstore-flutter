class Order {
  String name;
  String line1;
  String line2;
  String line3;
  String city;
  String state;
  String zip;
  String country;
  bool giftwrap;

  Order({
    this.name,
    this.line1,
    this.line2,
    this.line3,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.giftwrap
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'line1': line1,
    'line2': line2 ?? '',
    'line3': line3 ?? '',
    'city': city,
    'state': state,
    'zip': zip,
    'country': country,
    'giftwrap': giftwrap
  };
}