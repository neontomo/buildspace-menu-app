import Foundation
import SwiftUI

class ApplicationMenu: NSObject, NSMenuDelegate {
  @AppStorage("customLink1") var customLink1 = ""
  @AppStorage("customLink2") var customLink2 = ""
  @AppStorage("customLink3") var customLink3 = ""
  @AppStorage("customLink4") var customLink4: String = ""
  @AppStorage("customLink5") var customLink5: String = ""

  var timer: Timer!

  let menu = NSMenu()
  var resourcesDropdown: NSMenu!
  var houseDropdown: NSMenu!
  var timerMenuItem: NSMenuItem!
  var houseMenuItem: NSMenuItem!
  var customLinksDropdown: NSMenu!

  let houses = ["💋 spectreseek", "🌀 alterok", "🌙 gaudmire", "🌿 erevald", "unset"]

  let links = [
    "built by Tomo Myrman": "https://github.com/neontomo"
  ]

  let linksDropDown = [
    "sage inbox": "https://sage.buildspace.so/inbox/",
    "buildspaceOS": "https://buildspace.so/home",
    "calendar": "https://lu.ma/s5-2024",
    "kickoff steps": "https://buildspace.so/s5/start",
    "faq": "https://buildspace.so/faq/",
  ]

  let emailsDropdown = [
    "team": "mailto:team@buildspace.so",
    "irl questions": "mailto:irl@@buildspace.so",
    "cringe complaints": "mailto:cringe@buildspace.so",
  ]

  let twitterDropdown = [
    "x@_buildspace": "https://twitter.com/_buildspace",
    "x@_nightsweekends": "https://twitter.com/_nightsweekends",
    "x@farzatv": "https://twitter.com/FarzaTV",
  ]

  let instagramDropdown = [
    "ig@_buildspace": "https://www.instagram.com/_buildspace",
    "ig@_nightsweekends": "https://www.instagram.com/_nightsweekends",
  ]

  let linkedinDropdown = [
    "li@buildspaceee": "https://www.linkedin.com/school/buildspacee"
  ]

