import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/pages/user_profile/profile_page.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar({
    super.key,
    required UserSession userSession,
  }) : _userSession = userSession;

  final UserSession _userSession;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorAssets.neomCream,
      automaticallyImplyLeading: false,
      leading: _userSession.userDetails?.imagepath != null
          ? GestureDetector(
            onTap: ()=> Navigator.pushNamed(context, ProfilePage.profilepage, arguments: UserDetails(
          email: _userSession.userDetails?.email ?? "",
          firstName: _userSession.userDetails?.firstName ?? "",
          imagepath: _userSession.userDetails?.imagepath ?? "",
          lastName: _userSession.userDetails?.lastName ?? "",
          number: _userSession.userDetails?.number ?? "",
        ),
      ),
            child: Container(
                margin: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            _userSession.userDetails!.imagepath ?? ""),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle),
              ),
          )
          : Container(
              margin: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: Colors.grey, shape: BoxShape.circle),
            ),
      title: Text(
        "Chat",
        style: GoogleFonts.roboto(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
            margin: EdgeInsets.only(right: 20),
            child: SvgPicture.asset("assets/icons/add_square.svg")),
      ],
    );
  }
}
