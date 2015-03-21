//
//  ImageBrowserController.swift
//  pictures2
//
//  Created by Bruno Windels on 15/03/15.
//  Copyright (c) 2015 Bruno Windels. All rights reserved.
//

import Cocoa
import Quartz

class ImageItem: NSObject {
    let photo: Photo
    var image: NSImage?
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    override func imageRepresentationType() -> String! {
        return IKImageBrowserNSImageRepresentationType
    }
    
    override func imageRepresentation() -> AnyObject! {
        if let loadedImage = self.image {
            return loadedImage
        }
        else {
            image = NSImage(data: photo.thumbnailData())!
            return image!
        }
    }
    
    override func imageUID() -> String! {
        return photo.UID()
    }
}

class ImageBrowserController: NSObject {
    
    @IBOutlet var imageBrowser: IKImageBrowserView?
    var photoCollection: PhotoCollection?
    
    override func numberOfItemsInImageBrowser(aBrowser: IKImageBrowserView!) -> Int {
        return Int(photoCollection!.count())
    }
    
    
    override func imageBrowser(aBrowser: IKImageBrowserView!, itemAtIndex index: Int) -> AnyObject! {
        photoCollection!.seekTo(Int64(index));
        let photo = photoCollection!.currentPhoto()!
        return ImageItem(photo: photo)
    }
    
    @IBAction func loadPicturesFromDirectory(senderView: NSView) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.beginSheetModalForWindow(senderView.window!, completionHandler: {(result: Int) in ()
            if result == NSOKButton {
                let selection = panel.URL!.path!
                self.photoCollection = DirectoryPhotoCollection(rootDirectory: selection)
                self.imageBrowser!.reloadData()
            }
        })
    }
    
    @IBAction func setZoomFactor(slider: NSSlider) {
        let value = (slider.doubleValue as Double - slider.minValue) / (slider.maxValue - slider.minValue)
        imageBrowser!.setZoomValue(Float(value))
    }
}