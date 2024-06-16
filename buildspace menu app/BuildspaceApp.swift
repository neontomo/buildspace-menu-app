import SwiftUI

@main
struct Buildspace: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  var body: some Scene {
    Settings {
      EmptyView()
    }
  }

}
func timeUntil() -> String {
  // launch date is July 27, 2024, PDT timezone
  let launchDate = DateComponents(
    calendar: .current,
    timeZone: TimeZone(abbreviation: "PDT"),
    year: 2024,
    month: 7,
    day: 27,
    hour: 0,
    minute: 0,
    second: 0)

  let launch = Calendar.current.date(from: launchDate)!
  let days = Calendar.current.dateComponents([.day], from: Date(), to: launch).day!
  return "\(days)d left"
}

class AppDelegate: NSObject, NSApplicationDelegate {
  @AppStorage("showTimerInMenuBar") var showTimerInMenuBar = true
  static private(set) var instance: AppDelegate!
  lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  let menu = ApplicationMenu()
  var timer: Timer?

  func applicationDidFinishLaunching(_ notification: Notification) {
    AppDelegate.instance = self
    statusBarItem.button?.image = NSImage(named: NSImage.Name("CWC"))
    statusBarItem.button?.imagePosition = .imageRight
    if showTimerInMenuBar {
      statusBarItem.button?.title = timeUntil()
    }
    statusBarItem.menu = menu.createMenu()

    timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
      // every minute, update the status bar item
      DispatchQueue.main.async {
        if self.showTimerInMenuBar {
          self.statusBarItem.button?.title = timeUntil()
        } else {
          self.statusBarItem.button?.title = ""
        }
      }
    }
  }

  func applicationWillTerminate(_ notification: Notification) {
    timer?.invalidate()
  }

}
