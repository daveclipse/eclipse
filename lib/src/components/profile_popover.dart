import 'package:flutter/material.dart';

class ProfilePopover extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;
  final Function(Map<String, Object>) onAddTile; // Callback to notify parent

  const ProfilePopover({
    required this.isVisible,
    required this.onClose,
    required this.onAddTile,
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePopoverState createState() => _ProfilePopoverState();
}

class _ProfilePopoverState extends State<ProfilePopover>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  void addTile(String title, Icon icon) {
    widget.onAddTile({'description': title, 'icon': icon});
  }

  @override
  void didUpdateWidget(ProfilePopover oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isVisible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.isVisible)
          FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: widget.onClose,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        SlideTransition(
          position: _slideAnimation,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add To Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            leading: Icon(Icons.airplane_ticket_outlined),
                            title: Text('Traveling'),
                            onTap: () => addTile('Traveling', Icon(Icons.airplane_ticket_outlined)),
                          ),
                          ListTile(
                            leading: Icon(Icons.music_note),
                            title: Text('Music'),
                            onTap: () => addTile('Music', Icon(Icons.music_note)),

                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt_outlined),
                            title: Text('Photography'),
                            onTap: () => addTile('Photography', Icon(Icons.camera_alt_outlined)),
                          ),
                          ListTile(
                            leading: Icon(Icons.restaurant),
                            title: Text('Cooking'),
                            onTap: () => addTile('Cooking', Icon(Icons.restaurant)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}