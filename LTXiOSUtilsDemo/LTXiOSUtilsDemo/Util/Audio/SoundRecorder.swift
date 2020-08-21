//
//  SoundRecorder.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/8/15.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import AVFoundation

/// 错误类型
public enum SoundRecorderErrorType {
    /// 没有权限
    case noPermission
    /// 启动时已经正在录音
    case recording
    /// 启动出现错误
    case initError(message: String)
    /// 录音出现错误
    case recordError(message: String)
    /// 转码出现错误
    case encodeError(message: String)
}

/// 录音机状态
public enum SoundRecorderState {
    /// 启动成功
    case start
    /// 使用中
    case recording(currentTime: TimeInterval)
    /// 暂停
    case pause
    /// 停止
    case stop(audioPath: String)
    /// 删除
    case delete
    /// 结束，转码结束
    case finish(audioPath: String, mp3Path: String?)
}

/// 录音工具类代理
public protocol SoundRecorderDelegate: class {
    /// 状态改变
    /// - Parameter state: 状态类型
    func stateChange(state: SoundRecorderState)

    /// 出现错误
    /// - Parameter type: 错误类型
    func error(type: SoundRecorderErrorType)
}

/// 录音工具类
final public class SoundRecorder: NSObject {
    /// 单例
    public static let shared = SoundRecorder()

    /// 代理
    public weak var delegate: SoundRecorderDelegate?

    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?

    /// 文件目录
    private var recordDirectoryPath = ""
    /// 文件名
    private var fileName = ""
    /// 录音是否结束
    private var isEnd: Bool?
    /// 是否转mp3
    private var isToMp3: Bool?

    private var recordFilePath: String {
        return recordDirectoryPath + "/\(fileName)"
    }

    private var mp3FilePath: String {
        if fileName.contains(".") {
            return recordDirectoryPath + "/\(fileName.components(separatedBy: ".")[0]).mp3"
        } else {
            return recordDirectoryPath + "/\(fileName).mp3"
        }
    }

    private override init() {}

    private func initAudioRecorder(recordDirectoryPath: String, fileName: String) -> (result: Bool, message: String) {
        let session = AVAudioSession.sharedInstance()
        //初始化字典并添加设置参数
        let recorderSeetingsDic: [String: Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM), //音频格式，因为设置到可能需要mp3转码，所以将格式设置为pcm，其余格式转码工具不支持
            AVNumberOfChannelsKey: 2, //通道数，1为单声道，2为立体声
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue, //音频质量
            AVEncoderBitRateKey: 128000, //编码比特率
            AVSampleRateKey: 44100 //采样率，越高文件越大质量越好，标准的有8000、16000、22050、44100
        ]

        do {
            // 设置录音类型
            try session.setCategory(.playAndRecord)
            // 设置支持后台
            try session.setActive(true)
            // 设置存储路径
            if !FileManager.default.fileExists(atPath: recordDirectoryPath) {
                try FileManager.default.createDirectory(atPath: recordDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }
            let url = URL(fileURLWithPath: recordDirectoryPath).appendingPathComponent(fileName)
            // 初始化录音
            try audioRecorder = AVAudioRecorder(url: url, settings: recorderSeetingsDic)
            audioRecorder?.delegate = self
        } catch let error {
            Log.d(error.localizedDescription)
            return (false, error.localizedDescription)
        }
        return (true, "")
    }
}

