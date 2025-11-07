class Ayah {
  final int number;
  final String text;
  final String audio;

  Ayah({required this.number, required this.text, required this.audio});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'],
      text: json['text'],
      audio: json['audio'],
    );
  }
}
