import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.016),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.0014, vertical: height * 0.0016),
      // height: height * 0.088,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(32, 79, 200, 0.07),
              offset: Offset(0, 6),
              blurRadius: 15,
            ),
          ]),
      child: ListTile(
        leading: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Container(
            // height: height * 0.054,

            padding: EdgeInsets.only(
              left: width * 0.008,
              right: width * 0.022,
              top: height * 0.018,
              bottom: height * 0.018,
            ),
            decoration: BoxDecoration(
                color: const Color(0xffCDEFFF),
                borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: 40,
              height: 30,
              color: Colors.white,
            ),
          ),
        ),
        title: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Container(
            width: 30,
            height: 10,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4)),
            margin: EdgeInsets.only(right: width * 0.24),
          ),
        ),
        subtitle: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Container(
            width: double.infinity,
            height: 10.0,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4)),
            margin: EdgeInsets.only(right: width * 0.1),
          ),
        ),
        trailing: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Container(
            width: 80,
            height: 16,
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28)),
          ),
        ),
      ),
    );
  }
}
