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
        exampleTwo()
    
    }
    
    func exampleOne() {
        var storage: [String] = []
        let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
        
        // Race Condition
        // Две задачи запущены асинхронно на параллельной очереди
        // Мы можем быть уверены только в том, что задача на добавление ячеек в storage запускается первее задачи,
        // В которой происходит изменение этих же ячеек в storage
        // Тут проблема в том, что вторая задача зависит от первой
        
        concurrentQueue.sync { // Выполняем первую задачу на очереди синхронно. Тем самым, блокируем ресурс storage до конца выполнения задачи.
            for i in 0...1000 {
                sleep(1)
                storage.append("Cell: \(i)")
            }
        }

        concurrentQueue.async { // Теперь эта задача выполняется строго после первой задачи, которая выполняется на параллельной очереди синхронно
            for i in 0...1000 {
                storage[i] = "Box: \(i)"
            }
        }
    }
    
    func exampleTwo() {
        print("a")
        // После того, как мы сделали вложенную очередь асинхронной, появился Race Condition
        // Основная очередь программы работает синхронно, вызывая "a" и "d", после чего вызываются асинхронно задачи c выводом в консоль "c" и "b"
        // Как решение проблемы, можно сделать очередь глобальной и вызвать выполнение задач синхронно
        DispatchQueue.global().sync {
            // Deadlock - взаимная блокировка
            // В главном очереди вызывается задача синхронно
            // Это означает, что очередь DispatchQueue.main.sync ожидает конца выполнения всей программы, чтобы потом вызвать задачу
            // Программа при этом не может выполниться до конца, так как у нее в очереди синхронная задача
            // В итоге, DispatchQueue.main.sync ожидает конца выполнения программы, и тут же сама программа пытается вызвать DispatchQueue.main.sync
            DispatchQueue.global().sync { // Решение проблемы - сделать DispatchQueue.main.sync синхронной
                print("b")
            }
            print("c")
            
        }
        print("d")
    }
}

