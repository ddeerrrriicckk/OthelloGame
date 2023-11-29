//
//  ScoreView.swift
//  OthelloGame
//
//

import SwiftUI

struct ScoreView: View {
    @ObservedObject var viewModel: OthelloViewModel

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width * 0.9)
            HStack {
                Text("Light: \(viewModel.lightScore)")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.leading)
                Spacer()
                Text("Dark: \(viewModel.darkScore)")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.trailing)
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(viewModel: OthelloViewModel())
    }
}
