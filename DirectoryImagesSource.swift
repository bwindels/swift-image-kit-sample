//
//  DirectoryImagesSource.swift
//  pictures2
//
//  Created by Bruno Windels on 15/03/15.
//  Copyright (c) 2015 Bruno Windels. All rights reserved.
//

import Foundation

class DirectoryImagesSource {
    
    let extensions = [".jpg", ".jpeg"];
    let rootDirectory: String
    var enumerator: NSDirectoryEnumerator?
    var cachedCount: UInt64?
    var currentOffset: UInt64 = 0
    
    init(rootDirectory: String) {
        self.rootDirectory = rootDirectory
    }
    
    func imageCount() -> UInt64 {
        if cachedCount == nil {
            reset()
            var count:UInt64 = 0
            iterateTree({ (_: String) -> Bool in
                ++count
                return true
            })
            self.cachedCount = count
        }
        return cachedCount!
    }
    
    func seekTo(offset: UInt64) {
        if currentOffset != offset {
            if currentOffset > offset {
                reset()
            }
            if offset > 0 {
                iterateTree({ (_: String) -> Bool in
                    return (self.currentOffset + 1) < offset
                })
            }
        }
    }

    func nextImage() -> String? {
        if enumerator == nil {
            reset()
        }
        var imagePath: String?
        iterateTree({
            (path: String) -> Bool in
            imagePath = path
            return false
        })
        return imagePath
    }
    
    private func reset() {
        currentOffset = 0
        enumerator = NSFileManager.defaultManager().enumeratorAtPath(rootDirectory)
    }
    
    private func iterateTree(closure: (String) -> Bool) {
        var resume = true
        while resume {
            if let nextValue: AnyObject? = enumerator?.nextObject() {
                if let path = nextValue as? String {
                    if path.lowercaseString.hasSuffix(".jpg") {
                        resume = closure(path)
                    }
                }
                else {
                    resume = false
                }
            }
        }
    }
}