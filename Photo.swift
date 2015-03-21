//
//  Photo.swift
//  pictures2
//
//  Created by Bruno Windels on 21/03/15.
//  Copyright (c) 2015 Bruno Windels. All rights reserved.
//

import Foundation

protocol Photo {
    func thumbnailData() -> NSData
    func title() -> String
    func UID() -> String
}

protocol PhotoCollection {
    func count() -> UInt64
    func seekTo(offset: Int64)
    func currentPhoto() -> Photo?
    func nextPhoto() -> Photo?
}