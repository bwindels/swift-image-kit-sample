//
//  DirectoryImagesSource.swift
//  pictures2
//
//  Created by Bruno Windels on 15/03/15.
//  Copyright (c) 2015 Bruno Windels. All rights reserved.
//

import Foundation

class DirectoryPhoto: Photo {
    let path: String
    var data: NSData?
    
    init(path: String) {
        self.path = path
    }

    func thumbnailData() -> NSData {
        if let loadedData = data {
            return loadedData
        }
        else {
            data = NSData(contentsOfFile: path)
            return data!
        }
    }
    
    func title() -> String {
        return path
    }
    
    func UID() -> String {
        return path
    }
}

class DirectoryPhotoCollection: PhotoCollection {
    
    let extensions = [".jpg", ".jpeg"];
    let rootDirectory: String
    var enumerator: NSDirectoryEnumerator?
    var cachedCount: UInt64?
    var currentOffset: Int64 = 0
    var _currentPhoto: Photo?
    
    init(rootDirectory: String) {
        self.rootDirectory = rootDirectory
    }
    
    func count() -> UInt64 {
        if cachedCount == nil {
            reset()
            var count:UInt64 = 0
            continueTreeIteration({ (_: String) -> Bool in
                ++count
                return true
            })
            self.cachedCount = count
        }
        return cachedCount!
    }
    
    func seekTo(offset: Int64) {
        if currentOffset != offset {
            if currentOffset > offset {
                reset()
            }
            if offset > 0 {
                continueTreeIteration({ (_: String) -> Bool in
                    return (self.currentOffset + 1) < offset
                })
            }
        }
    }
    
    func currentPhoto() -> Photo? {
        return _currentPhoto
    }

    func nextPhoto() -> Photo? {
        if enumerator == nil {
            reset()
        }
        continueTreeIteration({ (path: String) -> Bool in
            return false
        })
        return _currentPhoto
    }
    
    private func reset() {
        currentOffset = -1
        enumerator = NSFileManager.defaultManager().enumeratorAtPath(rootDirectory)
    }
    
    private func continueTreeIteration(closure: (String) -> Bool) {
        var resume = true
        while resume {
            if let nextValue: AnyObject? = enumerator?.nextObject() {
                if let path = nextValue as? String {
                    if path.lowercaseString.hasSuffix(".jpg") {
                        let currentPath = rootDirectory + "/" + path
                        _currentPhoto = DirectoryPhoto(path: currentPath)
                        ++currentOffset
                        resume = closure(path)
                    }
                }
                //no more files
                else {
                    resume = false
                }
            }
        }
    }
}