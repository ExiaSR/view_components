# frozen_string_literal: true

require "test_helper"

class PrimerSelectMenuComponentTest < Minitest::Test
  include Primer::ComponentTestHelpers

  def test_renders
    render_inline Primer::SelectMenuComponent.new do |component|
      component.slot(:modal) do
        "hello world"
      end
    end

    assert_selector("div.SelectMenu") do
      assert_selector("div.SelectMenu-modal") do
        assert_selector("div.SelectMenu-list", text: /hello world/)
      end
    end
  end

  def test_renders_with_header
    render_inline Primer::SelectMenuComponent.new do |component|
      component.slot(:header) do
        "A nice title"
      end
      component.slot(:modal) do
        "hello world"
      end
    end

    assert_selector("div.SelectMenu") do
      assert_selector("div.SelectMenu-modal") do
        assert_selector("header.SelectMenu-header") do
          assert_selector("h3.SelectMenu-title", text: /A nice title/)
        end
        assert_selector("div.SelectMenu-list", text: /hello world/)
      end
    end
  end

  def test_renders_with_header_and_close_button
    render_inline Primer::SelectMenuComponent.new do |component|
      component.slot(:header) { "A nice title" }
      component.slot(:modal) { "hello world" }
      component.slot(:close_button) { "close me" }
    end

    assert_selector("div.SelectMenu") do
      assert_selector("div.SelectMenu-modal") do
        assert_selector("header.SelectMenu-header") do
          assert_selector("h3.SelectMenu-title", text: /A nice title/)
          assert_selector("button.SelectMenu-closeButton", text: /close me/)
        end
        assert_selector("div.SelectMenu-list", text: /hello world/)
      end
    end
  end

  def test_passes_along_other_arguments
    render_inline Primer::SelectMenuComponent.new(
      classes: "my-class",
      mr: 3,
      display: :block,
    ) do |component|
      component.slot(:header,
        tag: :div,
        classes: "my-header-class",
        mt: 1,
        title_tag: :h1,
        title_classes: "my-title-class",
      ) do
        "A nice title"
      end
      component.slot(:modal,
        classes: "my-modal-class",
        py: 2,
        color: :red,
        list_classes: "my-list-class"
      ) do
        "hello world"
      end
      component.slot(:close_button,
        classes: "my-close-button",
        ml: 4,
        display: :inline_flex,
      ) do
        "close me"
      end
    end

    assert_selector("div.SelectMenu.my-class.mr-3.d-block") do
      assert_selector("div.SelectMenu-modal.my-modal-class.py-2.text-red") do
        assert_selector("div.SelectMenu-header.my-header-class.mt-1") do
          assert_selector("h1.SelectMenu-title.my-title-class", text: /A nice title/)
          assert_selector("button.SelectMenu-closeButton.my-close-button.ml-4.d-inline-flex",
            text: /close me/)
        end
        assert_selector("div.SelectMenu-list.my-list-class", text: /hello world/)
      end
    end
  end

  def test_omits_top_list_border_when_specified
    render_inline Primer::SelectMenuComponent.new do |component|
      component.slot(:modal, border: :omit_top) do
        "hello world"
      end
    end

    assert_selector("div.SelectMenu") do
      assert_selector("div.SelectMenu-modal") do
        assert_selector("div.SelectMenu-list.border-top-0", text: /hello world/)
      end
    end
  end

  def test_omits_all_borders_when_specified
    render_inline Primer::SelectMenuComponent.new do |component|
      component.slot(:modal, border: :none) do
        "hello world"
      end
    end

    assert_selector("div.SelectMenu") do
      assert_selector("div.SelectMenu-modal") do
        assert_selector("div.SelectMenu-list.SelectMenu-list--borderless",
          text: /hello world/)
      end
    end
  end

  def test_supports_right_alignment_of_menu
    render_inline Primer::SelectMenuComponent.new(align_right: true) do |component|
      component.slot(:modal) do
        "hello world"
      end
    end

    assert_selector("div.SelectMenu.right-0") do
      assert_selector("div.SelectMenu-modal") do
        assert_selector("div.SelectMenu-list", text: /hello world/)
      end
    end
  end

  def test_prevents_rendering_without_modal
    render_inline(Primer::SelectMenuComponent.new)
    refute_selector("div")
  end
end
