import 'package:flutter/material.dart';

class CommentChangeDialog extends StatelessWidget {
  final int commentId;
  final String content;
  final Function(String) onComplete;
  final VoidCallback onCancel;

  CommentChangeDialog({
    required this.commentId,
    required this.content,
    required this.onCancel,
    required this.onComplete,
  });

  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _contentController.text = content;

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
                    '댓글 수정하기',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFADADAD),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: onCancel,
                  ),
                ],
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
                    hintText: '댓글을 수정하세요',
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
                        onPressed: onCancel,
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
                          onComplete(_contentController.text);
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
