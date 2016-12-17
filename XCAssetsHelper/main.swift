//
//  main.swift
//  XCAssetsHelper
//
//  Created by Tanner on 12/16/16.
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

import Foundation


// Assert correct number of args
guard CommandLine.arguments.count == 2 else {
    print("Usage: xcassetshelper <directory>")
    exit(0)
}

// Get directories
let workingDirectory = CommandLine.arguments[1]
let assetsFolder = workingDirectory.appendingPathComponent("Assets.xcassets")

// Scan for all images in working directory, only handle ones with @Yx suffixes
var files = try! FileManager.default.contentsOfDirectory(atPath: workingDirectory)
files = files.filter {
    return $0.hasSuffix("@2x.png") || $0.hasSuffix("@3x.png")
}

// Change "foo@2x.png" to "foo"
var imageNames = files.map {
    return ($0 as NSString).replacingOccurrences(of: "@[23]x\\.png",
                                                 with: "",
                                                 options: [NSString.CompareOptions.regularExpression],
                                                 range: NSMakeRange(0, $0.characters.count)
    )
}

// Remove duplicates
imageNames = Array(Set(imageNames))

// Make assets folder
try FileManager.default.createDirectory(atPath: assetsFolder, withIntermediateDirectories: true, attributes: nil)


let contentsEntry2x = "    {\n      \"idiom\": \"universal\",\n      \"scale\": \"2x\",\n      \"filename\": \"%@\"\n    }"
let contentsEntry3x = "    {\n      \"idiom\": \"universal\",\n      \"scale\": \"3x\",\n      \"filename\": \"%@\"\n    }"
let json = "{\n  \"images\": [\n    {\n      \"idiom\": \"universal\",\n      \"scale\": \"1x\"\n    },\n%@\n  ],\n  \"info\": {\n    \"version\": 1,\n    \"author\": \"xcode\"\n  }\n}"

// Update and save JSON
let scale  = (low: contentsEntry2x, high: contentsEntry3x)
for filename in imageNames {
    let lowres = filename + "@2x.png"
    let highres = filename + "@3x.png"
    let hasLowres = files.contains(lowres)
    let hasHighres = files.contains(highres)
    
    var imageSetDirectory = assetsFolder.appendingPathComponent(filename + ".imageset")
    FileManager.default.createDirectory(at: imageSetDirectory)
    
    var contents = ""
    
    // Copy images, update Contents.json
    if hasLowres {
        contents += String(format: contentsEntry2x, arguments: [lowres]) + (hasHighres ? ",\n      " : "")
        FileManager.default.copy(workingDirectory.appendingPathComponent(lowres),
                                 to: imageSetDirectory.appendingPathComponent(lowres))
    }
    if hasHighres {
        contents += String(format: contentsEntry3x, arguments: [highres])
        FileManager.default.copy(workingDirectory.appendingPathComponent(highres),
                                 to: imageSetDirectory.appendingPathComponent(highres))
    }
    
    // Write Contents.json
    let finalContents = String(format: json, arguments: [contents])
    finalContents.write(to: imageSetDirectory.appendingPathComponent("Contents.json"))
}
