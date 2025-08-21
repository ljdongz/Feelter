//
//  AppDelegate.swift
//  Feelter
//
//  Created by 이정동 on 7/21/25.
//

import UIKit

import FirebaseCore
import FirebaseMessaging
import iamport_ios
import KakaoSDKCommon

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        KakaoSDK.initSDK(appKey: AppConfiguration.kakaoApiKey)
        DIContainer.shared.registerDependencies()
        
        configurePushNotification()
        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Iamport.shared.close()
    }
}

// MARK: - Remote Notification

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(#function)
        
        // Device Token을 FCM에 등록
        Messaging.messaging().apnsToken = deviceToken
        
        let newToken = deviceToken.reduce("") { $0 + String(format: "%02X", $1) }
        
        let tokenManager = DIContainer.shared.resolve(TokenManager.self)
        
        // 디바이스 토큰이 저장되있지 않은 경우 (로그인 화면), 저장
        guard let current = tokenManager.deviceToken else {
            tokenManager.updateDeviceToken(newToken)
            return
        }
        
        // 기존 디바이스 토큰과 새로 발급받은 디바이스 토큰이 동일한 경우, 종료
        guard current != newToken else { return }
        
        let networkProvider = DIContainer.shared.resolve(NetworkProvider.self)
        Task {
            do {
                let request = UpdateDeviceTokenRequestDTO(deviceToken: newToken)
                try await networkProvider.request(
                    endpoint: AuthAPI.updateDeviceToken(request)
                )
                tokenManager.updateDeviceToken(newToken)
            } catch {
                print("Update Device Token Error: \(error)")
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    private func configurePushNotification() {
        Messaging.messaging().delegate = self
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        // 알림을 표시하기 위한 승인을 요청
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("Permission granted: \(granted)")
        }
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🟢", #function, fcmToken)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    // foreground 상태일 때 푸시 알림 감지
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(#function)
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo)
            let apnsPayload = try JSONDecoder().decode(APNsPayload.self, from: jsonData)
            
            print("🔔 APNs Payload decoded successfully:")
            
            NotificationCenter.default.post(
                name: .ReceiveRemotePush,
                object: apnsPayload
            )
        } catch {
            print("❌ Failed to decode APNs payload: \(error)")
            print("UserInfo: \(userInfo)")
        }
    }
    
    // 푸시 알림 배너 클릭했을 시 실행
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
    }
}
