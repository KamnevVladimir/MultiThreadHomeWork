//
//  ViewController.swift
//  MultiThreadHomeWork
//
//  Created by Alexey Golovin on 19.02.2021.
//
/*

 Разберитесь в коде, указанном в данном примере.
 Вам нужно определить где конкретно реализованы проблемы многопоточности (Race Condition, Deadlock) и укажите их. Объясните, из-за чего возникли проблемы.
 Попробуйте устранить эти проблемы.
 Готовый проект отправьте на проверку. 
 
*/

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        exampleOne()
//        exampleTwo()
    
    }
    
    func exampleOne() {
        var storage: [String] = []
        let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
        
        concurrentQueue.async {
            for i in 0...1000 {
                sleep(1)
                storage.append("Cell: \(i)")
            }
        }

        concurrentQueue.async {
            for i in 0...1000 {
                storage[i] = "Box: \(i)"
            }
        }
    }
    
    func exampleTwo() {
        print("a")
        DispatchQueue.main.async {
            DispatchQueue.main.sync {
                print("b")
            }
            print("c")
        }
        print("d")
    }
}

