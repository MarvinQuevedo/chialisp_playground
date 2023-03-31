import Cocoa
import FlutterMacOS
import flutter_chia_rust_utils

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    
    FlutterChiaRustUtilsPlugin.dummyMethodToEnforceBundling()
 
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
