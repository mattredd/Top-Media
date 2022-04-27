//
//  CreditList.swift
//  Top Media
//
//  Created by Matthew Reddin on 22/03/2022.
//

import SwiftUI

struct CreditList: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var creditListVM: CreditListViewModel
    let imageSize = CGSize(width: 80, height: 100)
    
    var body: some View {
        if let creditList = creditListVM.creditList, let castMembers = creditList.cast, let crewMembers = creditList.crew  {
            List {
                Section("Cast") {
                    ForEach(castMembers.indices, id: \.self) { indx in
                        let castMember = castMembers[indx]
                        HStack {
                            if let path = creditListVM.imagePaths?.cast[indx], let url = URL(string: path) {
                                AsyncImage(url: url) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: imageSize.width, height: imageSize.height)
                                .cornerRadius(UIConstants.compactCornerRadius)
                            } else {
                                RoundedRectangle(cornerRadius: UIConstants.compactCornerRadius)
                                    .fill(.blue.opacity(0.5))
                                    .frame(width: imageSize.width, height: imageSize.height)
                            }
                            VStack(alignment: .leading) {
                                Text(castMember.name ?? "")
                                Text(castMember.character ?? "")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let cast = creditListVM.creditList?.cast?[indx] {
                                dismiss()
                                if let id = cast.id {
                                    creditListVM.coordinator.selectPerson(id: id)
                                }
                            }
                        }
                    }
                }
                .headerProminence(.increased)
                Section("Crew") {
                    ForEach(crewMembers.indices, id: \.self) { indx in
                        let crewMember = crewMembers[indx]
                        HStack {
                            if let path = creditListVM.imagePaths?.crew[indx], let url = URL(string: path) {
                                AsyncImage(url: url) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: imageSize.width, height: imageSize.height)
                                .cornerRadius(UIConstants.compactCornerRadius)
                            } else {
                                RoundedRectangle(cornerRadius: UIConstants.compactCornerRadius)
                                    .fill(.red)
                                    .frame(width: imageSize.width, height: imageSize.height)
                            }
                            VStack(alignment: .leading) {
                                Text(crewMember.name ?? "-")
                                Text(crewMember.job ?? "-")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .headerProminence(.increased)
            }
        } else {
            Text("Unable to display cast")            
        }
    }
}
