app.controller 'dwellerCtrl', ["$scope", "$uibModalInstance", "dweller", ($scope, $uibModalInstance, dweller)->
  $scope.PET_BONUSES = ["XPBoost", "HappinessBoost", "FasterWastelandReturnSpeed", "Resistance"]
  $scope.PET_TYPES = [
    { id: "abyssinian_c", label: "Abyssinian" },
    { id: "boxer_c", label: "Boxer" },
    { id: "husky_c", label: "Husky" },
    { id: "persian_c", label: "Persian" }
  ]
  $scope.dweller = dweller

  $scope.addPet = ->
    $scope.dweller.equippedPet =
      hasBeenAssigned: false
      hasRandonWeaponBeenAssigned: false
      type: "Pet"

  $scope.removePet = ->
    $scope.dweller.equippedPet = null

  $scope.ok = ->
    $uibModalInstance.close($scope.dweller)

  $scope.cancel = ->
    $uibModalInstance.dismiss('cancel')
]
