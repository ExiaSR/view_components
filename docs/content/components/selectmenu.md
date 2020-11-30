---
title: SelectMenu
---

<!-- Warning: AUTO-GENERATED file, do not edit. Add code comments to your Ruby instead <3 -->

Use select menus to list clickable choices, allow filtering between them, and highlight
which ones are selected.

## Examples

### Basic example

Use a `DetailsComponent` to toggle the select menu, with the `body` of the details component holding the select menu.

<iframe style="width: 100%; border: 0px; height: 34px;" srcdoc="<html><head><link href='https://unpkg.com/@primer/css/dist/primer.css' rel='stylesheet'></head><body><details class='details-overlay details-reset position-relative'>  <summary role='button' type='button' class='btn '>    Choose an option</summary>    <div>      <div class='SelectMenu '>  <div class='SelectMenu-modal '>      <header class='SelectMenu-header '>        <h3 class='SelectMenu-title '>          My menu</h3></header>      <div class='SelectMenu-list '>                    <button role='menuitemcheckbox' aria-checked='true' type='button' class='btn SelectMenu-item '>              <svg class='octicon octicon-check SelectMenu-icon SelectMenu-icon--check' height='16' viewBox='0 0 16 16' version='1.1' width='16' aria-hidden='true'><path fill-rule='evenodd' d='M13.78 4.22a.75.75 0 010 1.06l-7.25 7.25a.75.75 0 01-1.06 0L2.22 9.28a.75.75 0 011.06-1.06L6 10.94l6.72-6.72a.75.75 0 011.06 0z'></path></svg>            Item 1</button>          <button role='menuitemcheckbox' type='button' class='btn SelectMenu-item '>              <svg class='octicon octicon-check SelectMenu-icon SelectMenu-icon--check' height='16' viewBox='0 0 16 16' version='1.1' width='16' aria-hidden='true'><path fill-rule='evenodd' d='M13.78 4.22a.75.75 0 010 1.06l-7.25 7.25a.75.75 0 01-1.06 0L2.22 9.28a.75.75 0 011.06-1.06L6 10.94l6.72-6.72a.75.75 0 011.06 0z'></path></svg>            Item 2</button>          <button role='menuitemcheckbox' type='button' class='btn SelectMenu-item '>              <svg class='octicon octicon-check SelectMenu-icon SelectMenu-icon--check' height='16' viewBox='0 0 16 16' version='1.1' width='16' aria-hidden='true'><path fill-rule='evenodd' d='M13.78 4.22a.75.75 0 010 1.06l-7.25 7.25a.75.75 0 01-1.06 0L2.22 9.28a.75.75 0 011.06-1.06L6 10.94l6.72-6.72a.75.75 0 011.06 0z'></path></svg>            Item 3</button></div></div></div></div></details></body></html>"></iframe>

```erb
<%= render Primer::DetailsComponent.new(overlay: :default, reset: true, position: :relative) do |details_component| %>
  <%= details_component.slot(:summary) do %>
    Choose an option
  <% end %>
  <%= details_component.slot(:body) do %>
    <%= render Primer::SelectMenuComponent.new do |menu_component| %>
      <%= menu_component.slot(:header) do %>
        My menu
      <% end %>
      <%= menu_component.slot(:item, selected: true, icon: "check") do %>
        Item 1
      <% end %>
      <%= menu_component.slot(:item, icon: "check") do %>
        Item 2
      <% end %>
      <%= menu_component.slot(:item, icon: "check") do %>
        Item 3
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

### As a details-menu

Or make the select menu the `details-menu` element itself, omitting the `body` container for the details component.

<iframe style="width: 100%; border: 0px; height: 34px;" srcdoc="<html><head><link href='https://unpkg.com/@primer/css/dist/primer.css' rel='stylesheet'></head><body><details class='details-overlay details-reset '>  <summary title='Pick an item' role='button' type='button' class='btn '>    Choose an option    <span class='dropdown-caret'></span></summary>    <details-menu role='menu' class='SelectMenu '>  <div class='SelectMenu-modal '>      <div class='SelectMenu-list '>                    <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 1</button>          <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 2</button>          <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 3</button></div></div></details-menu></details></body></html>"></iframe>

```erb
<%= render Primer::DetailsComponent.new(overlay: :default, reset: true) do |details_component| %>
  <%= details_component.slot(:summary, title: "Pick an item") do %>
    Choose an option
    <span class="dropdown-caret"></span>
  <% end %>
  <%= details_component.slot(:body, omit_wrapper: true) do %>
    <%= render Primer::SelectMenuComponent.new(tag: :"details-menu") do |menu_component| %>
      <%= menu_component.slot(:item) do %>
        Item 1
      <% end %>
      <%= menu_component.slot(:item) do %>
        Item 2
      <% end %>
      <%= menu_component.slot(:item) do %>
        Item 3
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

