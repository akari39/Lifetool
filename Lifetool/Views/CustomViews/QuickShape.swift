//
//  QuickShape.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/2/27.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import SwiftUI

struct Indicator: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h), w)
        let tl = min(min(self.tl, h), w)
        let bl = min(min(self.bl, h), w)
        let br = min(min(self.br, h), w)
        
        path.move(to:CGPoint(x:-UIScreen.main.bounds.width,y:0))
        path.addLine(to: CGPoint(x:UIScreen.main.bounds.width,y:0))
        path.addLine(to: CGPoint(x:UIScreen.main.bounds.width,y:-3))
        path.addLine(to: CGPoint(x:-UIScreen.main.bounds.width,y:-3))
        path.addLine(to: CGPoint(x:-UIScreen.main.bounds.width,y:0))

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}

struct QuickShape: View {
    var body: some View {
        Indicator(tl: 0, tr: 0, bl: 100, br: 100)
            .fill(Color("ThemeColor"))
            .frame(width: 130, height: 25)
    }
}

struct QuickShape_Previews: PreviewProvider {
    static var previews: some View {
        QuickShape()
    }
}
