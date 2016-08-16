describe 'Recipes controller', ->
  scope        = null
  ctrl         = null
  location     = null
  routeParams  = null
  resource     = null
  http = null
  
  setupController =(keywords,results)->
    inject(($location,$routeParams,$rootScope,$resource,$controller,$httpBackend)->
      scope = $rootScope.$new()
      location = $location
      resource = $resource
      routeParams = $routeParams
      routeParams.keywords = keywords
      http = $httpBackend

      if results
        request = new RegExp("\/recipes.*keywords=#{keywords}")
        http.expectGET(request).respond(results)
        
      ctrl = $controller('RecipesController', $scope: scope, $location: location)
    )
    
  beforeEach(module('recipes'))
  afterEach ->
    http.verifyNoOutstandingExpectation()
    http.verifyNoOutstandingRequest()
  
  describe 'Controller initialization', ->
    
    describe 'When no keywords present', ->
      beforeEach(setupController())
      it 'defaults to no recipes', ->
        expect(scope.recipe_list).toEqualData([])
        
    describe 'With keywords present',->
      keywords = 'foo'
      recipes = [
        {
          id: 2
          name: 'Baked Potatoes'
        },
        {
          id: 4
          name: 'Potatoes Au Gratin'
        }
      ]
      beforeEach ->
        setupController(keywords,recipes)
        http.flush()
      it 'calls the back-end', ->
        expect(scope.recipe_list).toEqualData(recipes)
      
  describe 'Search',->
    beforeEach(setupController())
    it 'Manipulates location so redirecting to the current path with the keywords as query string parameters',->
      keywords = 'foo'
      scope.search(keywords)
      expect(location.path()).toBe('/')
      expect(location.search()).toEqualData({ keywords: keywords} )
    