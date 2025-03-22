class Memo {
  final int? id;
  final String user;
  final String content;
  final String timestamp;

  Memo({
    this.id,
    required this.user,
    required this.content,
    required this.timestamp,
  });

  // Map으로 변환 (SQLite에 저장할 수 있도록)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'content': content,
      'timestamp': timestamp,
    };
  }

  // Map에서 객체로 변환 (SQLite에서 데이터를 읽을 때 사용)
  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id'],
      user: map['user'],
      content: map['content'],
      timestamp: map['timestamp'],
    );
  }
}
