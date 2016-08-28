Take ["CartDB", "DOMContentLoaded"], (CartDB, Validator)->
  makeItemHtml = (build)->
    deletedClass = if build.quantity > 0 then "" else "deleted"
    name     = "<div class='name'>#{build.short_name}</div>"
    quantity = "<div class='quantity'><input type='number' min='0' max='#{build.stock}' step='1' value='#{build.quantity}'></div>"
    price    = "<div class='price'>$#{build.retail_prices[CartDB.getCurrency()] *  build.quantity}</div>"
    image    = "<div class='image'><img src='#{build.variation.wholesale_image or ''}'></div>"
    return "<div class='item #{deletedClass}' build-id='#{build.id}'>\n\t#{name}\n\t#{quantity}\n\t#{price}\n\t#{image}\n</div>"
  
  makeItemsHtml = (state, builds)->
    rows = (makeItemHtml build for k, build of builds)
    state.container.html rows.join "\n"
    
    state.container.find(".quantity input").on "focus", (e)->
      elm = $(e.currentTarget)
      state.focussedId = elm.parents("[build-id]").attr "build-id"
    
    state.container.find(".quantity input").on "blur", (e)->
      elm = $(e.currentTarget)
      if state.focussedId is elm.parents("[build-id]").attr "build-id"
        state.focussedId = null
    
    state.container.find(".quantity input").on "change", (e)->
      setTimeout ()-> # Give the focus a chance to change
        elm = $(e.currentTarget)
        id = elm.parents("[build-id]").attr "build-id"
        build = CartDB.getBuildById id
        CartDB.setBuild build, elm.val()
  
  update = (state, builds, count)->
    state.container.empty() # Detaches event listeners, too :)
    if count > 0
      makeItemsHtml state, builds
      state.container.find("[build-id=#{state.focussedId}] input").focus()
    else
      state.container.html "<h3>Nothing yet... Commence shopping spree!</h3>"
  
  setup = (containerElm, i)->
    state =
      container: $ containerElm
      focussedId: null
    
    # Init
    CartDB.addCallback (builds, count)-> # Runs immediately
      update state, builds, count
  
  
  # INIT ##########################################################################################
  
  setup elm, i for elm, i in $ ".cart-items"