  let youtubeDropdown = [
    "yt@_buildspace": "https://www.youtube.com/@_buildspace"
  ]
  @AppStorage("showTimerInMenuBar") var showTimerInMenuBar = true
  @AppStorage("house") var house = ""

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
    return "\(days)"
  }

  func createSeparator() -> NSMenuItem {
    return NSMenuItem.separator()
  }

  func createMenuItem(title: String, action: Selector?, key: String = "") -> NSMenuItem {
    let menuItem = NSMenuItem(
      title: title,
      action: action,
      keyEquivalent: key)
    menuItem.target = self
    return menuItem
  }

  func createDropdownMenu(items: [String], action: Selector) -> NSMenu {
    let dropdown = NSMenu()
    for item in items {
      if item == "unset" {
        dropdown.addItem(createSeparator())
      }

      let menuItem = createMenuItem(title: item, action: action)
      dropdown.addItem(menuItem)

    }
    return dropdown
  }

  func createMenu() -> NSMenu {
    let SplashView = SplashView()
    let topView = NSHostingController(rootView: SplashView)
    topView.view.frame.size = CGSize(width: 300, height: 300)

    /* image */
    let customMenuItem = NSMenuItem()
    customMenuItem.view = topView.view
    menu.addItem(customMenuItem)

    menu.addItem(createSeparator())

    /* timer */
    timerMenuItem = createMenuItem(title: "", action: #selector(updateCountdown))
    menu.addItem(timerMenuItem)

    menu.addItem(createSeparator())

    /* resources */

    menu.addItem(createMenuItem(title: "resources", action: nil))

    //---
    resourcesDropdown = createDropdownMenu(
      items: Array(linksDropDown.keys), action: #selector(openLink))

    let resourcesMenuItem = createMenuItem(title: "links", action: nil)
    resourcesMenuItem.submenu = resourcesDropdown
    menu.addItem(resourcesMenuItem)

    /* add custom links here, as dropdown */

    customLinksDropdown = NSMenu()

    let customLinksMenuItem = createMenuItem(title: "custom links", action: nil)
    customLinksMenuItem.submenu = customLinksDropdown
    menu.addItem(customLinksMenuItem)

    /* contact > emails/twitter/instagram/linkedin/youtube > links */

    let contactMenuItem = createMenuItem(title: "contact", action: nil)
    let contactDropdown = NSMenu()

    let dropdowns = [
      ("emails", emailsDropdown),
      ("twitter", twitterDropdown),
      ("instagram", instagramDropdown),
      ("linkedin", linkedinDropdown),
      ("youtube", youtubeDropdown),
    ]

    for (title, dropdown) in dropdowns {
      let menuItem = createMenuItem(title: title, action: nil)
      let dropdownMenu = createDropdownMenu(
        items: Array(dropdown.keys), action: #selector(openLink))
      menuItem.submenu = dropdownMenu
      contactDropdown.addItem(menuItem)
    }

    contactMenuItem.submenu = contactDropdown
    menu.addItem(contactMenuItem)

    menu.addItem(createSeparator())

    /* settings */

    menu.addItem(createMenuItem(title: "settings", action: nil))

    /* house */
    houseDropdown = createDropdownMenu(items: houses, action: #selector(setHouseValue))
    houseMenuItem = createMenuItem(title: "set house", action: nil)
    houseMenuItem.submenu = houseDropdown
    menu.addItem(houseMenuItem)

    /* show timer in menu bar */
    let showTimer = createMenuItem(
      title: "\(showTimerInMenuBar ? "hide timer in menu bar" : "show timer in menu bar")",
      action: #selector(toggleShowTimerInMenuBar),
      key: "t")
    menu.addItem(showTimer)

    menu.addItem(createSeparator())

    /* about */

    menu.addItem(createMenuItem(title: "about", action: nil))

    let aboutMenuItem = createMenuItem(title: "built by Tomo Myrman", action: #selector(openLink))
    menu.addItem(aboutMenuItem)

    let quitMenuItem = createMenuItem(title: "quit", action: #selector(quit), key: "q")
    menu.addItem(quitMenuItem)

    menu.delegate = self

    return menu
  }

  @objc func updateCountdown() {
    let countdown = NSMutableAttributedString(
      string: "\(timeUntil()) days till demo day",
      attributes: [
        NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 12)
      ])
    timerMenuItem.attributedTitle = countdown
  }

  @objc func setHouseValue(sender: NSMenuItem) {
    if sender.title == "unset house" {
      house = ""
    } else {
      house = sender.title
    }
  }

  @objc func updateHouseValue() {
    houseMenuItem.title = house.isEmpty || house == "unset" ? "set house" : house
  }

  @objc func updateCustomLinks() {
    let customLinks = [customLink1, customLink2, customLink3, customLink4, customLink5]

    customLinksDropdown?.removeAllItems()

    for link in customLinks {
      if !link.isEmpty {
        let menuItem = createMenuItem(title: link, action: #selector(openCustomLink))
        customLinksDropdown?.addItem(menuItem)
      }
    }

    let editCustomLinksMenuItem = createMenuItem(
      title: "edit links", action: #selector(editCustomLinks))
    customLinksDropdown?.addItem(editCustomLinksMenuItem)

    menu.update()
  }

  @objc func openCustomLink(sender: NSMenuItem) {
    let dropdowns = [customLink1, customLink2, customLink3, customLink4, customLink5]

    for dropdown in dropdowns {
      if dropdown == sender.title {
        let textTrimmed = dropdown.trimmingCharacters(in: .whitespacesAndNewlines)
        if textTrimmed.starts(with: "http") {
          NSWorkspace.shared.open(URL(string: textTrimmed)!)
          break
        }
      }
    }
  }

  @objc func editCustomLinks(sender: NSMenuItem) {
    let customLinksWindow = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 300, height: 300),
      styleMask: [.titled, .closable],
      backing: .buffered,
      defer: false)

    let customLinksView = CustomLinksView(window: customLinksWindow)
    customLinksWindow.contentView = NSHostingView(rootView: customLinksView)
    customLinksWindow.makeKeyAndOrderFront(nil)

    NSApp.activate(ignoringOtherApps: true)

    customLinksWindow.center()

    customLinksWindow.title = "custom links"
  }

  @objc func openLink(sender: NSMenuItem) {
    let dropdowns = [
      links, emailsDropdown, twitterDropdown, instagramDropdown, linkedinDropdown, youtubeDropdown,
      linksDropDown,
    ]

    for dropdown in dropdowns {
      if let url = dropdown[sender.title] {
        NSWorkspace.shared.open(URL(string: url)!)
        break
      }
    }
  }

  @objc func toggleShowTimerInMenuBar(sender: NSMenuItem) {
    showTimerInMenuBar.toggle()
    sender.title =
      "\(showTimerInMenuBar ? "hide timer in menu bar" : "show timer in menu bar")"
  }

  @objc func quit(sender: NSMenuItem) {
    NSApp.terminate(self)
  }

  func menuWillOpen(_ menu: NSMenu) {
    updateCountdown()
    updateHouseValue()
    updateCustomLinks()
  }
}
