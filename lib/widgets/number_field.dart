import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberField extends StatefulWidget {
  final int qty;
  final Function changeQty;

  const NumberField({
    super.key,
    required this.qty,
    required this.changeQty
  });

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  final TextEditingController _controller = TextEditingController();
  int qty = 1;

  void _handleControllerChange() {
    final text = _controller.text;

    if (text.isEmpty) {
      _changeQty(1, isController: true);
      return;
    }

    final value = int.parse(text);

    _changeQty(value, isController: true);
  }

  void _changeQty(int newQty, {bool isController = false}) {
    if (newQty < 1) return;

    widget.changeQty(newQty);
    setState(() {
      qty = newQty;

      if (!isController) _controller.text = newQty.toString();
    });
  }

  @override
  void initState() {
    super.initState();

    _controller.text = widget.qty.toString();
    _controller.addListener(_handleControllerChange);
    qty = widget.qty;
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)),
      minimumSize: const Size(32, 32)
    );

    return Row(
      children: [
        ElevatedButton(onPressed: () => _changeQty(qty + 1), style: buttonStyle, child: const Icon(Icons.add, size: 16,),),
        const SizedBox(width: 8),
        SizedBox(
          width: 64,
          child: TextField(
            keyboardType: const TextInputType.numberWithOptions(
              decimal: false,
              signed: false
            ),
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
                hintText: 'Qty'
            ),
            controller: _controller,
          )
        ),
        const SizedBox(width: 8,),
        ElevatedButton(onPressed: qty == 1 ? null : () => _changeQty(qty - 1), style: buttonStyle, child: const Icon(Icons.remove, size: 16,))
      ],
    );
  }
}