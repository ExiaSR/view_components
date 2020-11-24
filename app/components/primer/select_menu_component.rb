# frozen_string_literal: true

module Primer
  class SelectMenuComponent < Primer::Component
    include ViewComponent::Slotable

    DEFAULT_ALIGN_RIGHT = false

    with_slot :header, class_name: "Header"
    with_slot :modal, class_name: "Modal"
    with_slot :item, class_name: "Item", collection: true
    with_slot :filter, class_name: "Filter"
    with_slot :footer, class_name: "Footer"
    with_slot :close_button, class_name: "CloseButton"

    def initialize(align_right: DEFAULT_ALIGN_RIGHT, **kwargs)
      @align_right = fetch_or_fallback([true, false], align_right, DEFAULT_ALIGN_RIGHT)
      @kwargs = kwargs
      @kwargs[:tag] ||= :div
      @kwargs[:role] ||= "menu" if @kwargs[:tag] == :"details-menu"
    end

    def render?
      modal.content.present? || items.any?
    end

    class Modal < Primer::Slot
      BORDER_CLASSES = {
        all: nil,
        omit_top: "border-top-0",
        none: "SelectMenu-list--borderless",
      }.freeze
      DEFAULT_BORDER_CLASS = :all
      DEFAULT_LOADING = false
      DEFAULT_BLANKSLATE = false

      attr_reader :message

      def initialize(
        loading: DEFAULT_LOADING,
        blankslate: DEFAULT_BLANKSLATE,
        border: DEFAULT_BORDER_CLASS,
        list_role: nil,
        message: nil,
        **kwargs
      )
        @loading = fetch_or_fallback([true, false], loading, DEFAULT_LOADING)
        @blankslate = fetch_or_fallback([true, false], blankslate, DEFAULT_BLANKSLATE)
        @border = fetch_or_fallback(BORDER_CLASSES.keys, border, DEFAULT_BORDER_CLASS)
        @list_role = list_role
        @message = message
        @kwargs = kwargs
        @kwargs[:tag] = :div
        @kwargs[:classes] = class_names(
          "SelectMenu-modal",
          kwargs[:classes],
        )
      end

      def loading?
        @loading
      end

      def blankslate?
        @blankslate
      end

      def wrapper_component
        Primer::BaseComponent.new(**@kwargs)
      end

      def list_component
        Primer::BaseComponent.new(
          tag: :div,
          role: @list_role,
          classes: class_names(
            "SelectMenu-list",
            @kwargs[:list_classes],
            BORDER_CLASSES[@border],
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
    end

    class Item < Primer::Slot
      def initialize(**kwargs)
        @kwargs = kwargs
        @kwargs[:tag] ||= :button
        @kwargs[:role] ||= "menuitem"
        @kwargs[:classes] = class_names(
          "SelectMenu-item",
          kwargs[:classes],
        )
      end

      def component
        case @kwargs[:tag]
        when :button
          Primer::ButtonComponent.new(**@kwargs)
        when :a
          Primer::LinkComponent.new(**@kwargs)
        else
          Primer::BaseComponent.new(**@kwargs)
        end
      end
    end

    class Header < Primer::Slot
      def initialize(**kwargs)
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

    class CloseButton < Primer::Slot
      def initialize(**kwargs)
        @kwargs = kwargs
        @kwargs[:tag] = :button
        @kwargs[:classes] = class_names(
          "SelectMenu-closeButton",
          kwargs[:classes],
        )
      end

      def component
        Primer::ButtonComponent.new(**@kwargs)
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

    def modal
      return @modal if defined?(@modal)
      Modal.new
    end
  end
end
