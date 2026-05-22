import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';

class EditorWebviewPage extends StatefulWidget {
  final Note? note;
  final Function(String title, String content)? onSave;

  const EditorWebviewPage({super.key, this.note, this.onSave});

  @override
  State<EditorWebviewPage> createState() => _EditorWebviewPageState();
}

class _EditorWebviewPageState extends State<EditorWebviewPage> {
  late final WebViewController _controller;
  bool _isLoaded = false;
  String _title = '';
  String _content = '';

  @override
  void initState() {
    super.initState();
    _title = widget.note?.title ?? '';
    _content = widget.note?.content ?? '';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: _onJavaScriptMessage,
      )
      ..loadFlutterAsset('assets/web/index.html');
  }

  void _onJavaScriptMessage(JavaScriptMessage message) {
    final data = message.message;

    if (data.startsWith('content:')) {
      setState(() {
        _content = data.substring(8);
      });
    } else if (data.startsWith('title:')) {
      setState(() {
        _title = data.substring(6);
      });
    } else if (data == 'ready') {
      _isLoaded = true;
      _sendNoteToWebView();
    }
  }

  void _sendNoteToWebView() {
    final escapedTitle = _title.replaceAll("'", "\\'").replaceAll('\n', '\\n');
    final escapedContent = _content.replaceAll("'", "\\'").replaceAll('\n', '\\n');
    _controller.runJavaScript(
      "editor.setContent('$escapedTitle', '$escapedContent');",
    );
  }

  void _saveNote() {
    if (_title.trim().isEmpty && _content.trim().isEmpty) return;
    widget.onSave?.call(_title, _content);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : widget.note!.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
            tooltip: 'Save',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: _title),
                  onChanged: (val) => _title = val,
                ),
              ),
              Expanded(
                child: _isLoaded
                    ? const SizedBox.shrink()
                    : const Center(child: CircularProgressIndicator()),
              ),
              Expanded(
                flex: 8,
                child: WebViewWidget(controller: _controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
