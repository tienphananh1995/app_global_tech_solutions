class Event {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] ?? json;

    // Xử lý logic: Nếu description là List (mảng), ta gộp các phần tử lại thành 1 chuỗi
    String rawDescription = "";
    var descData = attributes['description'];

    if (descData is List) {
      // Strapi Rich Text thường trả về mảng các block, mỗi block có mảng children
      try {
        rawDescription = descData
            .map((block) => (block['children'] as List)
            .map((child) => child['text'])
            .join(""))
            .join("\n");
      } catch (e) {
        rawDescription = "Lỗi định dạng mô tả";
      }
    } else {
      rawDescription = descData?.toString() ?? 'Không có mô tả';
    }

    String? imgUrl;
    try {
      // Cấu trúc thường là attributes -> image -> data -> attributes -> url
      var imageData = attributes['image']?['data'];
      if (imageData != null) {
        imgUrl = imageData['attributes']?['url'] ?? imageData['url'];
      }
    } catch (e) {
      imgUrl = null;
    }

    return Event(
      id: json['id'] ?? 0,
      title: attributes['title']?.toString() ?? 'Không có tiêu đề',
      description: rawDescription,
      imageUrl: imgUrl,
    );
  }
}