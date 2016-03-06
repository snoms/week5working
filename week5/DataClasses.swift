//
//  DataClasses.swift
//  week5
//
//  Created by bob on 04/03/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation


class ToDoList: NSObject, NSCoding {
    var name: String
    var items: [String]
    
    init(name: String, items: [String]) {
        self.name = name
        self.items = items
    }
    
//    required convenience init?(coder decoder: NSCoder) {
//        guard let items = decoder.decodeObjectForKey("items") as? [String]
//            else {return nil}
//        
//        func initWithCoder(name: name, items: items)
//    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        items = aDecoder.decodeObjectForKey("items") as! [String]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(items, forKey: "items")
    }

    func addItem(item:String) {
        self.items.append(item)
    }
}

// http://stackoverflow.com/questions/34127828/saving-array-of-custom-object-with-nscoding
class TodoLists: NSObject, NSCoding {
    var list = [ToDoList]()
    
    init(list : [ToDoList]) {
        self.list = list
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let list = decoder.decodeObjectForKey("list") as? [ToDoList]
        else {return nil}
        
        self.init(list : list)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(list, forKey: "list")
    }
}