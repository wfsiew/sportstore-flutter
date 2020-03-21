class PagingInfo {
  int currentPage;
  int itemsPerPage;
  int totalItems;

  PagingInfo({
    this.currentPage,
    this.itemsPerPage,
    this.totalItems
  });

  factory PagingInfo.fromJson(Map<String, dynamic> json) {
    return PagingInfo(
      currentPage: json['currentPage'],
      itemsPerPage: json['itemsPerPage'],
      totalItems: json['totalItems']
    );
  }

  Map<String, dynamic> toJson() => {
    'currentPage': currentPage,
    'itemsPerPage': itemsPerPage,
    'totalItems': totalItems
  };
}