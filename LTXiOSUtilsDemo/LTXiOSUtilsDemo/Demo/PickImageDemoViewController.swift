//
//  PickImageDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/3/19.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import UIKit
import LTXiOSUtils
import SKPhotoBrowser
import TZImagePickerController
import Photos

class PickImageDemoViewController: BaseUIScrollViewController {

    let pickImageView = ImagePickGridView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "图片选择"
    }

    override func setScrollSubViews(contentView: UIView) {
        pickImageView.delegte = self
        pickImageView.maxImageCount = 6
        contentView.addSubview(pickImageView)
        pickImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}

extension PickImageDemoViewController: ImagePickGridViewDelegte {
    func frameChange(imagePickGridView: ImagePickGridView) {
        Log.d("frame变化\(imagePickGridView.frame.height)")
        Log.d(imagePickGridView.superview?.frame)
    }

    func addImage() {
        return pickImage()
    }

    func clickImage(imagePickGridView: ImagePickGridView, index: Int) {
        showImage(imagePickGridView: imagePickGridView, index: index)
    }
}

extension PickImageDemoViewController: TZImagePickerControllerDelegate {
    func pickImage() {
        let pickerController = TZImagePickerController(maxImagesCount:10, columnNumber:3, delegate:self, pushPhotoPickerVc: true)
        pickerController?.allowPickingVideo = false
        pickerController?.allowTakeVideo = false
        pickerController?.allowPickingGif = false
        pickerController?.sortAscendingByModificationDate = false
        pickerController?.allowPickingOriginalPhoto = false
        pickerController?.showSelectedIndex = true
        let arr = NSMutableArray()
        arr.addObjects(from: pickImageView.imageList.compactMap { $0.data })
        pickerController?.selectedAssets = arr
        pickerController?.didFinishPickingPhotosHandle = {photos,assets,isSelectOriginalPhoto in
            Log.d(photos)
            Log.d(assets)
            Log.d(isSelectOriginalPhoto)
            var imageList = [PickImageModel]()
            for (index,item) in assets!.enumerated() {
                let asset = item as! PHAsset
                let assetResource = PHAssetResource.assetResources(for: asset).first
                Log.d(assetResource)
//                Log.d(assetResource?.value(forKey: "filename"))
                Log.d(assetResource?.originalFilename)
                Log.d(assetResource?.assetLocalIdentifier)
                Log.d(assetResource?.type)
                Log.d(assetResource?.uniformTypeIdentifier)

                let image = PickImageModel(image: photos![index], id: assetResource?.assetLocalIdentifier, data: item)
                imageList.append(image)
            }
            self.pickImageView.addImage(imageArr: imageList)
        }
        self.present(pickerController!, animated: true)
    }
}

extension PickImageDemoViewController: SKPhotoBrowserDelegate {
    func showImage(imagePickGridView: ImagePickGridView, index: Int) {
        SKPhotoBrowserOptions.displayAction = false //动作按钮
        SKPhotoBrowserOptions.displayBackAndForwardButton = false //前进后退按钮
        SKPhotoBrowserOptions.displayDeleteButton = true //删除按钮

        var newImagesArr = [SKPhotoProtocol]()
        for imageInfo in imagePickGridView.imageList {
            let photo = SKPhoto.photoWithImage(imageInfo.image!)
            photo.contentMode = .scaleAspectFit
            newImagesArr.append(photo)
        }
        let browser = SKPhotoBrowser(photos:newImagesArr, initialPageIndex: index)
        browser.delegate = self
        self.present(browser, animated: true, completion:nil)
    }

    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        pickImageView.removeImage(index: index)
        reload()
    }
}
