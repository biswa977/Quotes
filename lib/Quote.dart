class Quote {
  String quoteText;
  String quoteAuthor;
  Quote({this.quoteText, this.quoteAuthor});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quoteText: json['text'],
      quoteAuthor: json['author'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': quoteText,
      'author': quoteAuthor,
    };
  }

  Quote.fromMap(Map<String, dynamic> map) {
    quoteText = map['text'];
    quoteAuthor = map['author'];
  }
}
