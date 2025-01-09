import 'package:flutter/material.dart';

class VitalsCard extends StatefulWidget {
  final String name;
  final String email;
  final int age;
  final double width;
  final double height;

  const VitalsCard({
    required this.name,
    required this.email,
    required this.age,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  _VitalsCardState createState() => _VitalsCardState();
}

class _VitalsCardState extends State<VitalsCard> with SingleTickerProviderStateMixin {
  late OverlayEntry _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  String _name = '';
  String _email = '';
  int _age = 0;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _email = widget.email;
    _age = widget.age;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showEditForm(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Center(
              child: Material(
                borderRadius: BorderRadius.circular(16),
                elevation: 8,
                color: Colors.white,
                child: Container(
                  width: widget.width * 0.8,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Edit Vitals',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Name'),
                        controller: TextEditingController(text: _name),
                        onChanged: (value) => _name = value,
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        controller: TextEditingController(text: _email),
                        onChanged: (value) => _email = value,
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Age'),
                        controller: TextEditingController(text: _age.toString()),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _age = int.tryParse(value) ?? _age;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _animationController.reverse().then((value) {
                                _overlayEntry.remove();
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {});
                              _animationController.reverse().then((value) {
                                _overlayEntry.remove();
                              });
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEditForm(context),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(_email),
                Text('Age: $_age'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}