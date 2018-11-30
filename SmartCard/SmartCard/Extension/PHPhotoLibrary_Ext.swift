//
//  PHPhotoLibrary_Ext.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/27.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation
import PhotosUI
import RxSwift

extension PHPhotoLibrary {
    static var isAuthorized: Observable<Bool> {
        return Observable.create({ observer in
            if authorizationStatus() == .authorized {
                observer.onNext(true)
                observer.onCompleted()
            } else {
                observer.onNext(false)
                requestAuthorization({ status in
                    observer.onNext(status == .authorized)
                    observer.onCompleted()
                })
            }
            return Disposables.create()
        })
    }
}


