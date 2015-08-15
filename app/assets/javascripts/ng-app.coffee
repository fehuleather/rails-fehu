angular.module "Core", [
  # Libs
  "ngRoute"
  "ngTouch"
  
  # Components
  "Deleter"
  "Editable"
  "StockQuantity"
  
  # Scripts
  "bimg"
]

angular.module "FehuApp", [
  # Also include Core
  "Core"
  
  # Components
  "Product"
  "ProductInfo"
  "Variations"
  
  # Pages
  "About"
  "Events"
  "Locations"
  "Shop"
  
  # Scripts
  "PageStyle"
  "Products"
  "StubProducts"
  "StubLocations"
]

.config new Array "$locationProvider, $routeProvider", ($locationProvider, $routeProvider)->
  $locationProvider.html5Mode enabled:true, requireBase:false
  
  $routeProvider
    .when "/about",
      controller: "AboutCtrl"
      templateUrl: "<%= asset_path('pages/about.html') %>"
    .when "/events",
      controller: "EventsCtrl"
      templateUrl: "<%= asset_path('pages/events.html') %>"
    .when "/locations",
      controller: "LocationsCtrl"
      templateUrl: "<%= asset_path('pages/locations.html') %>"
    .when "/",
      controller: "ShopCtrl"
      templateUrl: "<%= asset_path('pages/shop.html') %>"
    .otherwise
      template: ""
      controller: ($route, $location, $window)->
        # Force Rails to handle this route
        document.location.reload()