### Close button

Include a button to close the menu:

<iframe style="width: 100%; border: 0px; height: 34px;" srcdoc="<html><head><link href='https://unpkg.com/@primer/css/dist/primer.css' rel='stylesheet'></head><body><details class='details-overlay details-reset position-relative'>  <summary role='button' type='button' class='btn '>    Choose an option</summary>    <div>      <div class='SelectMenu '>  <div class='SelectMenu-modal '>      <header class='SelectMenu-header '>        <h3 class='SelectMenu-title '>          My menu</h3>          <button type='button' class='btn SelectMenu-closeButton '>            <svg class='octicon octicon-x' height='16' viewBox='0 0 16 16' version='1.1' width='16' aria-hidden='true'><path fill-rule='evenodd' d='M3.72 3.72a.75.75 0 011.06 0L8 6.94l3.22-3.22a.75.75 0 111.06 1.06L9.06 8l3.22 3.22a.75.75 0 11-1.06 1.06L8 9.06l-3.22 3.22a.75.75 0 01-1.06-1.06L6.94 8 3.72 4.78a.75.75 0 010-1.06z'></path></svg></button></header>      <div class='SelectMenu-list '>                    <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 1</button>          <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 2</button>          <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 3</button></div></div></div></div></details></body></html>"></iframe>

```erb
<%= render Primer::DetailsComponent.new(overlay: :default, reset: true, position: :relative) do |details_component| %>
  <%= details_component.slot(:summary) do %>
    Choose an option
  <% end %>
  <%= details_component.slot(:body) do %>
    <%= render Primer::SelectMenuComponent.new do |menu_component| %>
      <%= menu_component.slot(:header, close_button: true) do %>
        My menu
      <% end %>
      <%= menu_component.slot(:item) do %>
        Item 1
      <% end %>
      <%= menu_component.slot(:item) do %>
        Item 2
      <% end %>
      <%= menu_component.slot(:item) do %>
        Item 3
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

### Filter

If the list is expected to get long, consider adding a filter input. On mobile devices it will add a fixed height and anchor the select menu to the top of the screen. This makes sure the filter input stays at the same position while typing.

<iframe style="width: 100%; border: 0px; height: 34px;" srcdoc="<html><head><link href='https://unpkg.com/@primer/css/dist/primer.css' rel='stylesheet'></head><body><details class='details-overlay details-reset position-relative'>  <summary role='button' type='button' class='btn '>    Choose an option</summary>    <div>      <div class='SelectMenu SelectMenu--hasFilter '>  <div class='SelectMenu-modal '>      <header class='SelectMenu-header '>        <h3 class='SelectMenu-title '>          My menu</h3></header>      <form input_classes='form-control' class='SelectMenu-filter '>        <input type='text' placeholder='Filter' aria-label='Filter' class='SelectMenu-input form-control '></input>        </form>      <div class='SelectMenu-list '>                    <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 1</button>          <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 2</button>          <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 3</button></div></div></div></div></details></body></html>"></iframe>

```erb
<%= render Primer::DetailsComponent.new(overlay: :default, reset: true, position: :relative) do |details_component| %>
  <%= details_component.slot(:summary) do %>
    Choose an option
  <% end %>
  <%= details_component.slot(:body) do %>
    <%= render Primer::SelectMenuComponent.new do |menu_component| %>
      <%= menu_component.slot(:header) do %>
        My menu
      <% end %>
      <%= menu_component.slot(:filter) %>
      <%= menu_component.slot(:item) do %>
        Item 1
      <% end %>
      <%= menu_component.slot(:item) do %>
        Item 2
      <% end %>
      <%= menu_component.slot(:item) do %>
        Item 3
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

### Tabs

Sometimes you need two or more lists of items in your select menu, e.g. branches and tags.

