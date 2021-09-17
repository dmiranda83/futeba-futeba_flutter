class Week {
  late final String title;
  late bool checked;

  Week({
    required this.title,
    this.checked = false,
  });

  Map<String, dynamic> toJson() {
    return {"name": this.title};
  }
}
