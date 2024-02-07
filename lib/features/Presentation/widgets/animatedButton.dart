// import 'package:flutter/material.dart';


// class LoadingToDoneTransition extends StatefulWidget {
//   final Widget loadingWidget;
//   final Widget finalWidget;
//   final LoadingToDoneTransitionController controller;
//   final Duration? duration;
//   final Widget initial;

//   const LoadingToDoneTransition(
//       {Key? key,
//       this.duration,
//       required this.loadingWidget,
//       required this.finalWidget,
//       required this.controller,
//       required this.initial})
//       : super(key: key);

//   @override
//   State<LoadingToDoneTransition> createState() => _LoadingToDoneTransitionState();
// }

// class _LoadingToDoneTransitionState extends State<LoadingToDoneTransition> {
//   @override
//   void initState() {
//     super.initState();
//     widget.controller.state = LTDState.initial;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//         animation: widget.controller,
//         builder: (_, value) {
//           if (widget.controller.state == LTDState.initial) {
//             return widget.initial;
//           }
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: ColorAssets.border),
//               borderRadius: BorderRadius.circular(6.r),
//             ),
//             alignment: Alignment.center,
//             child: Builder(
//               builder: (context) {
//                 if (widget.controller.state == LTDState.loading) {
//                   return widget.loadingWidget;
//                 } else if (widget.controller.state == LTDState.transition) {
//                   return TweenAnimationBuilder(
//                       curve: Curves.bounceInOut,
//                       onEnd: () {
//                         widget.controller.done();
//                       },
//                       tween: Tween<double>(begin: 0, end: 1),
//                       duration: widget.duration ?? const Duration(milliseconds: 600),
//                       builder: (context, double value, child) {
//                         return Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Transform.scale(
//                               scale: value * value,
//                               child: widget.finalWidget,
//                             ),
//                             Transform.scale(
//                               scale: 1 - value,
//                               child: widget.loadingWidget,
//                             )
//                           ],
//                         );
//                       });
//                 } else if (widget.controller.state == LTDState.done) {
//                   return widget.finalWidget;
//                 }
//                 return const Offstage();
//               },
//             ),
//           );
//         });
//   }
// }

// enum LTDState { initial, loading, transition, done }

// class LoadingToDoneTransitionController extends ChangeNotifier {
//   LTDState state = LTDState.loading;

//   LoadingToDoneTransitionController();

//   /// If Duration is specifies it will move state back to initial in given duration
//   Future<void> animateToDone({Duration? duration}) async {
//     state = LTDState.transition;
//     notifyListeners();
//     if (duration != null) {
//       await Future.delayed(duration, initial);
//     } else {
//       await Future.delayed(const Duration(milliseconds: 600));
//     }
//   }

//   void initial() {
//     state = LTDState.initial;
//     notifyListeners();
//   }

//   void done() {
//     state = LTDState.done;
//     notifyListeners();
//   }

//   void loading() {
//     state = LTDState.loading;
//     notifyListeners();
//   }
// }

// import 'package:flutter/material.dart';

// import '../../../../common/constant/color_assets.dart';
// import 'app_loading_indicator.dart';
// import 'loading_to_done_transition.dart';

// class ButtonAnimatedLoadingWidget extends StatelessWidget {
//   final LoadingToDoneTransitionController controller;
//   final double? height;
//   final double? width;
//   final Widget button;
//   final bool border;

//   const ButtonAnimatedLoadingWidget(
//       {Key? key, this.border = true, required this.controller, this.height, this.width, required this.button})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       width: width,
//       child: Align(
//         alignment: Alignment.center,
//         child: LoadingToDoneTransition(
//             initial: button,
//             loadingWidget: const SizedBox(
//               width: 40,
//               height: 20,
//               child: AppLoadingIndicator(),
//             ),
//             finalWidget: const Icon(
//               Icons.check_circle_outline_rounded,
//               color: ColorAssets.green,
//               size: 30,
//             ),
//             controller: controller),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// import '../../../../common/constant/color_assets.dart';
// import 'app_loading_indicator.dart';
// import 'loading_to_done_transition.dart';

// class ButtonAnimatedLoadingWidget extends StatelessWidget {
//   final LoadingToDoneTransitionController controller;
//   final double? height;
//   final double? width;
//   final Widget button;
//   final bool border;

//   const ButtonAnimatedLoadingWidget(
//       {Key? key, this.border = true, required this.controller, this.height, this.width, required this.button})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       width: width,
//       child: Align(
//         alignment: Alignment.center,
//         child: LoadingToDoneTransition(
//             initial: button,
//             loadingWidget: const SizedBox(
//               width: 40,
//               height: 20,
//               child: AppLoadingIndicator(),
//             ),
//             finalWidget: const Icon(
//               Icons.check_circle_outline_rounded,
//               color: ColorAssets.green,
//               size: 30,
//             ),
//             controller: controller),
//       ),
//     );
//   }
// }



// class AppLoadingIndicator extends StatelessWidget {
//   const AppLoadingIndicator({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const LoadingIndicator(
//       indicatorType: Indicator.ballBeat,
//       colors: [
//         ColorAssets.salonLogoColor2,
//         ColorAssets.salonLogoColor3,
//         ColorAssets.salonLogoColor4,
//       ],
//     );
//   }
// }


