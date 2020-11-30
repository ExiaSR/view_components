# frozen_string_literal: true

module Primer
  # Use select menus to list clickable choices, allow filtering between them, and highlight
  # which ones are selected.
  class SelectMenuComponent < Primer::Component
    include ViewComponent::Slotable

    LIST_BORDER_CLASSES = {
      all: nil,
      omit_top: "border-top-0",
      none: "SelectMenu-list--borderless",
    }.freeze
    DEFAULT_LIST_BORDER_CLASS = :all
    DEFAULT_LOADING = false
    DEFAULT_BLANKSLATE = false
    DEFAULT_ALIGN_RIGHT = false

    with_slot :header, class_name: "Header"
    with_slot :item, class_name: "Item", collection: true
    with_slot :tab, class_name: "Tab", collection: true
    with_slot :filter, class_name: "Filter"
    with_slot :footer, class_name: "Footer"

    attr_reader :message

    #
    # @example 34|Basic example|Use a `DetailsComponent` to toggle the select menu, with the `body` of the details component holding the select menu.
    #   <%= render Primer::DetailsComponent.new(overlay: :default, reset: true, position: :relative) do |details_component| %>
    #     <%= details_component.slot(:summary) do %>
    #       Choose an option
    #     <% end %>
    #     <%= details_component.slot(:body) do %>
    #       <%= render Primer::SelectMenuComponent.new do |menu_component| %>
    #         <%= menu_component.slot(:header) do %>
    #           My menu
    #         <% end %>
    #         <%= menu_component.slot(:item, selected: true, icon: "check") do %>
    #           Item 1
    #         <% end %>
    #         <%= menu_component.slot(:item, icon: "check") do %>
    #           Item 2
    #         <% end %>
    #         <%= menu_component.slot(:item, icon: "check") do %>
    #           Item 3
    #         <% end %>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @example 34|As a details-menu|Or make the select menu the `details-menu` element itself, omitting the `body` container for the details component.
    #   <%= render Primer::DetailsComponent.new(overlay: :default, reset: true) do |details_component| %>
    #     <%= details_component.slot(:summary, title: "Pick an item") do %>
    #       Choose an option
    #       <span class="dropdown-caret"></span>
    #     <% end %>
    #     <%= details_component.slot(:body, omit_wrapper: true) do %>
    #       <%= render Primer::SelectMenuComponent.new(tag: :"details-menu") do |menu_component| %>
    #         <%= menu_component.slot(:item) do %>
    #           Item 1
    #         <% end %>
    #         <%= menu_component.slot(:item) do %>
    #           Item 2
    #         <% end %>
    #         <%= menu_component.slot(:item) do %>
    #           Item 3
    #         <% end %>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @example 34|Close button|Include a button to close the menu:
    #   <%= render Primer::DetailsComponent.new(overlay: :default, reset: true, position: :relative) do |details_component| %>
    #     <%= details_component.slot(:summary) do %>
    #       Choose an option
    #     <% end %>
    #     <%= details_component.slot(:body) do %>
    #       <%= render Primer::SelectMenuComponent.new do |menu_component| %>
    #         <%= menu_component.slot(:header, close_button: true) do %>
    #           My menu
    #         <% end %>
    #         <%= menu_component.slot(:item) do %>
    #           Item 1
    #         <% end %>
    #         <%= menu_component.slot(:item) do %>
    #           Item 2
    #         <% end %>
    #         <%= menu_component.slot(:item) do %>
    #           Item 3
    #         <% end %>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @example 34|Filter|If the list is expected to get long, consider adding a filter input. On mobile devices it will add a fixed height and anchor the select menu to the top of the screen. This makes sure the filter input stays at the same position while typing.
    #   <%= render Primer::DetailsComponent.new(overlay: :default, reset: true, position: :relative) do |details_component| %>
    #     <%= details_component.slot(:summary) do %>
    #       Choose an option
    #     <% end %>
    #     <%= details_component.slot(:body) do %>
    #       <%= render Primer::SelectMenuComponent.new do |menu_component| %>
    #         <%= menu_component.slot(:header) do %>
    #           My menu
    #         <% end %>
    #         <%= menu_component.slot(:filter) %>
    #         <%= menu_component.slot(:item) do %>
    #           Item 1
    #         <% end %>
    #         <%= menu_component.slot(:item) do %>
    #           Item 2
    #         <% end %>
    #         <%= menu_component.slot(:item) do %>
    #           Item 3
    #         <% end %>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @example 34|Tabs|Sometimes you need two or more lists of items in your select menu, e.g. branches and tags.
    #   <%= render Primer::DetailsComponent.new(overlay: :default, reset: true) do |details_component| %>
    #     <%= details_component.slot(:summary, title: "Pick an item") do %>
    #       Choose an option
    #       <span class="dropdown-caret"></span>
    #     <% end %>
    #     <%= details_component.slot(:body, omit_wrapper: true) do %>
    #       <%= render Primer::SelectMenuComponent.new(tag: :"details-menu") do |menu_component| %>
    #         <%= menu_component.slot(:tab, selected: true) do %>
    #           Tab 1
    #         <% end %>
    #         <%= menu_component.slot(:tab) do %>
    #           Tab 2
    #         <% end %>
    #         <%= menu_component.slot(:item, tab: 1, divider: true) do %>
    #           Item 1
    #         <% end %>
    #         <%= menu_component.slot(:item, tab: 1) do %>
    #           Item 2
    #         <% end %>
    #         <%= menu_component.slot(:item, tab: 2) do %>
    #           Item 3
    #         <% end %>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @example 34|Blankslate|Sometimes a select menu needs to communicate a "blank slate" where there's no content in the menu's list.
    #   <%= render Primer::DetailsComponent.new(overlay: :default, reset: true) do |details_component| %>
    #     <%= details_component.slot(:summary, title: "Pick an item") do %>
    #       Choose an option
    #       <span class="dropdown-caret"></span>
    #     <% end %>
    #     <%= details_component.slot(:body, omit_wrapper: true) do %>
    #       <%= render Primer::SelectMenuComponent.new(tag: :"details-menu", blankslate: true) do %>
    #         <h4>No results</h4>
    #         <p>There are no results to show.</p>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @example 34|Loading|When fetching large lists, consider showing a loading message.
    #   <%= render Primer::DetailsComponent.new(overlay: :default, reset: true) do |details_component| %>
    #     <%= details_component.slot(:summary, title: "Pick an item") do %>
    #       Choose an option
    #       <span class="dropdown-caret"></span>
    #     <% end %>
    #     <%= details_component.slot(:body, omit_wrapper: true) do %>
    #       <%= render Primer::SelectMenuComponent.new(tag: :"details-menu", loading: true) do |menu_component| %>
    #         <%= menu_component.slot(:footer) do %>
    #           Loading...
    #         <% end %>
    #         <%= render Primer::OcticonComponent(icon: "octoface", classes: "anim-pulse") %>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # @param tag [Symbol] HTML element type for the `.SelectMenu` tag. Defaults to `:div`.
    # @param align_right [Boolean] Align the whole menu to the right or not.
    # @param loading [Boolean] Whether the content will be a loading message.
    # @param blankslate [Boolean] Whether to style the content as a blankslate, to represent there is no content.
    # @param list_border [Symbol] What kind of border to have around the list element. One of `:all`, `:omit_top`, or `:none`.
    # @param message [String] A message shown above the contents.
    # @param list_classes [String] CSS classes to apply to the list element.
    # @param list_role [String] Optional `role` attribute for the list element.
    # @param message_classes [String] CSS classes to apply to the message element, if a message is included.
    # @param tab_wrapper_classes [String] CSS classes to apply to the containing tab `nav` element, if any tabs are added.
    # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
    def initialize(
      align_right: DEFAULT_ALIGN_RIGHT,
      loading: DEFAULT_LOADING,
      blankslate: DEFAULT_BLANKSLATE,
      list_border: DEFAULT_LIST_BORDER_CLASS,
      list_role: nil,
      message: nil,
      **system_arguments
    )
      @align_right = fetch_or_fallback_boolean(align_right, DEFAULT_ALIGN_RIGHT)
      @loading = fetch_or_fallback_boolean(loading, DEFAULT_LOADING)
      @blankslate = fetch_or_fallback_boolean(blankslate, DEFAULT_BLANKSLATE)
      @list_border = fetch_or_fallback(LIST_BORDER_CLASSES.keys, list_border,
        DEFAULT_LIST_BORDER_CLASS)
      @list_role = list_role
      @message = message
      @system_arguments = system_arguments
      @system_arguments[:tag] ||= :div
      @system_arguments[:role] ||= "menu" if @system_arguments[:tag] == :"details-menu"
    end

    def render?
      items.any? || tabs.any? || content.present? || message.present?
    end

    class Tab < Primer::Slot
      DEFAULT_SELECTED = false

      attr_reader :selected

      # @param selected [Boolean] Whether this tab is the one whose contents should be visible initially.
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      def initialize(selected: DEFAULT_SELECTED, **system_arguments)
        @selected = fetch_or_fallback_boolean(selected, DEFAULT_SELECTED)
        @system_arguments = system_arguments
        @system_arguments[:tag] = :button
        @system_arguments[:classes] = class_names(
          "SelectMenu-tab",
          system_arguments[:classes],
        )
        @system_arguments[:"aria-selected"] = "true" if @selected
      end

      def component
        Primer::BaseComponent.new(**@system_arguments)
      end
    end

    class Item < Primer::Slot
      DEFAULT_TAB = 1
      DEFAULT_SELECTED = false

      attr_reader :icon, :tab, :divider

      # @param tag [Symbol] HTML element type for the item tag. Defaults to `:button`.
      # @param selected [Boolean] Whether this item is the currently active one.
      # @param tab [Integer] Which tab this item should appear in. The first tab is 1.
      # @param icon [String] Octicon name for this item. Defaults to no icon. Set to a value like `"check"` to add an [Octicon](https://primer.style/octicons/) to this item.
      # @param role [String] HTML role attribute for the item tag. Defaults to `"menuitem"`.
      # @param icon_classes [String] CSS classes to apply to the icon. Only used if `icon` is not `nil`.
      # @param divider [Boolean, String, nil] Whether to show a divider after this item. Pass `true` to show a simple line divider, or pass a String to show a divider with a message.
      # @param divider_classes [String] CSS classes to apply to the divider after this item. Only used if `divider` is not `nil`.
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      def initialize(selected: DEFAULT_SELECTED, icon: nil, tab: DEFAULT_TAB, divider: nil, **system_arguments)
        @selected = fetch_or_fallback_boolean(selected, DEFAULT_SELECTED)
        @icon = icon
        @tab = (tab || DEFAULT_TAB).to_i
        @divider = divider
        @system_arguments = system_arguments
        @system_arguments[:tag] ||= :button
        @system_arguments[:role] ||= if @selected || @icon
          "menuitemcheckbox"
        else
          "menuitem"
        end
        @system_arguments[:classes] = class_names(
          "SelectMenu-item",
          system_arguments[:classes],
        )
        @system_arguments[:"aria-checked"] = "true" if @selected
      end

      def wrapper_component
        case @system_arguments[:tag]
        when :button
          Primer::ButtonComponent.new(**@system_arguments)
        when :a
          Primer::LinkComponent.new(**@system_arguments)
        else
          Primer::BaseComponent.new(**@system_arguments)
        end
      end

      # Private: Only used if `icon` is non-nil.
      def icon_component
        Primer::OcticonComponent.new(
          icon: icon,
          classes: class_names(
            "SelectMenu-icon SelectMenu-icon--check",
            @system_arguments[:icon_classes],
          )
        )
      end

      # Private: Only used if `divider` is non-nil.
      def divider_component
        divider_classes = class_names(
          "SelectMenu-divider",
          @system_arguments[:divider_classes],
        )
        if divider.is_a?(String)
          Primer::BaseComponent.new(
            tag: :div,
            classes: divider_classes
          )
        else
          Primer::BaseComponent.new(
            tag: :hr,
            classes: divider_classes
          )
        end
      end
    end

    class Header < Primer::Slot
      DEFAULT_CLOSE_BUTTON = false

      attr_reader :close_button

      # @param tag [Symbol] HTML element type for the header tag. Defaults to `:header`.
      # @param close_button [Boolean] Whether to include a close button in the header for closing the whole menu. |
      # @param close_button_classes [String] CSS classes to apply to the close button within the header. Only used if `close_button` = `true`.
      # @param title_classes [String] CSS classes to apply to the title element within the header.
      # @param title_tag [Symbol] HTML element type for the title tag. Defaults to `:h3`.
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      def initialize(close_button: DEFAULT_CLOSE_BUTTON, **system_arguments)
        @close_button = fetch_or_fallback_boolean(close_button, DEFAULT_CLOSE_BUTTON)
        @system_arguments = system_arguments
        @system_arguments[:tag] ||= :header
        @system_arguments[:classes] = class_names(
          "SelectMenu-header",
          system_arguments[:classes]
        )
      end

      def wrapper_component
        Primer::BaseComponent.new(**@system_arguments)
      end

      def title_component
        Primer::BaseComponent.new(
          tag: @system_arguments[:title_tag] || :h3,
          classes: class_names(
            "SelectMenu-title",
            @system_arguments[:title_classes],
          )
        )
      end

      # Private: Only used if `close_button` is `true`.
      def close_button_component
        Primer::ButtonComponent.new(
          tag: :button,
          classes: class_names(
            "SelectMenu-closeButton",
            @system_arguments[:close_button_classes],
          )
        )
      end

      # Private: Only used if `close_button` is `true`.
      def close_button_icon
        Primer::OcticonComponent.new(icon: "x")
      end
    end

    class Footer < Primer::Slot
      # @param tag [Symbol] HTML element type for the footer tag. Defaults to `:footer`.
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      def initialize(**system_arguments)
        @system_arguments = system_arguments
        @system_arguments[:tag] ||= :footer
        @system_arguments[:classes] = class_names(
          "SelectMenu-footer",
          system_arguments[:classes]
        )
      end

      def component
        Primer::BaseComponent.new(**@system_arguments)
      end
    end

    class Filter < Primer::Slot
      DEFAULT_PLACEHOLDER = "Filter"

      # @param tag [Symbol] HTML element type for the filter tag. Defaults to `:form`.
      # @param input_classes [String] CSS classes to apply to the input element within the modal. Defaults to `"form-control"`.
      # @param aria-label [String] The aria-label attribute for the input field. Defaults to `"Filter"`.
      # @param placeholder [String] The placeholder attribute for the input field.
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      def initialize(placeholder: DEFAULT_PLACEHOLDER, **system_arguments)
        @placeholder = placeholder
        @system_arguments = system_arguments
        @system_arguments[:tag] ||= :form
        @system_arguments[:classes] = class_names(
          "SelectMenu-filter",
          system_arguments[:classes],
        )
        @system_arguments[:input_classes] ||= "form-control"
      end

      def wrapper_component
        Primer::BaseComponent.new(**@system_arguments)
      end

      def input_component
        Primer::BaseComponent.new(
          tag: :input,
          type: "text",
          placeholder: @placeholder,
          "aria-label": @system_arguments[:"aria-label"] || @placeholder,
          classes: class_names(
            "SelectMenu-input",
            @system_arguments[:input_classes],
          )
        )
      end
    end

    private

    def loading?
      @loading
    end

    def blankslate?
      @blankslate
    end

    def container_component
      @system_arguments[:classes] = class_names(
        "SelectMenu",
        @system_arguments[:classes],
        "right-0" => @align_right,
        "SelectMenu--hasFilter" => filter.present?,
      )
      Primer::BaseComponent.new(**@system_arguments)
    end

    def modal_component
      Primer::BaseComponent.new(
        tag: :div,
        classes: class_names(
          "SelectMenu-modal",
          @system_arguments[:modal_classes],
        )
      )
    end

    # Private: Returns a list of the content items that should be shown in the specified tab.
    #
    # tab - Integer starting at 1 to represent the first tab
    #
    # Returns an Array of Item instances.
    def items_in_tab(tab)
      return [] if items.empty?
      items.select { |item| item.tab == tab }
    end

    # Private: Get all the `.SelectMenu-list` elements necessary to represent all the
    # tabs in this select menu.
    def list_components
      if tabs.any?
        tabs.map do |tab|
          list_component(hidden: !tab.selected)
        end
      else
        [list_component]
      end
    end

    # Private: Get a component to represent the `.SelectMenu-list` element that will
    # contain the items in the menu.
    #
    # hidden - Boolean indicating whether this list should be hidden initially, such
    #          as when it represents an unselected tab's contents
    #
    # Returns a component.
    def list_component(hidden: false)
      Primer::BaseComponent.new(
        tag: :div,
        role: @list_role,
        hidden: hidden,
        classes: class_names(
          "SelectMenu-list",
          @system_arguments[:list_classes],
          LIST_BORDER_CLASSES[@list_border],
        )
      )
    end

    def message_component
      Primer::BaseComponent.new(
        tag: :div,
        classes: class_names(
          "SelectMenu-message",
          @system_arguments[:message_classes],
        )
      )
    end

    def tab_wrapper_component
      Primer::BaseComponent.new(
        tag: :nav,
        classes: class_names(
          "SelectMenu-tabs",
          @system_arguments[:tab_wrapper_classes],
        )
      )
    end
  end
end
