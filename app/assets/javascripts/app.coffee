recipes = angular.module('recipes',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
])

recipes.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
])

controllers = angular.module('controllers',[])