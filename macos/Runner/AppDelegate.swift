import Cocoa
import FlutterMacOS
import flutter_chia_rust_utils

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    FlutterChiaRustUtilsPlugin.dummyMethodToEnforceBundling()
    return true
  }
}
