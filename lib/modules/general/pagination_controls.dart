// widgets/pagination_controls.dart
import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final bool hasMore;
  final int limit;
  final Function() onPrevious;
  final Function() onNext;
  final Function(int) onChangeLimit;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.hasMore,
    required this.limit,
    required this.onPrevious,
    required this.onNext,
    required this.onChangeLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: currentPage > 1 ? onPrevious : null,
          ),
          Text('Página $currentPage'),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: hasMore ? onNext : null,
          ),
          DropdownButton<int>(
            value: limit,
            items: [5, 10, 20, 50].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value items'),
              );
            }).toList(),
            onChanged: (value) => onChangeLimit(value!),
          ),
        ],
      ),
    );
  }
}