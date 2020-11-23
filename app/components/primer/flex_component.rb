# frozen_string_literal: true

module Primer
  class FlexComponent < Primer::Component
    JUSTIFY_CONTENT_DEFAULT = nil
    JUSTIFY_CONTENT_MAPPINGS = {
      flex_start: "flex-justify-start",
      flex_end: "flex-justify-end",
      center: "flex-justify-center",
      space_between: "flex-justify-between",
      space_around: "flex-justify-around",
    }
    JUSTIFY_CONTENT_OPTIONS = [JUSTIFY_CONTENT_DEFAULT, *JUSTIFY_CONTENT_MAPPINGS.keys]

    ALIGN_ITEMS_DEFAULT = nil
    ALIGN_ITEMS_MAPPINGS = {
      start: "flex-items-start",
      end: "flex-items-end",
      center: "flex-items-center",
      baseline: "flex-items-baseline",
      stretch: "flex-items-stretch",
    }
    ALIGN_ITEMS_OPTIONS = [ALIGN_ITEMS_DEFAULT, *ALIGN_ITEMS_MAPPINGS.keys]

    INLINE_DEFAULT = false
    INLINE_OPTIONS = [INLINE_DEFAULT, true]

    FLEX_WRAP_DEFAULT = nil
    FLEX_WRAP_OPTIONS = [FLEX_WRAP_DEFAULT, true, false]

    DEFAULT_DIRECTION = nil
    ALLOWED_DIRECTIONS = [DEFAULT_DIRECTION, :column, :column_reverse, :row, :row_reverse]

    def initialize(
      justify_content: JUSTIFY_CONTENT_DEFAULT,
      inline: INLINE_DEFAULT,
      flex_wrap: FLEX_WRAP_DEFAULT,
      align_items: ALIGN_ITEMS_DEFAULT,
      direction: nil,
      **system_arguments
    )
      @align_items = fetch_or_fallback(ALIGN_ITEMS_OPTIONS, align_items, ALIGN_ITEMS_DEFAULT)
      @justify_content = fetch_or_fallback(JUSTIFY_CONTENT_OPTIONS, justify_content, JUSTIFY_CONTENT_DEFAULT)
      @flex_wrap = fetch_or_fallback(FLEX_WRAP_OPTIONS, flex_wrap, FLEX_WRAP_DEFAULT)

      # Support direction argument that is an array
      @direction =
        if (Array(direction) - ALLOWED_DIRECTIONS).empty?
          direction
        else
          DEFAULT_DIRECTION
        end

      @system_arguments = system_arguments.merge({ direction: @direction }.compact)
      @system_arguments[:classes] = class_names(@system_arguments[:classes], component_class_names)
      @system_arguments[:display] = fetch_or_fallback(INLINE_OPTIONS, inline, INLINE_DEFAULT) ? :inline_flex : :flex
    end

    def call
      render(Primer::BoxComponent.new(**@system_arguments)) { content }
    end

    private

    def component_class_names
      out = []
      out << JUSTIFY_CONTENT_MAPPINGS[@justify_content]
      out << ALIGN_ITEMS_MAPPINGS[@align_items]

      out <<
        case @flex_wrap
        when true
          "flex-wrap"
        when false
          "flex-nowrap"
        end

      out.compact.join(" ")
    end
  end
end
