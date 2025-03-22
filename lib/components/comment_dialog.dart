import 'package:flutter/material.dart';

class CommentDialog extends StatefulWidget {
  final String memoUser;
  final String memoTime;
  final String memoContent;
  final int memoId;
  final Function(String content) onComplete;
  final VoidCallback onCancel;

  const CommentDialog({
    required this.memoUser,
    required this.memoTime,
    required this.memoContent,
    required this.memoId,
    required this.onCancel,
    required this.onComplete,
  });

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width - 80,
          height: MediaQuery.of(context).size.height - 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '답글 작성하기',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFADADAD),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: widget.onCancel,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.local_hospital, size: 24, color: Colors.grey),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.memoUser,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF515151),
                        ),
                      ),
                      Text(
                        _getTimeAgo(widget.memoTime),
                        style: TextStyle(fontSize: 12, color: Color(0xFFACACAC)),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.memoContent,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 150,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFACACAC)),
                ),
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: '답글 내용을 작성해주세요.\n거래처 관련자에 대한 내밀 또는 개인 정보 등 입력 시 명예훼손 문제가 발생될 수 있으니 꼭! 유의하세요!',
                    hintStyle: TextStyle(fontSize: 14, color: Color(0xFFACACAC)),
                    border: InputBorder.none,
                  ),
                  maxLines: 4,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      margin: EdgeInsets.only(right: 5),
                      child: TextButton(
                        onPressed: widget.onCancel,
                        child: Text(
                          '취소',
                          style: TextStyle(fontSize: 14, color: Color(0xFFACACAC)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(0xFF00ADE6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      margin: EdgeInsets.only(left: 5),
                      child: TextButton(
                        onPressed: () {
                          widget.onComplete(_contentController.text);
                        },
                        child: Text(
                          '완료',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  String _getTimeAgo(String timestamp) {
    final now = DateTime.now();
    final time = DateTime.parse(timestamp);
    final difference = now.difference(time);
    final formattedDate = '${time.year}.${time.month.toString().padLeft(2, '0')}.${time.day.toString().padLeft(2, '0')}';

    if (difference.inMinutes < 1) {
      return '방금 ($formattedDate)';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전 ($formattedDate)';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전 ($formattedDate)';
    } else {
      return '${difference.inDays}일 전 ($formattedDate)';
    }
  }
}
