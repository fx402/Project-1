class ItemCategories{
  int id;
  String nameItem;
  String img;
  int prices;

  ItemCategories({required this.id, required this.nameItem, required this.prices, required this.img});

  factory ItemCategories.fromJson(Map<String, dynamic> json) =>  ItemCategories(
    id : json['id'],
    nameItem : json['nameItem'],
    img : json['img'],
    prices : json['prices']
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nameItem'] = this.nameItem;
    data['img'] = this.img;
    data['prices'] = this.prices;
    return data;
  }
}