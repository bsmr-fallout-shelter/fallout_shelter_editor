window.app = angular.module 'shelter', ['datatables', 'ui.bootstrap', 'ui.bootstrap-slider']

app.controller 'dwellersCtrl', ["$scope", "DTOptionsBuilder", "DTColumnDefBuilder", "$uibModal", ($scope, DTOptionsBuilder, DTColumnDefBuilder, $uibModal)->
  $scope.dtOptions = DTOptionsBuilder.newOptions().withPaginationType('full_numbers')
  $scope.dtColumnDefs = [
    DTColumnDefBuilder.newColumnDef(0),
    DTColumnDefBuilder.newColumnDef(1)
  ];

  $scope.shelter = JSON.parse(localStorage.getItem("shelter")) || {}
  $scope.dwellers = if localStorage.getItem("shelter") then $scope.shelter.dwellers.dwellers else []

  $scope.petInfo = (dweller)->
    if dweller.equippedPet
      dweller.equippedPet.extraData.uniqueName + "/" + dweller.equippedPet.extraData.bonus + "/" + dweller.equippedPet.extraData.bonusValue

  $scope.init = (shelter)->
    $scope.shelter = shelter
    $scope.dwellers = shelter.dwellers.dwellers
    localStorage.setItem("shelter", JSON.stringify(shelter))

  $scope.editDweller = (dweller)->
    modalInstance = $uibModal.open
      animation: $scope.animationsEnabled
      templateUrl: 'dweller-form'
      controller: 'dwellerCtrl'
      resolve:
        dweller: ->
          angular.copy(dweller)

    modalInstance.result.then (modifiedDweller)->
      dweller = $scope.dwellers.filter((d)->
        d.serializeId == modifiedDweller.serializeId
      )[0]
      angular.extend(dweller, modifiedDweller)
      localStorage.setItem("shelter", JSON.stringify($scope.shelter))

  $scope.saveShelter = ()->
    encrypt($scope.fileName, $scope.shelter)
]