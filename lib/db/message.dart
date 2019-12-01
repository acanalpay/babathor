class Message {
  final String id;
  final String content;
  final String date;
  final String from;

  Message(this.id,this.content, this.date, this.from);

  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        date = json['date'],
        from = json['from'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'date' : date,
        'from' : from
      };
}
