import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class CustomChatItem extends StatelessWidget {
  const CustomChatItem({super.key, this.ontap});
  final void Function()? ontap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: ontap,
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/me.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 3,
                  child: Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hammoud Taha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '10:45 AM',
                        style: TextStyle(
                          color: Color(0xff9196A1),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 5,
                    children: [
                      Flexible(
                        child: Text(
                          'Are we still meetingmeeting at 2 PM?',
                          style: TextStyle(
                            color: Color(0xff9196A1),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 10,
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
