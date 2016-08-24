describe "RecipeController", ->
  scope        = null
  ctrl         = null
  routeParams  = null
  httpBackend  = null
  flash = null
  recipeId     = 42

  fakeRecipe   =
    id: recipeId
    name: "Baked Potatoes"
    instructions: "Pierce potato with fork, nuke for 20 minutes"

  setupController =(recipeExists=true)->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller, _flash_)->
      scope       = $rootScope.$new()
      location    = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      flash = _flash_
      routeParams.recipeId = recipeId
      
      mocked_request = new RegExp("\/recipes/#{recipeId}")
      results = if recipeExists
        [200,fakeRecipe]
      else
        [400]
        
      httpBackend.expectGET(mocked_request).respond(results[0],results[1])

      ctrl = $controller('RecipeController', $scope: scope)
    )

  beforeEach(module("recipes"))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()
    
  describe 'controller initialization', ->
    describe 'recipe is found', ->
      beforeEach(setupController())
      it 'loads the given recipe', ->
        httpBackend.flush()
        expect(scope.recipe).toEqualData(fakeRecipe)
    describe 'recipe is not found',->
      beforeEach(setupController(false))
      it 'loads the given recipe',->
        httpBackend.flush()
        expect(scope.recipe).toBe(null)
        expect(flash.error).toBe("There is no recipe with ID #{recipeId}")