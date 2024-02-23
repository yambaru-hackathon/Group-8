//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

<<<<<<< HEAD
import firebase_core

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
=======
import cloud_firestore
import firebase_core

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FLTFirebaseFirestorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseFirestorePlugin"))
>>>>>>> d4da72a6fc394fdd44af7364289b529c0b9726d8
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
}
