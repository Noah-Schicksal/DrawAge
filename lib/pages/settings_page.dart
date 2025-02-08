import 'package:drawage/pages/draw_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações de Tamanho da Folha')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: widthController,
              decoration: InputDecoration(labelText: 'Largura (px)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Altura (px)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widthController.text.isNotEmpty &&
                    heightController.text.isNotEmpty) {
                  int width = int.parse(widthController.text);
                  int height = int.parse(heightController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DrawPage(
                        width: width,
                        height: height,
                      ),
                    ),
                  );
                }
              },
              child: Text('Ir para Desenho'),
            ),
          ],
        ),
      ),
    );
  }
}
