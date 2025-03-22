import 'package:flutter/material.dart';

class MemoChangeDialog extends StatefulWidget {
  final String currentContent;
  final int memoId;
  final Function(String updatedContent) onComplete;
  final VoidCallback onCancel;

  const MemoChangeDialog({
    required this.currentContent,
    required this.memoId,
    required this.onCancel,
    required this.onComplete,
  });

  @override
  _MemoChangeDialogState createState() => _MemoChangeDialogState();
}

class _MemoChangeDialogState extends State<MemoChangeDialog> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.currentContent;
  }

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
          height: MediaQuery.of(context).size.height - 400,
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
                    '메모 수정하기',
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
                  Icon(Icons.maps_ugc_outlined, size: 24, color: Color(0xFF00ADE6)),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GC병원',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF515151),
                        ),
                      ),
                      Text(
                        '서울 구로구',
                        style: TextStyle(fontSize: 12, color: Color(0xFFACACAC)),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                padding: EdgeInsets.all(27),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFACACAC)),
                ),
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: '기록하고 싶은 영업 내용을 수정하세요.',
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
}
