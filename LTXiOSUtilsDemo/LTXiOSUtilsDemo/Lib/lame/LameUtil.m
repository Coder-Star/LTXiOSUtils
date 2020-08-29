//
//  LameUtil.m
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/8/20.
//  Copyright © 2020 李天星. All rights reserved.
//

#import "LameUtil.h"
#import <lame/lame.h>

@implementation LameUtil

+ (void) convertWhenRecordingFrom:(NSString *)audioFilePath mp3File:(NSString *)mp3FilePath delegate:(id<LameUtilDelegate>) delegate {
    int read,write;

    FILE *pcm = fopen([audioFilePath cStringUsingEncoding:1], "rb");
    fseek(pcm, 4*1024, SEEK_CUR);

    FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");

    const int PCM_SIZE = 16*1024;
    const int MP3_SIZE = 16*1024;
    short int pcm_buffer[PCM_SIZE * 2];
    unsigned char mp3_buffer[MP3_SIZE];

    lame_t lame = lame_init();
    //通道
    lame_set_num_channels(lame,2);
    //采样率
    lame_set_in_samplerate(lame, 44100);
    //比特率
    lame_set_brate(lame, 128);
    //音质0~9 0最好
    lame_set_quality(lame, 0);
    lame_init_params(lame);

    long curpos;
    BOOL isSkipPCMHeader = NO;
    long startPos = 0;
    long endPos = 0;

    @try {
        do {
            curpos = ftell(pcm);
            startPos = ftell(pcm);
            fseek(pcm, 0,SEEK_END);
            endPos = ftell(pcm);
            long length = endPos - startPos;
            fseek(pcm, curpos,SEEK_SET);
            if(length > PCM_SIZE * 2 *sizeof(short int)) {
                if(!isSkipPCMHeader) {
                    fseek(pcm, 4 * 1024,SEEK_SET);
                    isSkipPCMHeader =YES;
                }
                read = (int)fread(pcm_buffer, 2 *sizeof(short int), PCM_SIZE, pcm);
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                fwrite(mp3_buffer, write, 1, mp3);
                startPos = 0;
                endPos = 0;
            } else {
                // 不知道为什么需要休眠，但是得到了效果是会降低CPU使用率
                [NSThread sleepForTimeInterval:0.05];
            }
        } while (![delegate getEndSign]);

        // 解决有可能最后短暂时间的录音没有转码
        if (endPos - startPos > 0) {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read != 0) {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                fwrite(mp3_buffer, write, 1, mp3);
            }
        }

        read = (int)fread(pcm_buffer, 2 *sizeof(short int), PCM_SIZE, pcm);
        write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
        lame_close(lame);
        fclose(pcm);
        fclose(mp3);
    }
    @catch (NSException *exception) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate convertError:exception.description];
        });
        mp3FilePath = nil;
    }
    @finally {
        if (mp3FilePath && mp3FilePath.length > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate convertFinish:audioFilePath mp3Path:mp3FilePath];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate convertError:@"未知错误"];
            });
        }
    }
}

+ (void) convertWhenRecordedFrom:(NSString *)audioFilePath mp3File:(NSString *)mp3FilePath delegate:(id<LameUtilDelegate>) delegate {
    @try {

        int read, write;
        FILE *pcm = fopen([audioFilePath cStringUsingEncoding:1], "rb");
        fseek(pcm, 4*1024, SEEK_CUR); //跳过文件头
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");

        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];

        lame_t lame = lame_init();
        lame_set_num_channels(lame,2);
        lame_set_in_samplerate(lame, 44100);
        lame_set_brate(lame, 128);
        lame_set_quality(lame, 0);
        lame_init_params(lame);

        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0) {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            }
            else {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);

        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate convertError:exception.description];
        });
        mp3FilePath = nil;
    }
    @finally {
        if (mp3FilePath && mp3FilePath.length > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate convertFinish:audioFilePath mp3Path:mp3FilePath];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate convertError:@"未知错误"];
            });
        }
    }
}


@end
