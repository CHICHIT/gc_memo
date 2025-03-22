import 'package:flutter/material.dart';
import '../components/memo_dialog.dart';
import '../components/comment_dialog.dart';
import '../components/comment_change_dialog.dart';
import '../components/memo_change_dialog.dart';
import '../db/app_database.dart';
import '../db/memo.dart';

import '../db/comment.dart';

class MemoScreen extends StatefulWidget {
  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<Memo>> _memoList;
  late Future<List<Comment>> _commentsList;  // 댓글 목록 초기화
  bool _isMemoTab = true; // '메모' 탭이 선택된 상태를 추적

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(() {
      setState(() {
        _isMemoTab = _tabController?.index == 0;
      });
    });

    _memoList = DatabaseHelper.instance.getMemos();
  }
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _addMemo(String content) async {
    final newMemo = Memo(
      user: '송파지점',
      content: content,
      timestamp: DateTime.now().toString(),
    );
    await DatabaseHelper.instance.insertMemo(newMemo);
    setState(() {
      _memoList = DatabaseHelper.instance.getMemos();
    });
  }

  void _addComment(String content, int memoId) async {
    final comment = Comment(
      content: content,
      memoId: memoId,
      user: '송파지점',
      timestamp: DateTime.now().toString(),
    );

    await DatabaseHelper.instance.insertComment(comment);
    setState(() {
      _commentsList = DatabaseHelper.instance.getComments(memoId);
    });
  }

  void _updateMemo(int memoId, String updatedContent) async {
    final memo = Memo(
      id: memoId,
      content: updatedContent,
      user: '송파지점',
      timestamp: DateTime.now().toString(),
    );
    await DatabaseHelper.instance.updateMemo(memo);
    setState(() {
      _memoList = DatabaseHelper.instance.getMemos();
    });
  }

  void _updateComment(int commentId, String updatedContent,int memoId) async {
    final comment = Comment(
      id: commentId,
      content: updatedContent,
      memoId: memoId,
      user: '송파지점',
      timestamp: DateTime.now().toString(),
    );

    await DatabaseHelper.instance.updateComment(comment);
    setState(() {
      _commentsList = DatabaseHelper.instance.getComments(comment.memoId);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SizedBox.shrink(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 21, vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.maps_ugc_outlined, size: 27, color: Color(0xFF00ADE6)),
                        SizedBox(width: 10),
                        Text(
                          'GC병원',
                          style: TextStyle(
                            color: Color(0xFF515151),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(width: 30),
                        Text(
                          '서울 구로구',
                          style: TextStyle(
                            color: Color(0xFFACACAC),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      '메모',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      '일정',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF002B4B),
                      width: 3.0,
                    ),
                  ),
                ),
                labelColor: Color(0xFF002B4B),
                unselectedLabelColor: Color(0xFFACACAC),
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          height: 52,
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 6),
                            child: Text(
                              '거래처 관련자에 대한 내밀 또는 개인 정보 등 명예훼손\n문제가 발생될 수 있으니 꼭! 유의하여 작성해 주세요!',
                              style: TextStyle(
                                color: Color(0xFF868686),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8, left: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FutureBuilder<List<Memo>>(
                              future: _memoList,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Center(child: Text('메모가 없습니다.'));
                                }

                                final memos = snapshot.data!;
                                final _memoCount = memos.length;

                                return Text(
                                  '총 $_memoCount개',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF868686),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        FutureBuilder<List<Memo>>(
                          future: _memoList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              debugPrint("🔥 오류 발생: ${snapshot.error}");
                              return Center(child: Text("오류 발생: ${snapshot.error}"));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(child: Text('메모가 없습니다.'));
                            }

                            final memos = snapshot.data!;

                            return Expanded(
                              child: ListView.builder(
                                itemCount: memos.length,
                                itemBuilder: (context, index) {
                                  // 📌 메모를 최신순으로 정렬
                                  memos.sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

                                  final memo = memos[index];
                                  final timeAgo = _getTimeAgo(memo.timestamp);

                                  return FutureBuilder<List<Comment>>(
                                    future: DatabaseHelper.instance.getComments(memo.id!),
                                    builder: (context, commentSnapshot) {
                                      final comments = commentSnapshot.data ?? [];

                                      // 📌 댓글을 최신순으로 정렬
                                      comments.sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildMemoItem(memo, timeAgo),
                                          ...comments.map((comment) => _buildCommentItem(comment)).toList(),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Center(child: Text('')),
                  ],
                ),
              ),
            ],
          ),

          if (_isMemoTab)
            Positioned(
              bottom: 40,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00ADE6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  fixedSize: Size(106, 40),
                  padding: EdgeInsets.only(left: 1),
                ),
                onPressed: () {
                  showMemoDialog(context);
                },
                child: Text(
                  '메모 작성하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showMemoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MemoDialog(
          onCancel: () {
            Navigator.pop(context);
          },
          onComplete: (content) {
            _addMemo(content);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void showCommentDialog(BuildContext context, String memoUser, String memoTime, String memoContent, int memoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CommentDialog(
          memoUser: memoUser,
          memoTime: memoTime,
          memoContent: memoContent,
          memoId: memoId,
          onCancel: () {
            Navigator.pop(context);
          },
          onComplete: (content) {
            _addComment(content,memoId);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void showMemoChangeDialog(BuildContext context, String currentContent, int memoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MemoChangeDialog(
          currentContent: currentContent,
          memoId: memoId,
          onCancel: () {
            Navigator.pop(context);
          },
          onComplete: (updatedContent) {
            _updateMemo(memoId, updatedContent);
            Navigator.pop(context);
          },
        );
      },
    );
  }


  void showCommentChangeDialog(BuildContext context, int commentId, String content,int memoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CommentChangeDialog(
          commentId: commentId,
          content: content,
          onCancel: () {
            Navigator.pop(context);
          },
          onComplete: (updatedContent) {
            _updateComment(commentId, updatedContent,memoId);
            Navigator.pop(context);
          },
        );
      },
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

  Widget _buildMemoItem(Memo memo, String timeAgo) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: Offset(0, -2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_hospital, size: 30, color: Colors.grey),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          memo.user,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF515151)),
                        ),
                        Expanded(child: SizedBox()),
                        TextButton(
                          onPressed: () {
                            showMemoChangeDialog(context,memo.content,memo.id!);
                          },
                          child: Text('수정', style: TextStyle(fontSize: 12, color: Color(0xFFACACAC))),
                        ),
                        Container(width: 1, height: 20, color: Color(0xFFACACAC)),
                        TextButton(
                          onPressed: () async {
                            await DatabaseHelper.instance.deleteMemo(memo.id!);
                            setState(() {
                              _memoList = DatabaseHelper.instance.getMemos();
                            });
                          },
                          child: Text('삭제', style: TextStyle(fontSize: 12, color: Color(0xFFACACAC))),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.zero, // 여백 제거
                      child: Text(timeAgo, style: TextStyle(color: Color(0xFFACACAC), fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(memo.content, style: TextStyle(fontSize: 16, color: Colors.black)),
          ),
          SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                showCommentDialog(context, memo.user, memo.timestamp, memo.content, memo.id!);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),  // 최소 크기 제한 해제
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('답글쓰기', style: TextStyle(fontSize: 12, color: Color(0xFFACACAC))),
            ),
          ),
        ],
      ),
    );
  }


Widget _buildCommentItem(Comment comment) {
  return Padding(
      padding: EdgeInsets.only(top: 4),
  child: Container(
  padding: EdgeInsets.all(10),
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(8),
  color: Colors.white,
  ),
        child: Row(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.14159),
              child: Icon(Icons.keyboard_return, size: 20, color: Colors.grey),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_hospital, size: 30, color: Colors.grey),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  comment.user,
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: ()  {
                                        showCommentChangeDialog(context,comment.id!,comment.content,comment.memoId);
                                      },
                                      child: Text('수정', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    ),
                                    Container(width: 1, height: 20, color: Colors.grey),
                                    TextButton(
                                      onPressed: () async {
                                        await DatabaseHelper.instance.deleteComment(comment.id!);
                                        setState(() {});
                                      },
                                      child: Text('삭제', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Text(_getTimeAgo(comment.timestamp), style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(comment.content, style: TextStyle(fontSize: 14, color: Colors.black87)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