// MARK: - 公开方法
public extension SoundRecorder {
    /// 开始录音
    /// - Parameter recordDirectoryPath: 录音文件保存文件夹路径
    /// - Parameter fileName: 文件名称
    /// - Parameter isToMp3: 是否转mp3，默认false
    func begin(recordDirectoryPath: String, fileName: String, isToMp3: Bool = false) {
        if audioRecorder?.isRecording ?? false {
            self.delegate?.error(type: .recording)
            return
        }

        self.recordDirectoryPath = recordDirectoryPath
        self.fileName = fileName
        self.isToMp3 = isToMp3

        let initAudioRecorderResult = initAudioRecorder(recordDirectoryPath: recordDirectoryPath, fileName: fileName)

        if initAudioRecorderResult.result {
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                if granted {
                    // 启用音频测量,启用后可以通过updateMeters方法更新测量值
                    self?.audioRecorder?.isMeteringEnabled = true
                    self?.audioRecorder?.record()
                    /// 当第一次获取权限弹出权限框时，当前不是主Runloop
                    DispatchQueue.main.async {
                        Log.d(self?.audioRecorder?.isRecording)
                        if self?.audioRecorder?.isRecording ?? false {
                            self?.delegate?.stateChange(state: .start)
                            self?.timer = Timer(timeInterval: 0.001, repeats: true) { [weak self] _ in
                                self?.delegate?.stateChange(state: .recording(currentTime: self?.audioRecorder?.currentTime ?? 0))
                            }
                            RunLoop.current.add(self!.timer!, forMode: .common)
                            self?.isEnd = false

                            if isToMp3 {
                                guard let strongSelf = self else { return }
                                DispatchQueue.global().async {
                                    LameUtil.convertWhenRecording(from: strongSelf.recordFilePath, mp3File: strongSelf.mp3FilePath, delegate: strongSelf)
                                }
                            }
                        } else {
                            self?.delegate?.error(type: .initError(message: "未知错误"))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.delegate?.error(type: .noPermission)
                    }
                }
            }
        } else {
            self.delegate?.error(type: .initError(message: initAudioRecorderResult.message))
        }
    }

    /// 暂停
    func pause() {
        if !(audioRecorder?.isRecording ?? false) {
            return
        }
        timer?.fireDate = Date.distantFuture
        audioRecorder?.pause()
        self.delegate?.stateChange(state: .pause)
        Log.d(audioRecorder?.isRecording)
    }

    /// 继续
    func resume() {
        if audioRecorder?.isRecording ?? false {
            return
        }
        timer?.fireDate = Date.distantPast
        audioRecorder?.record()
    }

    /// 结束
    func stop() {
        isEnd = true
        timer?.invalidate()
        audioRecorder?.stop()
    }

    /// 删除
    func delete() {
        stop()
        audioRecorder?.deleteRecording()
        self.delegate?.stateChange(state: .delete)
    }

    /// 录音分贝
    var level: Float {
        audioRecorder?.updateMeters()
        // 音量平均值
        let averageV = audioRecorder?.averagePower(forChannel: 0) ?? 0.0
        let peakPowerForChannel = pow(10, 0.015 * averageV)
        return peakPowerForChannel
    }

    /// 是否正在录音
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }

    /// 格式化时间
    /// - Parameter time: 时间，精确秒
    func formtTime(time: TimeInterval) -> String {
        let second = Int(time)
        return String(format: "%02d:%02d:%02d", second / 3600, (second % 3600) / 60, second % 3600 % 60)
    }
}

// MARK: - AVAudioRecorderDelegate
extension SoundRecorder: AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        Log.d("录音完成")
        delegate?.stateChange(state: .stop(audioPath: recordFilePath))
    }

    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        self.delegate?.error(type: .recordError(message: error?.localizedDescription ?? ""))
    }
}

extension SoundRecorder: LameUtilDelegate {
    public func convertFinish(_ audioFilePath: String!, mp3Path: String!) {
        Log.d("转码结束\(audioFilePath ?? "") \(mp3Path ?? "")")
        delegate?.stateChange(state: .finish(audioPath: audioFilePath, mp3Path: mp3Path))
    }

    public func getEndSign() -> Bool {
        return isEnd ?? true
    }

    public func convertError(_ message: String!) {
        Log.d("转码失败\(message ?? "")")
        delegate?.stateChange(state: .finish(audioPath: recordFilePath, mp3Path: nil))
        delegate?.error(type: .encodeError(message: message))
    }
}
