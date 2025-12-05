import SwiftUI

import SwiftUI

// Создаем объект настроек, которым будем управлять
let overlaySettings = OverlaySettings()

@main
struct HotpawsXcodeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

// Кастомное окно которое может стать key window
class FullscreenWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var onboardingWindow: NSWindow?
    var mainWindow: NSWindow?
    var permissionWindow: NSWindow?
    var globalEventMonitor: Any?
    var localEventMonitor: Any?
    var statusItem: NSStatusItem?
    
    // Настройки
    var selectedTerminal: Terminal = .terminal
    var selectedAction: Action = .execute
    var blur: Double = 24
    var transparency: Double = 48
    var showOnboardingOnStartup: Bool = true
    
    // Ссылки на текстовые метки для live обновления
    var blurLabel: NSTextField?
    var transparencyLabel: NSTextField?
    
    enum Terminal {
        case terminal
        case iterm2
    }
    
    enum Action {
        case execute
        case send
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Загружаем настройку из UserDefaults
        showOnboardingOnStartup = UserDefaults.standard.bool(forKey: "showOnboardingOnStartup")
        if (UserDefaults.standard.object(forKey: "showOnboardingOnStartup") == nil) {
            showOnboardingOnStartup = true // По умолчанию включено
        }
        
        // Создаем menu bar
        setupMenuBar()
        
        // Настраиваем хоткеи (оба типа мониторов)
        setupHotkeys()
        
        // Показываем окно онбординга только если включено
        if showOnboardingOnStartup {
            showOnboardingWindow()
        } else {
            // Сразу проверяем разрешение и показываем оверлей
            checkPermissionAndShowOverlay()
        }
    }
    
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "pawprint.fill", accessibilityDescription: "Hotpaws")
        }
        
        updateMenu()
    }
    
    func updateMenu() {
        let menu = NSMenu()
        
        // Показать/Скрыть подсказки
        let isVisible = mainWindow?.isVisible ?? false
        let toggleTitle = isVisible ? "Скрыть подсказки (F19)" : "Показать подсказки (F19)"
        menu.addItem(NSMenuItem(title: toggleTitle, action: #selector(toggleOverlay), keyEquivalent: ""))
        
        menu.addItem(NSMenuItem.separator())
        
        // Настройки
        let settingsItem = NSMenuItem(title: "Настройки", action: nil, keyEquivalent: "")
        let settingsMenu = NSMenu()
        
        // Терминал
        let terminalItem = NSMenuItem(title: "Терминал", action: nil, keyEquivalent: "")
        let terminalMenu = NSMenu()
        
        let terminalAppItem = NSMenuItem(title: "Terminal.app", action: #selector(selectTerminalApp), keyEquivalent: "")
        terminalAppItem.state = selectedTerminal == .terminal ? .on : .off
        terminalMenu.addItem(terminalAppItem)
        
        let iterm2Item = NSMenuItem(title: "iTerm2", action: #selector(selectITerm2), keyEquivalent: "")
        iterm2Item.state = selectedTerminal == .iterm2 ? .on : .off
        terminalMenu.addItem(iterm2Item)
        
        terminalItem.submenu = terminalMenu
        settingsMenu.addItem(terminalItem)
        
        // Действие
        let actionItem = NSMenuItem(title: "Действие", action: nil, keyEquivalent: "")
        let actionMenu = NSMenu()
        
        let executeItem = NSMenuItem(title: "Исполнить", action: #selector(selectExecute), keyEquivalent: "")
        executeItem.state = selectedAction == .execute ? .on : .off
        actionMenu.addItem(executeItem)
        
        let sendItem = NSMenuItem(title: "Отправить", action: #selector(selectSend), keyEquivalent: "")
        sendItem.state = selectedAction == .send ? .on : .off
        actionMenu.addItem(sendItem)
        
        actionItem.submenu = actionMenu
        settingsMenu.addItem(actionItem)
        
        settingsMenu.addItem(NSMenuItem.separator())
        
        // Фон
        let backgroundItem = NSMenuItem(title: "Фон", action: nil, keyEquivalent: "")
        let backgroundMenu = NSMenu()
        
        // Размытие
        let blurItem = NSMenuItem(title: "Размытие", action: nil, keyEquivalent: "")
        blurItem.view = createSliderView(value: blur, min: 0, max: 100, label: "\(Int(blur))%", action: #selector(blurChanged(_:)), isBlur: true)
        backgroundMenu.addItem(blurItem)
        
        // Прозрачность
        let transparencyItem = NSMenuItem(title: "Прозрачность", action: nil, keyEquivalent: "")
        transparencyItem.view = createSliderView(value: transparency, min: 0, max: 100, label: "\(Int(transparency))%", action: #selector(transparencyChanged(_:)), isBlur: false)
        backgroundMenu.addItem(transparencyItem)
        
        backgroundItem.submenu = backgroundMenu
        settingsMenu.addItem(backgroundItem)
        
        settingsItem.submenu = settingsMenu
        menu.addItem(settingsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Онбординг
        let onboardingItem = NSMenuItem(title: "Онбординг", action: #selector(toggleOnboarding), keyEquivalent: "")
        onboardingItem.state = showOnboardingOnStartup ? .on : .off
        menu.addItem(onboardingItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Выход (без хоткея)
        menu.addItem(NSMenuItem(title: "Выход", action: #selector(quitApp), keyEquivalent: ""))
        
        statusItem?.menu = menu
    }
    
    func createSliderView(value: Double, min: Double, max: Double, label: String, action: Selector, isBlur: Bool) -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 220, height: 45))
        
        // Заголовок над ползунком
        let titleLabel = NSTextField(frame: NSRect(x: 15, y: 24, width: 200, height: 17))
        titleLabel.stringValue = isBlur ? "Размытие:" : "Прозрачность:"
        titleLabel.isBezeled = false
        titleLabel.isEditable = false
        titleLabel.drawsBackground = false
        titleLabel.font = NSFont.systemFont(ofSize: 11)
        titleLabel.textColor = .secondaryLabelColor
        
        let slider = NSSlider(frame: NSRect(x: 15, y: 4, width: 140, height: 17))
        slider.minValue = min
        slider.maxValue = max
        slider.doubleValue = value
        slider.target = self
        slider.action = action
        slider.controlSize = .small
        
        let labelView = NSTextField(frame: NSRect(x: 160, y: 3, width: 50, height: 19))
        labelView.stringValue = label
        labelView.isBezeled = false
        labelView.isEditable = false
        labelView.drawsBackground = false
        labelView.alignment = .right
        labelView.font = NSFont.systemFont(ofSize: 11)
        
        // Сохраняем ссылку на метку для live обновления
        if isBlur {
            blurLabel = labelView
        } else {
            transparencyLabel = labelView
        }
        
        view.addSubview(titleLabel)
        view.addSubview(slider)
        view.addSubview(labelView)
        return view
    }
    
    @objc func toggleOverlay() {
        toggleMainWindow()
        updateMenu()
    }
    
    @objc func selectTerminalApp() {
        selectedTerminal = .terminal
        updateMenu()
    }
    
    @objc func selectITerm2() {
        selectedTerminal = .iterm2
        updateMenu()
    }
    
    @objc func selectExecute() {
        selectedAction = .execute
        updateMenu()
    }
    
    @objc func selectSend() {
        selectedAction = .send
        updateMenu()
    }
    
    @objc func blurChanged(_ sender: NSSlider) {
        overlaySettings.updateBlur(from: sender.doubleValue)
        blurLabel?.stringValue = "\(Int(sender.doubleValue))%"
    }

    @objc func transparencyChanged(_ sender: NSSlider) {
        overlaySettings.updateDarkness(from: sender.doubleValue)
        transparencyLabel?.stringValue = "\(Int(sender.doubleValue))%"
    }
    
    @objc func toggleOnboarding() {
        showOnboardingOnStartup.toggle()
        UserDefaults.standard.set(showOnboardingOnStartup, forKey: "showOnboardingOnStartup")
        updateMenu()
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
    
    func setupHotkeys() {
        // Локальный монитор - работает ВСЕГДА (когда приложение активно)
        localEventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 80 { // F19
                self.handleF19Press()
                return nil
            }
            return event
        }
        
        // Глобальный монитор - работает только с разрешением Accessibility
        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 80 { // F19
                self.handleF19Press()
            }
        }
    }
    
    func handleF19Press() {
        print("🎯 F19 pressed - toggling window")
        self.toggleMainWindow()
        self.updateMenu()
    }
    
    func showPermissionAlert(onGranted: @escaping () -> Void) {
        DispatchQueue.main.async {
            let contentView = PermissionRequestView {
                self.openAccessibilitySettings()
                self.waitForPermissionAndProceed(onGranted: onGranted)
            } onCancel: {
                NSApp.terminate(nil)
            }
            
            let hostingController = NSHostingController(rootView: contentView)
            
            self.permissionWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 450, height: 280),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            
            self.permissionWindow?.title = "Требуется разрешение"
            self.permissionWindow?.contentViewController = hostingController
            self.permissionWindow?.center()
            self.permissionWindow?.level = .floating
            self.permissionWindow?.makeKeyAndOrderFront(nil)
            
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    func waitForPermissionAndProceed(onGranted: @escaping () -> Void) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            let trusted = AXIsProcessTrusted()
            if trusted {
                print("✅ Permission granted!")
                timer.invalidate()
                
                self.permissionWindow?.close()
                self.permissionWindow = nil
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onGranted()
                }
            }
        }
    }
    
    func openAccessibilitySettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }
    
    func toggleMainWindow() {
        guard let window = mainWindow else { return }
        
        if window.isVisible {
            window.orderOut(nil)
            print("Window hidden")
        } else {
            NSApp.activate(ignoringOtherApps: true)
            window.makeKeyAndOrderFront(nil)
            window.orderFrontRegardless()
            print("Window shown")
        }
    }
    
    func showOnboardingWindow() {
        // Старая версия (простая):
        // let contentView = OnboardingView {
        //     self.closeOnboardingAndCheckPermission()
        // }
        
        // Новая версия (с дизайном):
        let contentView = OnboardingViewV2 {
            self.closeOnboardingAndCheckPermission()
        }
        
        let hostingController = NSHostingController(rootView: contentView)
        
        onboardingWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 770, height: 480),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        onboardingWindow?.title = "Добро пожаловать"
        onboardingWindow?.contentViewController = hostingController
        onboardingWindow?.center()
        onboardingWindow?.isReleasedWhenClosed = false
        onboardingWindow?.makeKeyAndOrderFront(nil)
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func closeOnboardingAndCheckPermission() {
        self.onboardingWindow?.close()
        self.onboardingWindow = nil
        
        checkPermissionAndShowOverlay()
    }
    
    func checkPermissionAndShowOverlay() {
        let trusted = AXIsProcessTrusted()
        
        if trusted {
            print("✅ Accessibility permission already granted")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showFullscreenWindow()
            }
        } else {
            print("⚠️ Accessibility permission needed")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showPermissionAlert {
                    self.showFullscreenWindow()
                }
            }
        }
    }
    
    func showFullscreenWindow() {
        guard let screen = NSScreen.main else { 
            print("ERROR: No main screen found")
            return 
        }
        
        print("Screen frame: \(screen.frame)")
        print("Screen visible frame: \(screen.visibleFrame)")
        
        let contentView = FullscreenOverlayView(settings: overlaySettings)
        
        let hostingController = NSHostingController(rootView: contentView)
        
        mainWindow = FullscreenWindow(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        mainWindow?.level = .floating
        mainWindow?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        mainWindow?.isOpaque = false
        mainWindow?.backgroundColor = .clear
        mainWindow?.hasShadow = false
        mainWindow?.ignoresMouseEvents = false
        mainWindow?.contentViewController = hostingController
        mainWindow?.isReleasedWhenClosed = false
        
        mainWindow?.setFrame(screen.frame, display: true)
        
        NSApp.activate(ignoringOtherApps: true)
        
        mainWindow?.makeKeyAndOrderFront(nil)
        mainWindow?.orderFrontRegardless()
        
        print("Window created: \(mainWindow != nil)")
        print("Window visible: \(mainWindow?.isVisible ?? false)")
        print("Window frame: \(mainWindow?.frame ?? .zero)")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        if let monitor = globalEventMonitor {
            NSEvent.removeMonitor(monitor)
        }
        if let monitor = localEventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
