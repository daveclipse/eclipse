import 'package:flutter/material.dart';

class DraggableGrid extends StatefulWidget {
  final List<Map<String, Object>> squares;

  const DraggableGrid({required this.squares, Key? key}) : super(key: key);

  @override
  _DraggableGridState createState() => _DraggableGridState();
}

class _DraggableGridState extends State<DraggableGrid> {
  late List<Map<String, dynamic>> squares;

  @override
  void initState() {
    super.initState();
    squares = widget.squares;
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = squares.removeAt(oldIndex);
      squares.insert(newIndex, item);
    });
  }

  void _editSquare(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        final square = squares[index];
        final TextEditingController descriptionController =
            TextEditingController(text: square['description'] as String);

        return AlertDialog(
          title: const Text('Edit Square'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  squares[index]['description'] = descriptionController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: squares.length,
        itemBuilder: (context, index) {
          final square = squares[index];
          return GestureDetector(
            onTap: () => _editSquare(context, index),
            child: LongPressDraggable<Map<String, dynamic>>(
              data: square,
              feedback: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3 - 24,
                  height: MediaQuery.of(context).size.width / 3 - 24,
                  child: _buildSquare(square, Colors.white),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: _buildSquare(square, Colors.white),
              ),
              child: DragTarget<Map<String, dynamic>>(
                onAcceptWithDetails: (data) {
                  final oldIndex = squares.indexOf(data.data);
                  onReorder(oldIndex, index);
                },
                builder: (context, candidateData, rejectedData) {
                  return _buildSquare(square, Colors.white);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSquare(Map<String, dynamic> square, Color backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          square['icon'] as Icon,
          const SizedBox(height: 8),
          Text(
            square['description'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}