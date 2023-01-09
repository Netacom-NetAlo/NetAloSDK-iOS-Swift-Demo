//
//  SDKDemo_SwiftUIApp.swift
//  SDKDemo_SwiftUI
//
//  Created by Hoang Do on 1/9/23.
//

import SwiftUI
import NACoreUI
import NetAloFull
import NetAloLite
import XCoordinator
import NALocalization
import RxCocoa
import RxSwift
import UserNotifications
import Firebase
import UIKit

@main
struct SDKDemo_SwiftUIApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(delegate: appDelegate)
            }
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                print("App background")
                appDelegate.applicationWillResignActive(UIApplication.shared)
            case .active:
                appDelegate.applicationDidBecomeActive(UIApplication.shared)
                print("App active")
            case .inactive:
                appDelegate.applicationWillResignActive(UIApplication.shared)
                print("App inactive")
            default: break
            }

        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    public var netAloSDK: NetAloFullManager!

    private let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    private var disposeBag = DisposeBag()

    public func setUser() {
        let user = NetAloUserHolder(id: 2814749772862138,
                                            phoneNumber: "+84101000899",
                                            email: "",
                                            fullName: "g899",
                                            avatarUrl: "C9KpMehqESpH-06uiPEQaGOlt1D2vmvZwtz5Trva8XJKgzXBMUIfGQkN8-MpNaEP",
                                            session: "0554da9ee48f9cf24784a0772a73a38ff40fALLb")
                do {
                    try self.netAloSDK?.set(user: user)
                } catch let e {
                    print("Error \(e)")
                }
        do {
            try self.netAloSDK?.set(user: user)
        } catch let e {
            print("Error \(e)")
        }

        bindingService()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()

        self.netAloSDK = NetAloFullManager(
            config: BuildConfig.config
        )

        // Only show SDK after start success, Waiting maximun 10s
        self.netAloSDK
            .start()
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .catchAndReturn(())
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .do(onNext: { (owner, _) in

                self.netAloSDK.buildSDKModule()
                owner.setUser()
            })
            .subscribe()
            .disposed(by: disposeBag)

        return netAloSDK.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - AppDelegateViewModelOutputs

    public func applicationDidBecomeActive(_ application: UIApplication) {
        netAloSDK.applicationDidBecomeActive(application)
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        netAloSDK.applicationWillResignActive(application)
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        netAloSDK.applicationWillTerminate(application)
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        netAloSDK.application(application, supportedInterfaceOrientationsFor: window)
    }

    // UserActivity
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        netAloSDK.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }

    // Notification methods
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        netAloSDK.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        netAloSDK.application(application, open: url, sourceApplication: sourceApplication, annotation: application)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        netAloSDK.application(app, open: url, options: options)
    }

    // MARK: - UNUserNotificationCenterDelegate
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        NSLog("Netacom123 %@", userInfo)

        // Print full message.
        print(userInfo)

        // Change this to your preferred presentation option
        netAloSDK.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
        completionHandler([.badge, .sound, .alert])
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        netAloSDK.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.

        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token 2: \(token)")

          }
        }
    }
}


//MARK: SDK call back
extension AppDelegate {
    //SDK binding service
    private func bindingService() {
        self.netAloSDK.eventObservable
            .asDriverOnErrorJustSkip()
            .drive(onNext: { [weak self] event in
                dump("Event: \(event)")
                switch event {
                case .pressedUrl(let url):
                    dump("PressedUrl: \(url)")
                case .mediaURL(let imageUrls, let videoUrls):
                    dump("Images: \(imageUrls)")
                    dump("Video: \(videoUrls)")
                case .checkUserIsFriend(let userId):
                    dump("Check Chat with: \(userId)")
                case .didCloseSDK:
                    dump("didCloseSDK")
                case .pressedCall(let type):
                    dump("pressedCall type: \(type)")
                case .sessionExpired:
                    dump("sessionExpired")
                case .updateBadge(let badge) :
                    dump("updateBadge: \(badge)")
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
}
