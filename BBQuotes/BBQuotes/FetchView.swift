//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Tom Molinaro on 10/11/25.
//

import SwiftUI

struct FetchView: View {
    
    // give us access to properties and methods of ViewModel
    let vm = ViewModel()
   
    // I don't know why this isn't var since it will be changing, no?
    let show: String
    
    @State var showCharacterInfo = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.removeCaseAndSpace())
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                    
                VStack {
                    // Forces the 2 spacers to take up all the space of the parent view, therefore leaving minimal space for the button, and furthermore, pushing the button to the bottom of the screen
                    VStack{
                        Spacer(minLength:60)
                        
                        switch vm.status {
                        case .notStarted:
                            EmptyView()
                            
                        case .fetching:
                            ProgressView()
                            
                        case .successQuote:
                            Text("\"\(vm.quote.quote)\"")
                                // will scale down as much as 50% to make room for excessive text
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius:25))
                                .padding(.horizontal)
                            
                            CharacterCard(vm: vm, width: geo.size.width,
                                          height: geo.size.height, showCharacterInfo: $showCharacterInfo)
                            
                        case .successEpisode:
                            EpisodeView(episode: vm.episode)
                        
                        case .successCharacter:
                            CharacterCard(vm: vm, width: geo.size.width,
                                          height: geo.size.height, showCharacterInfo: $showCharacterInfo)
                            
                        case .failed(let error):
                            Text(error.localizedDescription)
                        }
                                                
                        Spacer(minLength:20)
                    }
                            
                    HStack {
                        FetchButton(title: "Get \nRandom \nQuote", colorBaseName: show.removeSpaces()) {
                            await vm.getQuoteData(for: show)
                        }
                        
                        Spacer()
                        
                        FetchButton(title: "Get \nRandom \nEpisode", colorBaseName: show.removeSpaces()) {
                            await vm.getEpisode(for: show)
                        }
                        
                        Spacer()
                        
                        FetchButton(title: "Get \nRandom \nCharacter", colorBaseName: show.removeSpaces()) {
                            await vm.getRandomCharacterData(for: show)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer(minLength: 95)
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .toolbarBackgroundVisibility(.visible, for: .tabBar)
        .sheet(isPresented: $showCharacterInfo) {
            CharacterView(character: vm.character, show: show)
        }
        .task {
            await vm.getQuoteData(for: show)
        }
    }
}

#Preview {
//    QuoteView(show: Constants.bbName)
    FetchView(show: Constants.bcsName)
        .preferredColorScheme(.dark)
}

struct FetchButton: View {
    let title: String
    let colorBaseName: String
    let action: () async -> Void   // async closure so you can call async ViewModel methods

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color("\(colorBaseName)Button").opacity(0.75))
                .clipShape(.rect(cornerRadius: 10))
                .shadow(color: Color("\(colorBaseName)Shadow"), radius: 5)
        }
    }
}

struct CharacterCard: View {
    let vm: ViewModel
    let width: CGFloat
    let height: CGFloat
    @Binding var showCharacterInfo: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: vm.character.randomImage) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: width/1.1, height: height/1.8)
            
            Text(vm.character.name)
                .foregroundStyle(.white)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .fontWeight(.bold)
        }
        .frame(width: width/1.1, height: height/1.8)
        .clipShape(.rect(cornerRadius: 50))
        .onTapGesture {
            showCharacterInfo.toggle()
        }
    }
}
