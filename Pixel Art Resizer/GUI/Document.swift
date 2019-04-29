//
//  Document.swift
//  Pixel Art Resizer
//
//  Created by Ben Leggiero on 4/26/19.
//  Copyright © 2019 Blue Husky Studios BH-1-PS
//

import Cocoa
import PixelArtKit



class Document: NSDocument {

    @IBOutlet weak var preserveAspectRatioCheckBox: NSButton?
    @IBOutlet weak var imageWell: NSImageView?
    @IBOutlet weak var widthTextField: NSTextField?
    @IBOutlet weak var heightTextField: NSTextField?
    @IBOutlet weak var imageTitleTextField: NSTextField?
    @IBOutlet weak var imageDimensionsTextField: NSTextField?
    @IBOutlet weak var exportButton: NSButton?
    @IBOutlet weak var shrinkageWarningLabel: NSTextField!
    @IBOutlet weak var fileDropView: DragDropFileView!
    
    private var originalImage: Image? {
        didSet {
            updateUi()
        }
    }
    
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }
    
    
    override class var autosavesInPlace: Bool {
        return false
    }
    
    
    override var windowNibName: NSNib.Name? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return NSNib.Name("Document")
    }
    
    
    override func write(to url: URL, ofType typeName: String, for saveOperation: NSDocument.SaveOperationType, originalContentsURL absoluteOriginalContentsURL: URL?) throws {
        // Insert code here to write your document to data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override fileWrapper(ofType:), data(to:ofType:), or write(to:ofType) instead.
        
        beginExporting(to: url)
        
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    
    override func read(from url: URL, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override read(from:ofType:) instead.
        // If you do, you should also override isEntireFileLoaded to return false if the contents are lazily loaded.
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        
        beginImporting(from: url)
    }
    
    
    override func saveAs(_ sender: Any?) {
        presentSaveAsPanel()
    }
    
    
    override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
        fileDropView.acceptedTypes = [.fileByExtension(extension: "png"),
                                      .fileByUti(uti: kUTTypePNG as String),
                                      .imageByUti(uti: kUTTypePNG as String)]
        fileDropView?.onDrop = { items in
            guard let firstItem = items.first else {
                assertionFailure("Nothing dropped?")
                return false
            }
            
            return self.beginImporting(from: firstItem)
        }
        
        updateUi()
    }
    
    
    @IBAction func didPressOpenButton(_ sender: NSButton) {
        presentOpenPanel()
    }
    
    
    @IBAction func didPressExportButton(_ sender: NSButton) {
        presentSaveAsPanel()
    }
    
    
    @IBAction func widthFieldDidChange(_ sender: NSTextField) {
        synchronizeSizeFields(fromWidth: sender.cgFloatValue)
    }
    
    
    @IBAction func heightFieldDidChange(_ sender: NSTextField) {
        synchronizeSizeFields(fromHeight: sender.cgFloatValue)
    }
    
    
    func synchronizeSizeFields(fromWidth width: CGFloat) {
        guard let newSize = newSizePreservingAspectRatio(width: width) else {
            NSLog("No new size")
            return
        }
        
        heightTextField?.cgFloatValue = newSize.height
        
        updateWarningLabel()
    }
    
    
    func synchronizeSizeFields(fromHeight height: CGFloat) {
        guard let newSize = newSizePreservingAspectRatio(height: height) else {
            NSLog("No new size")
            return
        }
        
        widthTextField?.cgFloatValue = newSize.width
        
        updateWarningLabel()
    }
    
    
    func updateWarningLabel() {
        shrinkageWarningLabel.isHidden = !(originalImageSize.flatMap { newSize?.isLessThan($0, approach: .atAll) } ?? false)
    }
    
    
    
    struct Image {
        let nsImage: NSImage
        let name: String
        
        
        
        init?(loading url: URL) {
            guard let loadedImage = NSImage(contentsOf: url) else {
                return nil
            }
            
            self.nsImage = loadedImage
            self.name = url.lastPathComponent
        }
        
        
        init(nsImage: NSImage, name: String? = nil) {
            self.nsImage = nsImage
            self.name = name ?? nsImage.name() ?? "Untitled"
        }
    }
}



