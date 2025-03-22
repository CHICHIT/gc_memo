class Comment {
  final int? id;
  final int memoId;
  final String user;
  final String content;
  final String timestamp;

  Comment({
    this.id,
    required this.memoId,
    required this.user,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memoId': memoId,
      'user': user,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      memoId: map['memoId'],
      user: map['user'],
      content: map['content'],
      timestamp: map['timestamp'],
    );
  }
}
