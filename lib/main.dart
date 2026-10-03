import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';
import 'providers/audio_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: const WynkCloneApp(),
    ),
  );
}

class WynkCloneApp extends StatefulWidget {
  const WynkCloneApp({super.key});

  @override
  State<WynkCloneApp> createState() => _WynkCloneAppState();
}

class _WynkCloneAppState extends State<WynkCloneApp> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wynk Music Clone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return Focus(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (node, event) {
            final primaryContext = FocusManager.instance.primaryFocus?.context;
            bool isTextField = false;
            if (primaryContext != null) {
              isTextField = primaryContext.widget is EditableText ||
                  primaryContext.widget is TextField ||
                  primaryContext.findAncestorWidgetOfExactType<EditableText>() != null;
            }

            if (!isTextField && event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
              context.read<AudioProvider>().togglePlayPause();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: child!,
        );
      },
      home: const MainScreen(),
    );
  }
}
