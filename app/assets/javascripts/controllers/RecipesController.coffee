controllers = angular.module('controllers')
controllers.controller("RecipesController", [ '$scope', '$routeParams', '$location', '$resource',
  ($scope,$routeParams,$location,$resource)->
    $scope.search = (keywords)-> $location.path("/").search('keywords',keywords)
    Recipe = $resource('/recipes', { format: 'json' })
    
    if $routeParams.keywords
      Recipe.query(keywords: $routeParams.keywords, (results)-> $scope.recipe_list = results)
    else
      $scope.recipe_list = []
    
    $scope.view = (recipeId)-> 
      $location.path("/recipes/#{recipeId}")
      
    $scope.newRecipe = ()->
      $location.path("/recipes/new")

    $scope.edit = (recipeId)->
      $location.path("/recipes/#{recipeId}/edit")
])