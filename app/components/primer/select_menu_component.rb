# frozen_string_literal: true

module Primer
  class SelectMenuComponent < Primer::Component
    include ViewComponent::Slotable

    with_slot :modal, class_name: "Modal"

    def initialize(**kwargs)
      @kwargs = kwargs
      @kwargs[:tag] = :div
      @kwargs[:classes] = class_names(
        "SelectMenu",
        kwargs[:classes]
      )
    end

    def render?
      modal.present?
    end

    class Modal < Primer::Slot
      DEFAULT_OMIT_TOP_BORDER = false

      def initialize(omit_top_border: DEFAULT_OMIT_TOP_BORDER, **kwargs)
        @omit_top_border = fetch_or_fallback([true, false], omit_top_border, DEFAULT_OMIT_TOP_BORDER)
        @kwargs = kwargs
        @kwargs[:tag] = :div
        @kwargs[:classes] = class_names(
          "SelectMenu-modal",
          kwargs[:classes]
        )
      end

      def outer_component
        Primer::BaseComponent.new(**@kwargs)
      end

      def inner_component
        Primer::BaseComponent.new(
          tag: :div,
          role: "menu",
          classes: class_names(
            "SelectMenu-list",
            @kwargs[:list_classes],
            "border-top-0" => @omit_top_border,
          )
        )
      end
    end

    def component
      Primer::BaseComponent.new(**@kwargs)
    end
  end
end
