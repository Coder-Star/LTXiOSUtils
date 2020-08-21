//
//  AudioAndRecordViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/8/19.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils
import AVFoundation

class AudioAndRecordViewController: BaseUIViewController {

    private let soundRecorder = SoundRecorder.shared

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.separatorInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    private lazy var recordButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        button.setTitle("开始", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(.red, for: .normal)
        return button
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private lazy var finishButton: UIButton = {
        let finishButton = UIButton()
        finishButton.isHidden = true
        finishButton.setTitle("完成", for: .normal)
        return finishButton
    }()

    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/ConferenceRecord"

    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AudioAndRecord"
        initUI()

        let rightButton = UIBarButtonItem(title: "清空", style: .plain, target: self, action: #selector(clear))
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc
    func clear() {
        try? FileManager.default.removeItem(atPath: path)
        tableView.reloadData()
    }

    func initUI() {
        let recordView = UIView()
        recordView.backgroundColor = .black
        baseView.addSubview(recordView)
        recordView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(100)
        }

        recordButton.addTarget(self, action: #selector(recordAction(_:)), for: .touchUpInside)
        recordView.addSubview(recordButton)
        recordButton.layer.cornerRadius = 20
        recordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }

        recordView.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(recordButton.snp.top).offset(-10)
        }

        recordView.addSubview(finishButton)
        finishButton.addTarget(self, action: #selector(finish), for: .touchUpInside)
        finishButton.setTitleColor(AppTheme.mainColor, for: .normal)
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        finishButton.snp.makeConstraints { make in
            make.centerY.equalTo(recordButton)
            make.right.equalToSuperview().offset(-20)
        }

        baseView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(recordView.snp.top)
        }
    }

    @objc
    func recordAction(_ sender: UIButton) {
        Log.d(sender.currentTitle)
        switch sender.currentTitle ?? "" {
        case "开始":
            soundRecorder.begin(recordDirectoryPath: path, fileName: "\(Date().tx.formatDate(format: .YMDHMS)).caf", isToMp3: true)
            soundRecorder.delegate = self
        case "继续":
            soundRecorder.resume()
        case "暂停":
            soundRecorder.pause()
        default:
            break
        }
    }

    @objc
    func finish() {
        soundRecorder.stop()
    }

    private func getFileList() -> [(name: String, path: String)] {
        var result: [(name: String, path: String)] = []
        let array = (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? []
        for fileName in array {
            let fullPath = "\(path)/\(fileName)"
            if FileManager.default.fileExists(atPath: fullPath) {
                result.append((name: fileName, path: fullPath))
            }
        }
        return result
    }
}

extension AudioAndRecordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getFileList().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = getFileList()[indexPath.row].name
        cell.detailTextLabel?.text = getFileList()[indexPath.row].path
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
}

extension AudioAndRecordViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = getFileList()[indexPath.row].path
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        player = try? AVAudioPlayer.init(contentsOf: URL(fileURLWithPath: path))
        Log.d(player)
        player?.play()
    }
}

extension AudioAndRecordViewController: SoundRecorderDelegate {
    func stateChange(state: SoundRecorderState) {
        switch state {
        case .start:
            self.finishButton.isHidden = false
            self.timerLabel.isHidden = false
        case .recording(let currentTime):
            recordButton.setTitle("暂停", for: .normal)
            self.timerLabel.text = self.soundRecorder.formtTime(time: currentTime)
        case .pause:
            recordButton.setTitle("继续", for: .normal)
        case .stop:
            finishButton.isHidden = true
            timerLabel.isHidden = true
            recordButton.setTitle("开始", for: .normal)
            HUD.showWait(title: "正在保存...")
        case .delete:
            break
        case .finish:
            HUD.hide()
            HUD.showText("保存成功")
            tableView.reloadData()
        }
    }

    func error(type: SoundRecorderErrorType) {
        switch type {
        case .noPermission:
            HUD.showText("请在“设置-隐私-麦克风”中允许访问麦克风")
        case .recording:
            HUD.showText("正在录音")
        case .initError(let message):
            HUD.showText("初始化录音失败\(message)")
        case .recordError(let message):
            HUD.showText("录音出现错误\(message)")
        case .encodeError(let message):
            HUD.showText("转码失败\(message)")
        }
    }
}
