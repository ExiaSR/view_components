# frozen_string_literal: true

module Primer
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

    def initialize(
      align_right: DEFAULT_ALIGN_RIGHT,
      loading: DEFAULT_LOADING,
      blankslate: DEFAULT_BLANKSLATE,
      list_border: DEFAULT_LIST_BORDER_CLASS,
      list_role: nil,
      message: nil,
      **kwargs
    )
      @align_right = fetch_or_fallback([true, false], align_right, DEFAULT_ALIGN_RIGHT)
      @loading = fetch_or_fallback([true, false], loading, DEFAULT_LOADING)
      @blankslate = fetch_or_fallback([true, false], blankslate, DEFAULT_BLANKSLATE)
      @list_border = fetch_or_fallback(LIST_BORDER_CLASSES.keys, list_border,
        DEFAULT_LIST_BORDER_CLASS)
      @list_role = list_role
      @message = message
      @kwargs = kwargs
      @kwargs[:tag] ||= :div
      @kwargs[:role] ||= "menu" if @kwargs[:tag] == :"details-menu"
    end

    def render?
      items.any? || tabs.any? || content.present? || message.present?
    end

    def loading?
      @loading
    end

    def blankslate?
      @blankslate
    end

    class Tab < Primer::Slot
      DEFAULT_SELECTED = false

      attr_reader :selected

      def initialize(selected: DEFAULT_SELECTED, **kwargs)
        @selected = fetch_or_fallback([true, false], selected, DEFAULT_SELECTED)
        @kwargs = kwargs
        @kwargs[:tag] = :button
        @kwargs[:classes] = class_names(
          "SelectMenu-tab",
          kwargs[:classes],
        )
        @kwargs["aria-selected"] = "true" if @selected
      end

      def component
        Primer::BaseComponent.new(**@kwargs)
      end
    end

    class Item < Primer::Slot
      attr_reader :icon, :tab

      def initialize(icon: nil, tab: 1, **kwargs)
        @icon = icon
        @tab = (tab || 1).to_i
        @kwargs = kwargs
        @kwargs[:tag] ||= :button
        @kwargs[:role] ||= "menuitem"
        @kwargs[:classes] = class_names(
          "SelectMenu-item",
          kwargs[:classes],
        )
      end

      def wrapper_component
        case @kwargs[:tag]
        when :button
          Primer::ButtonComponent.new(**@kwargs)
        when :a
          Primer::LinkComponent.new(**@kwargs)
        else
          Primer::BaseComponent.new(**@kwargs)
        end
      end

      def icon_component
        Primer::OcticonComponent.new(
          icon: icon,
          classes: class_names(
            "SelectMenu-icon SelectMenu-icon--check",
            @kwargs[:icon_classes],
          )
        )
      end
    end

    class Header < Primer::Slot
      DEFAULT_CLOSE_BUTTON = false

      attr_reader :close_button

      def initialize(close_button: DEFAULT_CLOSE_BUTTON, **kwargs)
        @close_button = fetch_or_fallback([true, false], close_button, DEFAULT_CLOSE_BUTTON)
        @kwargs = kwargs
        @kwargs[:tag] ||= :header
        @kwargs[:classes] = class_names(
          "SelectMenu-header",
          kwargs[:classes]
        )
      end

      def wrapper_component
        Primer::BaseComponent.new(**@kwargs)
      end

      def title_component
        Primer::BaseComponent.new(
          tag: @kwargs[:title_tag] || :h3,
          classes: class_names(
            "SelectMenu-title",
            @kwargs[:title_classes],
          )
        )
      end

      def close_button_component
        Primer::ButtonComponent.new(
          tag: :button,
          classes: class_names(
            "SelectMenu-closeButton",
            @kwargs[:close_button_classes],
          )
        )
      end

      def close_button_icon
        Primer::OcticonComponent.new(icon: "x")
      end
    end

    class Footer < Primer::Slot
      def initialize(**kwargs)
        @kwargs = kwargs
        @kwargs[:tag] ||= :footer
        @kwargs[:classes] = class_names(
          "SelectMenu-footer",
          kwargs[:classes]
        )
      end

      def component
        Primer::BaseComponent.new(**@kwargs)
      end
    end

    class Filter < Primer::Slot
      def initialize(placeholder: "Filter", **kwargs)
        @placeholder = placeholder
        @kwargs = kwargs
        @kwargs[:tag] ||= :form
        @kwargs[:classes] = class_names(
          "SelectMenu-filter",
          kwargs[:classes],
        )
        @kwargs[:input_classes] ||= "form-control"
      end

      def wrapper_component
        Primer::BaseComponent.new(**@kwargs)
      end

      def input_component
        Primer::BaseComponent.new(
          tag: :input,
          type: "text",
          placeholder: @placeholder,
          "aria-label": @kwargs[:"aria-label"] || @placeholder,
          classes: class_names(
            "SelectMenu-input",
            @kwargs[:input_classes],
          )
        )
      end
    end

    def component
      @kwargs[:classes] = class_names(
        "SelectMenu",
        @kwargs[:classes],
        "right-0" => @align_right,
        "SelectMenu--hasFilter" => filter.present?,
      )
      Primer::BaseComponent.new(**@kwargs)
    end

    def modal_component
      Primer::BaseComponent.new(
        tag: :div,
        classes: class_names(
          "SelectMenu-modal",
          @kwargs[:modal_classes],
        )
      )
    end

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

    def list_component(hidden: false)
      Primer::BaseComponent.new(
        tag: :div,
        role: @list_role,
        hidden: hidden,
        classes: class_names(
          "SelectMenu-list",
          @kwargs[:list_classes],
          LIST_BORDER_CLASSES[@list_border],
        )
      )
    end

    def message_component
      Primer::BaseComponent.new(
        tag: :div,
        classes: class_names(
          "SelectMenu-message",
          @kwargs[:message_classes],
        )
      )
    end

    def tab_wrapper_component
      Primer::BaseComponent.new(
        tag: :nav,
        classes: class_names(
          "SelectMenu-tabs",
          @kwargs[:tab_wrapper_classes],
        )
      )
    end
  end
end
