//
//  WheelShape.swift
//  iPod
//
//  Created by Eric Groom on 2/14/21.
//

import SwiftUI

public struct WheelView: View {

    public let userInput: (ClickWheelInput) -> ()
    
    public init(userInput: @escaping (ClickWheelInput) -> ()) {
        self.userInput = userInput
    }

    private let angleForTick = Angle(radians: Double.pi/8)
    @State private var startPoint: CGPoint?

    private let wheelCoordSpace = "wheelSpace"

    public var body: some View {
        GeometryReader { geometry in
            /*
             Mild hack to get dragging on the wheel and clicking buttons working simultaneously:
             You can think of it working conceptually as 4 wedge shaped buttons that form a circle
             and a ring that lays underneath them which accept drag events. Now that doesn't actually work,
             since a view behind a button won't receive touch events, so instead each wedge button gets
             a drag gesture in the coordinate space of a wheel.
             */
            let drag = DragGesture(minimumDistance: 5.0, coordinateSpace: .named(wheelCoordSpace))
                .onChanged { dragValue in
                    dragUpdated(geometry: geometry, dragValue: dragValue)
                }
                .onEnded { dragValue in
                    dragEnded(dragValue)
                }
            let thickness = self.thickness(for: geometry)
            
            ZStack {
                // WheelShape is not actually displayed as it is covered by WedgeButtons, however it serves
                // as a coordinate space and represents the overall shape of the WedgeButtons
                WheelShape(thickness: thickness)
                    .coordinateSpace(name: wheelCoordSpace)
                WedgeButton(edge: .top, thickness: thickness, action: { userInput(.menu) }) {
                    Text("Menu")
                        .font(Font.system(size: 18, weight: .bold, design: .default).smallCaps())
                }
                    .highPriorityGesture(drag)
                WedgeButton(edge: .right, thickness: thickness, action: { userInput(.skip) }) {
                    Image(systemName: "forward.end.alt.fill")
                }
                    .highPriorityGesture(drag)
                WedgeButton(edge: .bottom, thickness: thickness, action: { userInput(.pause) }) {
                    Image(systemName: "playpause.fill")
                }
                    .highPriorityGesture(drag)
                WedgeButton(edge: .left, thickness: thickness, action: { userInput(.back) }) {
                    Image(systemName: "backward.end.alt.fill")
                }
                    .highPriorityGesture(drag)
                circleButton(for: geometry)
            }
                .foregroundColor(.white)
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
    
    private func dragUpdated(geometry: GeometryProxy, dragValue: DragGesture.Value) {
        let startPoint = self.startPoint ?? dragValue.startLocation
        self.startPoint = startPoint
        
        let mCircle = circle(for: geometry)
        
        let start = mCircle.nearestPoint(to: startPoint)
        let end = mCircle.nearestPoint(to: dragValue.location)
        let startR = mCircle.radians(to: start)
        let endR = mCircle.radians(to: end)
        
        // https://stackoverflow.com/a/2007279
        let signedDiff = atan2(sin(endR.radians - startR.radians), cos(endR.radians - startR.radians))
        
        if fabs(fabs(signedDiff) - angleForTick.radians) < 0.1 {
            let direction: DragDirection = signedDiff > 0 ? .counterClockwise : .clockwise
            userInput(.drag(direction))
            // TODO: should adjust by the remainder
            self.startPoint = dragValue.location
        }
    }
    
    private func dragEnded(_ dragValue: DragGesture.Value) {
        startPoint = nil
    }
    
    private func circle(for geometry: GeometryProxy) -> MCircle {
        let frame = geometry.frame(in: .local)
        let squaredFrame = frame.squareRect
        let thickness = self.thickness(for: geometry)
        return MCircle(center: squaredFrame.center, radius: (squaredFrame.width / 2) - (thickness / 2))
    }
    
    private func circleButton(for geometry: GeometryProxy) -> some View {
        let squareRect = geometry.frame(in: .local).squareRect
        let thickness = self.thickness(for: geometry)
        let inset = squareRect.insetBy(dx: thickness, dy: thickness)
        
        return Button(action: { userInput(.centerButton) }, label: {
            Color("chassisPrimary")
                .frame(width: inset.width, height: inset.height, alignment: .center)
                .clipShape(Circle())
        })
    }
    
    private func thickness(for geometry: GeometryProxy) -> CGFloat {
        let circleFrame = geometry.frame(in: .local).squareRect
        return circleFrame.width / 3
    }
}

struct WheelView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            WheelView(userInput: { _ in })
                .padding()
        }
    }
}
