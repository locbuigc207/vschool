import 'package:flutter/material.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/gen/colors.gen.dart';

class BasePage extends StatelessWidget {
  final Color backgroundColor;
  final String? title;
  final Widget? leading;
  final List<Widget>? trailing;
  final Widget child;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;
  final bool hasBack;

  const BasePage({
    Key? key,
    this.title,
    this.leading,
    this.trailing,
    required this.child,
    this.bottomNavigationBar,
    this.backgroundColor = ColorName.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.hasBack = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: title != null
          ? AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: hasBack,
              iconTheme: const IconThemeData(
                color: Colors.white, //change your color here
              ),
              centerTitle: true,
              title: FadeAnimation(
                delay: 0.5,
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              leading: leading,
              actions: trailing,
              backgroundColor: Colors.transparent,
            )
          : null,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}
