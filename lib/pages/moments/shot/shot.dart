import 'dart:io';
import 'package:chat_app/model/shotModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Shot extends StatelessWidget {
  const Shot({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<ShotModel>('shots').listenable(),
      builder: (context, Box<ShotModel> box, _) {
        if (box.isEmpty) {
          return const Center(child: Text("No shots available"));
        }

        List<ShotModel> shots = box.values.toList();

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: shots.length,
          itemBuilder: (context, index) {
            return _buildShotItem(context, shots[index]);
          },
        );
      },
    );
  }

  // 构建每个 Shot 项目
  Widget _buildShotItem(BuildContext context, ShotModel shot) {
    return GestureDetector(
      onTap: () => _showImageDialog(context, shot.imagePath),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FutureBuilder<ImageProvider>(
                future: _loadImage(shot.imagePath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 150,
                      height: 150,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    // 出现错误时显示默认图片
                    return Image.asset(
                      'images/avatar2.jpg', // 默认图片路径
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Image(
                      image: snapshot.data!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
            ),
            Positioned(
              top: 8,
              left: 2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 23,
                  backgroundImage: AssetImage(shot.avatarPath),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 加载图片函数
  Future<ImageProvider> _loadImage(String imagePath) async {
    // 检查文件是否存在于本地，如果不存在则从 assets 加载
    if (await File(imagePath).exists()) {
      return FileImage(File(imagePath));
    } else {
      return AssetImage(imagePath); // 如果找不到文件则加载 assets 中的图片
    }
  }

  // 显示图片弹出框
  void _showImageDialog(BuildContext context, String imagePath) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<ImageProvider>(
          future: _loadImage(imagePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return CupertinoAlertDialog(
                content: Image.asset(
                  'images/avatar2.jpg', // 默认图片路径
                  fit: BoxFit.contain,
                ),
              );
            } else {
              return CupertinoAlertDialog(
                content: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(
                      image: snapshot.data!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
