class Tip {
  Tip({
    this.text,
    this.textEn,
  });

  String text;
  String textEn;

  factory Tip.fromJson(Map<String, dynamic> json) => Tip(
        text: json["text"],
        textEn: json["text_en"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "text_en": textEn,
      };
}
