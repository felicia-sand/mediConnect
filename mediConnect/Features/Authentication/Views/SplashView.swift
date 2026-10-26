// SplashView.swift
// MediConnect — Features/Authentication/Views
//
// Initial splash and session verification screen matching Figma specifications.

import SwiftUI

struct SplashView: View {
    
    @State private var isAnimating: Bool = false
    
    init() {}
    
    public var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Centered Deep Teal Brand Logo
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.mcTeal)
                        .frame(width: 76, height: 76)
                        .shadow(color: Color.mcTeal.opacity(0.3), radius: 12, x: 0, y: 6)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(.white)
                }
                .scaleEffect(isAnimating ? 1.0 : 0.85)
                .opacity(isAnimating ? 1.0 : 0.0)
                
                // App Title
                Text("MediConnect")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.mcTextPrimary)
                    .opacity(isAnimating ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
}

#if DEBUG
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
#endif