<iframe style="width: 100%; border: 0px; height: 34px;" srcdoc="<html><head><link href='https://unpkg.com/@primer/css/dist/primer.css' rel='stylesheet'></head><body><details class='details-overlay details-reset '>  <summary title='Pick an item' role='button' type='button' class='btn '>    Choose an option    <span class='dropdown-caret'></span></summary>    <details-menu role='menu' class='SelectMenu '>  <div class='SelectMenu-modal '>      <nav class='SelectMenu-tabs '>          <button aria-selected='true' class='SelectMenu-tab '>            Tab 1</button>          <button class='SelectMenu-tab '>            Tab 2</button></nav>      <div class='SelectMenu-list '>                    <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 1</button>            <hr class='SelectMenu-divider '></hr>          <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 2</button></div>      <div hidden='hidden' class='SelectMenu-list '>                    <button role='menuitem' type='button' class='btn SelectMenu-item '>            Item 3</button></div></div></details-menu></details></body></html>"></iframe>

```erb
<%= render Primer::DetailsComponent.new(overlay: :default, reset: true) do |details_component| %>
  <%= details_component.slot(:summary, title: "Pick an item") do %>
    Choose an option
    <span class="dropdown-caret"></span>
  <% end %>
  <%= details_component.slot(:body, omit_wrapper: true) do %>
    <%= render Primer::SelectMenuComponent.new(tag: :"details-menu") do |menu_component| %>
      <%= menu_component.slot(:tab, selected: true) do %>
        Tab 1
      <% end %>
      <%= menu_component.slot(:tab) do %>
        Tab 2
      <% end %>
      <%= menu_component.slot(:item, tab: 1, divider: true) do %>
        Item 1
      <% end %>
      <%= menu_component.slot(:item, tab: 1) do %>
        Item 2
      <% end %>
      <%= menu_component.slot(:item, tab: 2) do %>
        Item 3
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

### Blankslate

Sometimes a select menu needs to communicate a "blank slate" where there's no content in the menu's list.

<iframe style="width: 100%; border: 0px; height: 34px;" srcdoc="<html><head><link href='https://unpkg.com/@primer/css/dist/primer.css' rel='stylesheet'></head><body><details class='details-overlay details-reset '>  <summary title='Pick an item' role='button' type='button' class='btn '>    Choose an option    <span class='dropdown-caret'></span></summary>    <details-menu role='menu' class='SelectMenu '>  <div class='SelectMenu-modal '>      <div class='SelectMenu-list '>          <div class='SelectMenu-blankslate'>                  <h4>No results</h4>      <p>There are no results to show.</p>          </div></div></div></details-menu></details></body></html>"></iframe>

```erb
<%= render Primer::DetailsComponent.new(overlay: :default, reset: true) do |details_component| %>
  <%= details_component.slot(:summary, title: "Pick an item") do %>
    Choose an option
    <span class="dropdown-caret"></span>
  <% end %>
  <%= details_component.slot(:body, omit_wrapper: true) do %>
    <%= render Primer::SelectMenuComponent.new(tag: :"details-menu", blankslate: true) do %>
      <h4>No results</h4>
      <p>There are no results to show.</p>
    <% end %>
  <% end %>
<% end %>
```

### Loading

When fetching large lists, consider showing a loading message.

<iframe style="width: 100%; border: 0px; height: 34px;" srcdoc="<html><head><link href='https://unpkg.com/@primer/css/dist/primer.css' rel='stylesheet'></head><body><details class='details-overlay details-reset '>  <summary title='Pick an item' role='button' type='button' class='btn '>    Choose an option    <span class='dropdown-caret'></span></summary>    </details></body></html>"></iframe>

```erb
<%= render Primer::DetailsComponent.new(overlay: :default, reset: true) do |details_component| %>
  <%= details_component.slot(:summary, title: "Pick an item") do %>
    Choose an option
    <span class="dropdown-caret"></span>
  <% end %>
  <%= details_component.slot(:body, omit_wrapper: true) do %>
    <%= render Primer::SelectMenuComponent.new(tag: :"details-menu", loading: true) do |menu_component| %>
      <%= menu_component.slot(:footer) do %>
        Loading...
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

## Arguments

