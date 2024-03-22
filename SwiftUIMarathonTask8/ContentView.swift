//
//  ContentView.swift
//  SwiftUIMarathonTask8
//
//  Created by Sergei Semko on 3/20/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .blur(radius: 3)
                .ignoresSafeArea()
            CustomSlider()
        }
    }
}

struct CustomSlider: View {
    
    @State var bottomExpanded: Bool = false
    @State var topExpanded: Bool = false
    @State var lastProgress: CGFloat = 0
    @State var curProgress: CGFloat = 0.5
    
    private var changedWidth: CGFloat {
        (bottomExpanded || topExpanded) ? 95 : 100
    }

    private var changedHeight: CGFloat {
        (bottomExpanded || topExpanded) ? 315 : 300
    }
    
    private var yBottomOffset: CGFloat {
        bottomExpanded ? 10 : 0
    }
    
    private var yTopOffset: CGFloat {
        topExpanded ? -10 : 0
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(.ultraThinMaterial)
            .overlay(alignment: .bottom, content: {
                Rectangle()
                    .fill(.white)
                    .scaleEffect(y: curProgress, anchor: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            })
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let startY = value.startLocation.y
                        let curY = value.location.y
                        let offset = startY - curY
                        var progress = (offset / 300) + lastProgress
                        
                        withAnimation {
                            if progress < 0 {
                                bottomExpanded = true
                            } else {
                                bottomExpanded = false
                            }
                            
                            if progress > 1 {
                                topExpanded = true
                            } else {
                                topExpanded = false
                            }
                        }
                        curProgress = max(min(1, progress), 0)
                    })
                    .onEnded({ value in
                        withAnimation {
                            topExpanded = false
                            bottomExpanded = false
                            lastProgress = curProgress
                        }
                        
                    })
            )
            .frame(width: changedWidth, height: changedHeight)
            .offset(y: yBottomOffset)
            .offset(y: yTopOffset)
    }
}

#Preview {
    ContentView()
}
