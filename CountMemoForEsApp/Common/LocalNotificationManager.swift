//
//  LocalNotificationManager.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/22.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class LocalNotificationManager: NSObject {

    static func addNotificaion(data: Memo, time: TimeInterval) {
        let delegateObj = AppDelegate.instance();
        // Notification のインスタンス作成
        let content = UNMutableNotificationContent() // Содержимое уведомления

        let categoryIdentifire = "Delete Notification Type"
        
        // タイトル、本文の設定
        let titleText = data.company!
        content.title = "\(String(describing: titleText))"
        content.body = "エントリーシートの締め切りが迫っています。"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        //リクエストの設定
        let request = UNNotificationRequest.init(identifier: titleText + data.title!, content: content, trigger: trigger)
        //通知
        delegateObj.notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifire,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        delegateObj.notificationCenter.setNotificationCategories([category])
    }
    
    static func removeNotification(data: Memo) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [data.company! + data.title!])
        center.removeDeliveredNotifications(withIdentifiers: [data.company! + data.title!])
    }
}
