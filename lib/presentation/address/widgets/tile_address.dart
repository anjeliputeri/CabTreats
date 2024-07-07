import 'package:flutter/material.dart';

import '../../../core/core.dart';

class TileAddress extends StatefulWidget {
  final Map<String, dynamic> addressData;
  final bool isPrimary;

  const TileAddress({
    Key? key,
    required this.addressData,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  _TileAddressState createState() => _TileAddressState();
}

class _TileAddressState extends State<TileAddress> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isPrimary && widget.addressData['primaryAddress'] == true;
  }

  @override
  void didUpdateWidget(covariant TileAddress oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isSelected = widget.isPrimary && widget.addressData['primaryAddress'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.stroke),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          boxShadow: _isSelected
              ? [
            BoxShadow(
              color: AppColors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
              spreadRadius: 1,
            ),
          ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '${widget.addressData['name']} | ${widget.addressData['phoneNumber']}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 4.0),
            GestureDetector(
              onTap: () {
                print('Row tapped!');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.addressData['address'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSelected = !_isSelected;
                        });
                        print('Radio button tapped! Selected: $_isSelected');
                      },
                      child: Icon(
                        _isSelected
                            ? Icons.radio_button_checked
                            : Icons.circle_outlined,
                        color: _isSelected ? AppColors.primary : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            if (_isSelected) ...[
              const Divider(color: AppColors.primary),
              Center(
                child: TextButton(
                  onPressed: () {
                    print('Edit button tapped!');
                  },
                  child: const Text('Edit'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