| Name | Type | Default | Description |
| :- | :- | :- | :- |
| `tag` | `Symbol` | N/A | HTML element type for the `.SelectMenu` tag. Defaults to `:div`. |
| `align_right` | `Boolean` | `false` | Align the whole menu to the right or not. |
| `loading` | `Boolean` | `false` | Whether the content will be a loading message. |
| `blankslate` | `Boolean` | `false` | Whether to style the content as a blankslate, to represent there is no content. |
| `list_border` | `Symbol` | `:all` | What kind of border to have around the list element. One of `:all`, `:omit_top`, or `:none`. |
| `message` | `String` | `nil` | A message shown above the contents. |
| `list_classes` | `String` | N/A | CSS classes to apply to the list element. |
| `list_role` | `String` | `nil` | Optional `role` attribute for the list element. |
| `message_classes` | `String` | N/A | CSS classes to apply to the message element, if a message is included. |
| `tab_wrapper_classes` | `String` | N/A | CSS classes to apply to the containing tab `nav` element, if any tabs are added. |
| `system_arguments` | `Hash` | N/A | [System arguments](/system-arguments) |

### `header` slot

| Name | Type | Default | Description |
| :- | :- | :- | :- |
| `tag` | `Symbol` | N/A | HTML element type for the header tag. Defaults to `:header`. |
| `close_button` | `Boolean` | `DEFAULT_CLOSE_BUTTON` | Whether to include a close button in the header for closing the whole menu. | |
| `close_button_classes` | `String` | N/A | CSS classes to apply to the close button within the header. Only used if `close_button` = `true`. |
| `title_classes` | `String` | N/A | CSS classes to apply to the title element within the header. |
| `title_tag` | `Symbol` | N/A | HTML element type for the title tag. Defaults to `:h3`. |
| `system_arguments` | `Hash` | N/A | [System arguments](/system-arguments) |

An optional header for the select menu.

### `item` slot

| Name | Type | Default | Description |
| :- | :- | :- | :- |
| `tag` | `Symbol` | N/A | HTML element type for the item tag. Defaults to `:button`. |
| `selected` | `Boolean` | `DEFAULT_SELECTED` | Whether this item is the currently active one. |
| `tab` | `Integer` | `DEFAULT_TAB` | Which tab this item should appear in. The first tab is 1. |
| `icon` | `String` | `nil` | Octicon name for this item. Defaults to no icon. Set to a value like `"check"` to add an [Octicon](https://primer.style/octicons/) to this item. |
| `role` | `String` | N/A | HTML role attribute for the item tag. Defaults to `"menuitem"`. |
| `icon_classes` | `String` | N/A | CSS classes to apply to the icon. Only used if `icon` is not `nil`. |
| `divider` | `Boolean, String, nil` | `nil` | Whether to show a divider after this item. Pass `true` to show a simple line divider, or pass a String to show a divider with a message. |
| `divider_classes` | `String` | N/A | CSS classes to apply to the divider after this item. Only used if `divider` is not `nil`. |
| `system_arguments` | `Hash` | N/A | [System arguments](/system-arguments) |

List items within the select menu. Can be organized into tabs.

### `tab` slot

| Name | Type | Default | Description |
| :- | :- | :- | :- |
| `selected` | `Boolean` | `DEFAULT_SELECTED` | Whether this tab is the one whose contents should be visible initially. |
| `system_arguments` | `Hash` | N/A | [System arguments](/system-arguments) |

Represents the clickable tabs at the top of the select menu, if any.

### `filter` slot

| Name | Type | Default | Description |
| :- | :- | :- | :- |
| `tag` | `Symbol` | N/A | HTML element type for the filter tag. Defaults to `:form`. |
| `input_classes` | `String` | N/A | CSS classes to apply to the input element within the modal. Defaults to `"form-control"`. |
| `aria-label` | `String` | N/A | The aria-label attribute for the input field. Defaults to `"Filter"`. |
| `placeholder` | `String` | `DEFAULT_PLACEHOLDER` | The placeholder attribute for the input field. |
| `system_arguments` | `Hash` | N/A | [System arguments](/system-arguments) |

An optional filter bar for the select menu, to allow limiting how much of its contents
is shown at a time.

### `footer` slot

| Name | Type | Default | Description |
| :- | :- | :- | :- |
| `tag` | `Symbol` | N/A | HTML element type for the footer tag. Defaults to `:footer`. |
| `system_arguments` | `Hash` | N/A | [System arguments](/system-arguments) |

An optional footer for the select menu.
