import SwiftUI
import CoreData

/**
 * A generic list view supporting grouping, sorting, selecting, editing, moving, and deleting
 * entities from a sectioned fetch request in a navigation view context.
 */
struct CustomListView<
    Entity: NSManagedObject,
    EntityRowView: View,
    EntityPageView: View,
    ConstantListPrefixView: View,
    ConstantListSuffixView: View,
    AddEntitySheetContentView: View,
    EditParentSheetContentView: View,
    BulkEditSheetContentView: View,
    BulkMoveSheetContentView: View
>: View {
    @SectionedFetchRequest var entities: SectionedFetchResults<String, Entity>
    @Binding var searchQuery: String
    @Binding var selectedSort: Sort<Entity>
    var sortOptions: [Sort<Entity>]
    var entityRowViewBuilder: (Entity) -> EntityRowView
    var entityPageViewBuilder: (Entity) -> EntityPageView
    var constantListPrefixViewBuilder: (() -> ConstantListPrefixView)? = nil
    var constantListSuffixViewBuilder: (() -> ConstantListSuffixView)? = nil
    var addEntitySheetContentViewBuilder: (() -> AddEntitySheetContentView)? = nil
    var editParentSheetContentViewBuilder: (() -> EditParentSheetContentView)? = nil
    var bulkEditSheetContentViewBuilder: ((Set<Entity>) -> BulkEditSheetContentView)? = nil
    var bulkMoveSheetContentViewBuilder: ((Set<Entity>) -> BulkMoveSheetContentView)? = nil
    var bulkDeleteFunction: ((Set<Entity>) -> Void)? = nil
    var bulkDeleteAlertMessage: String = "This action cannot be undone!"

    @State private var selectedEntities: Set<Entity> = []
    @State private var inSelectionMode: Bool = false
    @State private var showAddEntityView: Bool = false
    @State private var showEditParentView: Bool = false
    @State private var showBulkEditView: Bool = false
    @State private var showBulkMoveView: Bool = false
    @State private var showBulkDeleteAlert: Bool = false

    private func invertSelection() {
        entities.forEach({ section in
            section.forEach({ entity in
                if selectedEntities.contains(entity) {
                    selectedEntities.remove(entity)
                } else {
                    selectedEntities.update(with: entity)
                }
            })
        })
    }

    var body: some View {
        List {
            if constantListPrefixViewBuilder != nil {
                constantListPrefixViewBuilder!()
            }
            ForEach(entities) { section in
                CustomListSectionView(
                    section: section,
                    selectedEntities: $selectedEntities,
                    inSelectionMode: inSelectionMode,
                    entityRowViewBuilder: entityRowViewBuilder,
                    entityPageViewBuilder: entityPageViewBuilder
                )
            }
            if constantListSuffixViewBuilder != nil {
                constantListSuffixViewBuilder!()
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchQuery)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if inSelectionMode {
                    let disabled: Bool = selectedEntities.isEmpty
                    if bulkEditSheetContentViewBuilder != nil {
                        Button { showBulkEditView = true }
                            label: { Text("Edit") }.disabled(disabled)
                    }
                    if bulkMoveSheetContentViewBuilder != nil {
                        Button { showBulkMoveView = true }
                            label: { Text("Move") }.disabled(disabled)
                    }
                    if bulkDeleteFunction != nil {
                        Button { showBulkDeleteAlert = true }
                            label: { Text("Delete") }.disabled(disabled)
                    }
                    Button { invertSelection() } label: { Text("Invert") }
                } else {
                    CustomListSortSelectView<Entity>(
                        selectedSort: $selectedSort,
                        sortOptions: sortOptions
                    )
                    if addEntitySheetContentViewBuilder != nil {
                        Button { showAddEntityView = true } label: { Text("Add") }
                    }
                    if editParentSheetContentViewBuilder != nil {
                        Button { showEditParentView = true } label: { Text("Edit") }
                    }
                }
                Button {
                    if inSelectionMode { selectedEntities = [] }
                    inSelectionMode.toggle()
                } label: {
                    Text(inSelectionMode ? "Done" : "Select")
                }
            }
        }
        .sheet(isPresented: $showAddEntityView ) {
            // Only renders when addEntitiesheetContentViewBuilder != nil
            addEntitySheetContentViewBuilder!()
        }
        .sheet(isPresented: $showEditParentView ) {
            // Only renders when editParentSheetContentViewBuilder != nil
            editParentSheetContentViewBuilder!()
        }
        .sheet(isPresented: $showBulkEditView ) {
            // Only renders when bulkEditSheetContentViewBuilder != nil
            bulkEditSheetContentViewBuilder!(selectedEntities)
        }
        .sheet(isPresented: $showBulkMoveView ) {
            // Only renders when bulkMoveSheetContentViewBuilder != nil
            bulkMoveSheetContentViewBuilder!(selectedEntities)
        }
        .alert(isPresented: $showBulkDeleteAlert) {
            // Only renders when bulkDeleteFunction != nil
            Alert(
                title: Text("Are you sure?"),
                message: Text(bulkDeleteAlertMessage),
                primaryButton: .destructive(Text("Yes, delete")) {
                    withAnimation {
                        bulkDeleteFunction!(selectedEntities)
                        selectedEntities = []
                    }
                },
                secondaryButton: .cancel(Text("No, cancel"))
            )
        }
    }
}

