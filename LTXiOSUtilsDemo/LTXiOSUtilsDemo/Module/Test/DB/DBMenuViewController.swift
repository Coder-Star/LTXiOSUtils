//
//  DBMenuViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/25.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DBMenuViewController: BaseGroupTableMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DB"
    }

    override func setMenu() {
        let fisrtMenu = [
            BaseGroupTableMenuModel(code: "CoreData", title: "CoreData"),
            BaseGroupTableMenuModel(code: "Realm", title: "Realm")
        ]
        menu.append(fisrtMenu)
    }

    override func click(menuModel: BaseGroupTableMenuModel) {
        switch menuModel.code {
        case "CoreData":
            showCoreDataAction()
        case "Realm":
            break
        default:
            HUD.showText("暂无此模块")
        }
    }
}

extension DBMenuViewController {
    func showCoreDataAction() {
        let alertController = getAlert(style: .actionSheet, title: "操作", message: "请选择操作", cancelTitle: "取消", sureBlock: nil)
        let action1 = UIAlertAction(title: "存入", style: .destructive) { [weak self] _ in
            self?.saveInfo()
        }
        let action2 = UIAlertAction(title: "读取", style: .destructive) { [weak self] _ in
            self?.getInfo()
        }
        alertController?.addAction(action1)
        alertController?.addAction(action2)
        present(alertController!, animated: true, completion: nil)
    }

    func saveInfo() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "CboUser", into: context) as? CboUser else {
            return
        }
        user.id = 1
        user.usercode = "0001"
        user.username = "张三"

        if CoreDataManager.shared.saveContext().success {
            HUD.showText("存入成功")
        }
        Log.d(NSHomeDirectory())
    }

    func getInfo() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CboUser>(entityName: "CboUser")
        fetchRequest.fetchLimit = 2
        fetchRequest.predicate = NSPredicate(format: "usercode = %@", "0002")
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            for info in fetchedObjects {
                Log.d(info.id)
                Log.d(info.usercode)
                Log.d(info.username)

                // 删除
//                context.delete(info)
//                try context.save()
            }
        } catch {
            Log.d(error)
        }
    }
}
