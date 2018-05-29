//
//  AppDelegate.swift
//  iOSnier
//
//  Created by fox on 2018/3/21.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    public func DispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->())
    {
        if repeatCount <= 0 {
            return
        }
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = repeatCount
        timer.schedule(wallDeadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count == 0 {
                timer.cancel()
            }
        })
        timer.resume()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        
//        UIFont.familyNames.map{
//            UIFont.fontNames(forFamilyName: $0).map{
//                print($0)
//            }
//        }
        
//        let ob : Observable<Int> = Observable.of(0,1,2,3)
//        
//        ob.subscribe { (x) in
//            print(x.element!)
//        }
        
        test3()
        
//        DispatchTimer(timeInterval: 1, repeatCount: 100) { (timer, count) in
//            print("hiiiiii")
//        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


func  test() {
    let observable = Observable<Any>.never()
    func loadText()->Single<String> {
        return Single.create { (s) -> Disposable in
            return Disposables.create()
        }
    }
    
    
    observable
        .subscribe(
            onNext: { element in
                print(element)
        },
            onCompleted: {
                print("Completed")
        }
    )
}

func test2() {
    let subject = PublishSubject<String>()
    let subscriptionOne = subject.subscribe { (s) in
        print(s.element!)
    }
    subscriptionOne.dispose()
    subject.onNext("send a message")
}

func  test3() {
    let subject = ReplaySubject<String>.create(bufferSize: 3)
    let disposebag = DisposeBag()
    
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    subject.subscribe {
        print("1)",$0.element!)
    }.disposed(by: disposebag)
    
    subject.subscribe {
        print("2)",$0.element!)
        }.disposed(by: disposebag)
    
    subject.onNext("4")
    
    subject.subscribe {
        print("3)",$0.element!)
        }.disposed(by: disposebag)
}

