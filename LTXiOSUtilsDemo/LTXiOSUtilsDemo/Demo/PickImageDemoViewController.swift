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

    private lazy var pickImageView: ImagePickGridView = {
        let pickImageView = ImagePickGridView()
        return pickImageView
    }()

    private lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.text = "    0/\(maxImageCount)"
        countLabel.backgroundColor = .lightGray
        return countLabel
    }()

    private let maxImageCount = 6

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "图片选择"
        let rightBarItem = UIBarButtonItem(title: "上传", style: .plain, target: self, action: #selector(upload))
        navigationItem.rightBarButtonItem = rightBarItem
    }

    override func setContentViewSubViews(contentView: UIView) {
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(30)
        }

        pickImageView.delegte = self
        pickImageView.colCount = 3
        pickImageView.maxImageCount = maxImageCount
        contentView.addSubview(pickImageView)
        pickImageView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}

extension PickImageDemoViewController {
    @objc
    private func upload() {
        if pickImageView.imageList.count <= 0 {
            HUD.showText("请选择图片")
            return
        }

        var requestParam = RequestParam(path: NetworkConstant.ER.erMobileCommonUploadFile)
        requestParam.parameters = [
            "sourceId": "20032300000001",
            "sourceType": "ErTravel"
        ]
        requestParam.fileList = pickImageView.imageList.compactMap { FileInfo(name: $0.name ?? "", data: $0.image!.jpegData(compressionQuality: 1)!) }
        Log.d(requestParam.fileList?[0].size)
        Log.d(requestParam.fileList?[0].type)
        NetworkManager.sendRequest(requestParam: requestParam) { data in
            Log.d(JSON(data))
        }
    }
}

extension PickImageDemoViewController: ImagePickGridViewDelegte {
    func frameChange(imagePickGridView: ImagePickGridView) {
        Log.d("frame变化\(imagePickGridView.frame.height)")
        Log.d(imagePickGridView.superview?.frame)
    }

    func addImage(imagePickGridView: ImagePickGridView) {
        return pickImage()
    }

    func clickImage(imagePickGridView: ImagePickGridView, index: Int) {
        showImage(imagePickGridView: imagePickGridView, index: index)
    }

    func imageCountChange(imagePickGridView: ImagePickGridView, count: Int) {
        countLabel.text = "    \(count)/\(maxImageCount)"
    }
}

extension PickImageDemoViewController: TZImagePickerControllerDelegate {
    func pickImage() {
        let pickerController = TZImagePickerController(maxImagesCount: 10, columnNumber: 3, delegate: self, pushPhotoPickerVc: true)
        pickerController?.allowPickingVideo = false
        pickerController?.allowTakeVideo = false
        pickerController?.allowPickingGif = false
        pickerController?.sortAscendingByModificationDate = false
        pickerController?.allowPickingOriginalPhoto = false
        pickerController?.showSelectedIndex = true
        let arr = NSMutableArray()
        arr.addObjects(from: pickImageView.imageList.compactMap { $0.data })
        pickerController?.selectedAssets = arr
        pickerController?.didFinishPickingPhotosHandle = {photos, assets, isSelectOriginalPhoto in

            guard let images = photos else {
                return
            }
            var imageList = [PickImageModel]()
            for (index, item) in images.enumerated() {
                if let assetArr = assets, assetArr.count > index, let asset = assetArr[index] as? PHAsset {
                    let assetResource = PHAssetResource.assetResources(for: asset).first
                    Log.d(assetResource)
                    Log.d(assetResource?.originalFilename)
                    Log.d(assetResource?.assetLocalIdentifier)
                    Log.d(assetResource?.type)
                    Log.d(assetResource?.uniformTypeIdentifier)

                    let image = PickImageModel(image: item, id: assetResource?.assetLocalIdentifier, data: asset)
                    image.name = assetResource?.originalFilename
                    image.type = ".\(String(describing: assetResource?.uniformTypeIdentifier.split(separator: ".").last))"
                    imageList.append(image)
                } else {
                    let image = PickImageModel(image: item)
                    imageList.append(image)
                }
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
        SKPhotoBrowserOptions.displayStatusbar = true

        var newImagesArr = [SKPhotoProtocol]()
        for imageInfo in imagePickGridView.imageList {
            let photo = SKPhoto.photoWithImage(imageInfo.image!)
            photo.contentMode = .scaleAspectFit
            newImagesArr.append(photo)
        }
        let browser = SKPhotoBrowser(photos: newImagesArr, initialPageIndex: index)
        browser.delegate = self
        self.present(browser, animated: true, completion: nil)
    }

    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        pickImageView.removeImage(index: index)
        reload()
    }
}
