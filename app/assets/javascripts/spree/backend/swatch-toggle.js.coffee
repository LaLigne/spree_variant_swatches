$(document).ready(()->
  $('.enable-swatch-toggle').change(()->
    checked = this.checked
    picker = $($(this).data().picker).get(0)

    if (picker)
      picker.disabled = !checked
  ).change()
)
