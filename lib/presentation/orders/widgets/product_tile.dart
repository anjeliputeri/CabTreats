import 'package:flutter/material.dart';
import 'package:flutter_onlineshop_app/core/constants/variables.dart';
import 'package:flutter_onlineshop_app/data/models/requests/courier_cost_request_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../../home/models/product_model.dart';

class ProductTile extends StatelessWidget {
  final OrderItem data;
  const ProductTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.stroke),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: Image.network(
              data!.image!,
              width: 68.0,
              height: 68.0,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 68.0,
                      height: 68.0,
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
          ),
          const SpaceWidth(14.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data!.name!,
                style: const TextStyle(
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(
                    '${data!.price?.currencyFormatRp} x ${data.quantity} = ${(data!.price! * data.quantity!).currencyFormatRp}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