struct CustomListSelectionIcon: View {
    var isSelected: Bool

    var body: some View {
        Image(
            systemName: isSelected
                ? "checkmark.circle.fill"
                : "checkmark.circle"
        )
    }
}

struct CustomListSectionView<
    Entity: NSManagedObject,
    EntityRowView: View,
    EntityPageView: View
>: View {
    var section: SectionedFetchResults<String, Entity>.Section
    @Binding var selectedEntities: Set<Entity>
    var inSelectionMode: Bool
    var entityRowViewBuilder: (Entity) -> EntityRowView
    var entityPageViewBuilder: (Entity) -> EntityPageView

    private var isSelected: Bool {
        for entity in section {
            if !selectedEntities.contains(entity) {
                return false
            }
        }
        return true
    }

    private func selectSection() {
        section.forEach({ entity in selectedEntities.update(with: entity) })
    }

    private func unselectSection() {
        section.forEach({ entity in selectedEntities.remove(entity) })
    }

    var body: some View {
        Section(
            header: CustomListSectionHeaderView(
                headerText: section.id,
                inSelectionMode: inSelectionMode,
                isSelected: isSelected,
                buttonAction: {
                    if isSelected { unselectSection() }
                    else { selectSection() }
                }
            )
        ) {
            ForEach(section, id: \.self) { entity in
                CustomListItemView(
                    entity: entity,
                    selectedEntities: $selectedEntities,
                    inSelectionMode: inSelectionMode,
                    rowViewBuilder: entityRowViewBuilder,
                    pageViewBuilder: entityPageViewBuilder
                )
            }
        }
    }
}

struct CustomListSectionHeaderView: View {
    var headerText: String
    var inSelectionMode: Bool
    var isSelected: Bool
    var buttonAction: () -> Void

    var body: some View {
        if inSelectionMode {
            HStack {
                Button(
                    action: buttonAction,
                    label: {
                        CustomListSelectionIcon(isSelected: isSelected)
                        Text(headerText)
                    }
                )
            }.foregroundColor(isSelected ? .accentColor : .secondary)
        } else { Text(headerText).foregroundColor(.secondary) }
    }
}

struct CustomListItemView<
    Entity: NSManagedObject,
    RowView: View,
    PageView: View
>: View {
    @ObservedObject var entity: Entity
    @Binding var selectedEntities: Set<Entity>
    var inSelectionMode: Bool

    let rowView: RowView
    let pageView: PageView

    private let isSelected: Bool

    init(
        entity: Entity,
        selectedEntities: Binding<Set<Entity>>,
        inSelectionMode: Bool,
        @ViewBuilder rowViewBuilder: (Entity) -> RowView,
        @ViewBuilder pageViewBuilder: (Entity) -> PageView
    ) {
        self.entity = entity
        _selectedEntities = selectedEntities
        self.inSelectionMode = inSelectionMode
        self.rowView = rowViewBuilder(entity)
        self.pageView = pageViewBuilder(entity)
        self.isSelected = selectedEntities.wrappedValue.contains(entity)
    }

    var body: some View {
        if inSelectionMode {
            HStack {
                Button {
                    if isSelected { selectedEntities.remove(entity) }
                    else { selectedEntities.update(with: entity) }
                } label: { CustomListSelectionIcon(isSelected: isSelected) }
                rowView
            }.foregroundColor(isSelected ? .accentColor : .primary)
        } else { NavigationLink { pageView } label: { rowView } }
    }
}

struct CustomListSortSelectView<E>: View {
    @Binding var selectedSort: Sort<E>
    let sortOptions: [Sort<E>]

    var body: some View {
        Menu {
            Picker("Sort By", selection: $selectedSort) {
                ForEach(sortOptions, id: \.self) { sort in
                    Text(sort.name)
                }
            }
        } label: { Text("Sort") }
        .pickerStyle(.inline)
    }
}
