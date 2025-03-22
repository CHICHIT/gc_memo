import 'package:flutter/material.dart';

class MemoDialog extends StatefulWidget {
  final Function(String content) onComplete;
  final VoidCallback onCancel;

  const MemoDialog({
    required this.onCancel,
    required this.onComplete,
  });

  @override
  _MemoDialogState createState() => _MemoDialogState();
}

class _MemoDialogState extends State<MemoDialog> {
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
          height: MediaQuery.of(context).size.height - 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 상단 제목과 닫기 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '메모 작성하기',
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
              // 병원명, 주소
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
              // 입력창
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
                    hintText: '기록하고 싶은 영업 내용을 글로 남겨보세요. 거래처 관련자에 대한 내밀 또는 개인 정보 등 입력 시 명예훼손 문제가 발생될 수 있으니 꼭! 유의하세요!',
                    hintStyle: TextStyle(fontSize: 14, color: Color(0xFFACACAC)),
                    border: InputBorder.none,
                  ),
                  maxLines: 4,
                ),
              ),
              SizedBox(height: 10),
              // 취소 & 완료 버튼
              Row(
                children: [
                  // 취소 버튼
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
                  // 완료 버튼
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
