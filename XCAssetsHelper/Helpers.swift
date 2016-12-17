//
//  Helpers
//  XCAssetsHelper
//
//  Created by Tanner on 12/16/16.
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

import Foundation

extension String {
    func appendingPathComponent(_ component: String) -> String {
        return (self as NSString).appendingPathComponent(component)
    }
    
    mutating func appendPathComponent(_ component: String) {
        self = self.appendingPathComponent(component)
    }
    
    func write(to file: String) {
        try! self.write(toFile: file, atomically: true, encoding: .ascii)
        print("Writing \(file)...")
    }
    
//    mutating func trim(to idx: Int) {
//        let chars = self.characters
//        let start = chars.startIndex
//        self = self.substring(to: chars.index(start, offsetBy: idx))
//    }
//    
//    mutating func trimTrailing(n: Int) {
//        self.trim(to: self.characters.count - n)
//    }
}

extension FileManager {
    func createDirectory(at path: String) {
        try! self.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    func copy(_ from: String, to destination: String) {
        try! self.copyItem(atPath: from, toPath: destination)
    }
}
