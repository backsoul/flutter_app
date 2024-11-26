import 'package:flutter/material.dart';

class GithubForm extends StatelessWidget {
  final Function(String) onSearch;
  final VoidCallback onReset; // Callback para reiniciar el estado
  final bool show;
  final TextEditingController _controller = TextEditingController();

  GithubForm({
    super.key,
    required this.onSearch,
    required this.onReset,
    required this.show,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!show) ...[
          const Text("Enter a GitHub username"),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Username",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                onSearch(_controller.text);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a username")),
                );
              }
            },
            child: const Text("Search user"),
          ),
        ] else ...[
          ElevatedButton(
            onPressed:
                onReset, // Llama al método proporcionado por el padre para reiniciar el estado
            child: const Text("Search again"),
          ),
        ],
      ],
    );
  }
}
