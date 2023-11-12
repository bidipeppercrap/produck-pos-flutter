import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  final Function nextPage;
  final Function prevPage;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.nextPage,
    required this.prevPage
  });

  ButtonStyle _paginationButtonStyle() {
    return ButtonStyle(
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
                child: ElevatedButton(onPressed: currentPage == 1 ? null : () => prevPage(), style: _paginationButtonStyle(), child: const Icon(Icons.arrow_back))
            ),
            const SizedBox(width: 8),
            Expanded(
                child: ElevatedButton(onPressed: currentPage == totalPages ? null : () => nextPage(), style: _paginationButtonStyle(), child: const Icon(Icons.arrow_forward))
            )
          ],
        )
    );
  }
}