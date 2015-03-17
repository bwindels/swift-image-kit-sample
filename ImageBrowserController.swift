//
//  ImageBrowserController.swift
//  pictures2
//
//  Created by Bruno Windels on 15/03/15.
//  Copyright (c) 2015 Bruno Windels. All rights reserved.
//

import Cocoa
import Quartz

class ImageItem: NSObject, IKImageBrowserItem {
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    override func imageRepresentationType() -> String! {
        return IKImageBrowserPathRepresentationType
    }
    
    override func imageRepresentation() -> AnyObject! {
        return path
    }
    
    override func imageUID() -> String! {
        return path
    }
}

class ImageBrowserController: NSObject, IKImageBrowserDataSource {
    
    override init() {}
    
    @IBOutlet var window: NSWindow?
    @IBOutlet var imageBrowser: IKImageBrowserView?
    var imageSource: DirectoryImagesSource?
    
    override func numberOfItemsInImageBrowser(aBrowser: IKImageBrowserView!) -> Int {
        if imageSource == nil {
            return Int(imageSource!.imageCount())
        }
        return 0
    }
    
    override func imageBrowser(aBrowser: IKImageBrowserView!, itemAtIndex index: Int) -> AnyObject! {
        
    }

    @IBAction func loadPicturesFromDirectory(sender: AnyObject) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.beginSheetModalForWindow(window!, completionHandler: {(result: Int) in ()
            if result == NSOKButton {
                let selection = panel.URL!.path!
                self.imageSource = DirectoryImagesSource(rootDirectory: selection)
                self.imageBrowser!.reloadData()
            }
        })
    }
}