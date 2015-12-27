app.controller 'dwellerCtrl', ["$scope", "$uibModalInstance", "dweller", ($scope, $uibModalInstance, dweller)->
  $scope.dweller = dweller

  $scope.ok = ->
    $uibModalInstance.close($scope.dweller)

  $scope.cancel = ->
    $uibModalInstance.dismiss('cancel')
]
