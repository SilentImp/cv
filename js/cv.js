requirejs([
  'modernizr',
  'domReady',
  'CVController'
  ],function(
    modernizr,
    domReady, 
    CVController
  ){
  domReady(function () {
    document.cv = new CVController()
  });
});