extension Document {
    func presentOpenPanel() {
        let openPanel = NSOpenPanel()
        openPanel.present(on: windowForSheet) { response in
            switch response {
            case .OK:
                guard let url = openPanel.url else {
                    NSLog("Why would you do this?")
                    return
                }
                self.beginImporting(from: url)
                
            default:
                Swift.print("🤷🏽‍♂️")
            }
        }
    }
    
    
    func presentSaveAsPanel() {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = originalImage?.name.ensuringPathExtension("png") ?? "Untitled.png"
        savePanel.present(on: windowForSheet) { response in
            switch response {
            case .OK:
                guard let url = savePanel.url else {
                    NSLog("Why would you do this")
                    break
                }
                self.beginExporting(to: url)
                
            default:
                Swift.print("🤷🏽‍♂️")
            }
        }
    }
    
    
    @discardableResult
    func beginImporting(from importUrl: URL?) -> Bool {
        guard let importedImage = importUrl.flatMap(Image.init(loading:)) else {
            return false
        }
        self.originalImage = importedImage
        self.fileURL = importUrl
        self.updateUi()
        return true
    }
    
    
    @discardableResult
    func beginImporting(from imageData: Data?) -> Bool {
        guard
            let imageData = imageData,
            let importedNsImage = NSImage(data: imageData)
            else {
            return false
        }
        self.originalImage = Image(nsImage: importedNsImage)
        self.fileURL = nil
        self.updateUi()
        return true
    }
    
    
    @discardableResult
    func beginImporting(from extractedDropItem: DragDropFileView.DraggedItemType.Extracted) -> Bool {
        switch extractedDropItem {
        case .fileByExtension(extension: _, let url),
             .fileByUti(uti: _, let url):
            return beginImporting(from: url)
            
        case .imageByUti(uti: _, let imageData):
            return beginImporting(from: imageData)
        }
    }
    
    
    private func updateUi() {
        if let originalImage = originalImage {
            
            imageWell?.image = originalImage.nsImage
            
            imageTitleTextField?.stringValue = originalImage.name
            let sizeInPixels = originalImage.nsImage.sizeInPixels
            imageDimensionsTextField?.stringValue = sizeInPixels.formattedAsPixelSize
            
            widthTextField?.cgFloatValue = sizeInPixels.width
            heightTextField?.cgFloatValue = sizeInPixels.height
            
            widthTextField?.isEnabled = true
            heightTextField?.isEnabled = true
            exportButton?.isEnabled = true
        }
        else {
            imageWell?.image = nil
            imageTitleTextField?.stringValue = "No Image Loaded"
            imageDimensionsTextField?.stringValue = ""
            widthTextField?.isEnabled = false
            heightTextField?.isEnabled = false
            exportButton?.isEnabled = false
        }
    }
    
    
    func beginExporting(to exportUrl: URL) {
        try! newData?.write(to: exportUrl, options: Data.WritingOptions.atomic)
    }
}



extension Document {
    
    var originalImageSize: NSSize? {
        return originalImage?.nsImage.sizeInPixels
    }
    
    
    var originalImageAspectRatio: CGFloat? {
        guard let currentImage = originalImage else {
            NSLog("No image from which to deduce an aspect ratio")
            return nil
        }
        
        return currentImage.nsImage.aspectRatio
    }
    
    
    var newData: Data? {
        guard let image = resizedImage else {
            NSLog("Could not resize image")
            return nil
        }
        
        guard let cgRef = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            NSLog("Cannot create CGImage")
            return Data()
        }
        
        let newRep = NSBitmapImageRep(cgImage: cgRef)
        newRep.size = image.size
        
        guard let pngRep = newRep.representation(using: .png, properties: [:]) else {
            NSLog("Cannot create PNG representation")
            return Data()
        }
        
        return pngRep
    }
    
    
    var resizedImage: NSImage? {
        guard let originalImage = originalImage else {
            NSLog("No original image to resize")
            return nil
        }
        
        guard let newSize = newSize else {
            NSLog("No new size; returning original")
            return originalImage.nsImage
        }
        
        return originalImage.nsImage.resized(to: newSize)
    }
    
    
    var newSize: NSSize? {
        guard
            let width = widthTextField?.cgFloatValue,
            let height = heightTextField?.cgFloatValue
            else {
                NSLog("Height and width text fields not loaded or have no value")
                return originalImageSize
        }
        return NSSize(width: width, height: height)
    }
    
    
    func newSizePreservingAspectRatio(width: CGFloat) -> NSSize? {
        return getOrLogAspectRatio.map { NSSize(width: width, aspectRatio: $0) }
    }
    
    
    func newSizePreservingAspectRatio(height: CGFloat) -> NSSize? {
        return getOrLogAspectRatio.map { NSSize(height: height, aspectRatio: $0) }
    }
    
    
    private var getOrLogAspectRatio: CGFloat? {
        guard let currentImageAspectRatio = originalImageAspectRatio else {
            NSLog("No current image aspect ratio")
            return nil
        }
        return currentImageAspectRatio
    }
}

