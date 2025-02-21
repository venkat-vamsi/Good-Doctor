// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';


// class ModelViewerPage extends StatefulWidget {
//   @override
//   _ModelViewerPageState createState() => _ModelViewerPageState();
// }

// class _ModelViewerPageState extends State<ModelViewerPage> {
//   String? modelPath;

//   Future<void> pick3DModel() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.any, 
//     );

//     if (result != null) {
//       String? filePath = result.files.single.path;

//       if (filePath != null && (filePath.endsWith('.glb') || filePath.endsWith('.gltf'))) {
//         setState(() {
//           modelPath = filePath;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Please select a valid .glb or .gltf file")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 24, 21, 34) ,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("3D Model Viewer"),
//         backgroundColor: Colors.black,
//       ),
//       body: Column(
//         children: [
          
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: pick3DModel,
//               child: Text("Upload 3D Model"),
//             ),
//           ),
          
//           Expanded(
//             child: modelPath != null
//                 ? ModelViewer(
//                     src: "file://$modelPath", 
//                     alt: "3D model",
//                     ar: true, 
//                     autoRotate: true,
//                     cameraControls: true,
//                     backgroundColor: Color.fromARGB(255, 24, 21, 34),
//                   )
//                 : Center(
//                     child: Text(
//                       "No model selected",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//           ), 
//         ],
//       ),
//       bottomNavigationBar: MyBottomNavBar(currentIndex: 2),
//     );
//   }
// }