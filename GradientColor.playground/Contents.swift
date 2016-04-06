//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let colors = [

    UIColor(red: 1, green: 0, blue: 0, alpha: 1),
    UIColor(red: 1, green: 1, blue: 0, alpha: 1),
    UIColor(red: 0, green: 1, blue: 0, alpha: 1),
    UIColor(red: 0, green: 1, blue: 1, alpha: 1),
    UIColor(red: 0, green: 0, blue: 1, alpha: 1),
    UIColor(red: 1, green: 0, blue: 1, alpha: 1),
    UIColor(red: 1, green: 0, blue: 0, alpha: 1),
]

let size = CGSize(width: 50, height: 50)
let img = ovalgradientImage(size, colors: colors)

let lineSize = CGSize(width: 200, height: 15)
let lineImg = lineGradientImage(lineSize, colors: colors)