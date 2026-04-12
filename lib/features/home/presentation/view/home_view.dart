import 'package:chatapp/features/chat/data/repositories/message_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/connection_info.dart';
import '../../../../core/utils/di.dart';
import '../widgets/custom_add_contact_bottom_sheet.dart';
import '../widgets/custom_chat_item.dart';
import '../widgets/custom_navigation_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    getIt<ConnectionInfo>().listenToConnectionChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          spacing: 5,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(7),
                image: const DecorationImage(
                  image: AssetImage('assets/images/chat_icon.png'),
                ),
              ),
            ),
            Text(
              'Messages',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('assets/icons/search.svg'),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.list)),
        ],
        scrolledUnderElevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            1,
            (index) => CustomChatItem(
              ontap: () {
                context.push('/chat');
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CustomAddContactBottomSheet.show(context);
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
