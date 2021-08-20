//
//  Tweet+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Shaw on 16/8/25.
//  Copyright © 2016年 XiaoLinyun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tweet {

    @NSManaged var posted: NSDate?
    @NSManaged var text: String?
    @NSManaged var unique: String?
    @NSManaged var twitter: TweeterUser?

}
