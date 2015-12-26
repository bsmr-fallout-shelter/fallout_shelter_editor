app = angular.module 'shelter', ['datatables']

app.controller 'dwellersController', ($scope, DTOptionsBuilder, DTColumnDefBuilder) ->
  $scope.dtOptions = DTOptionsBuilder.newOptions().withPaginationType('full_numbers')
  $scope.dtColumnDefs = [
    DTColumnDefBuilder.newColumnDef(0),
    DTColumnDefBuilder.newColumnDef(1)
  ];
  $scope.dwellers = []

  $scope.petInfo = (dweller) ->
    if dweller.equippedPet
      dweller.equippedPet.extraData.uniqueName + "/" + dweller.equippedPet.extraData.bonus + "/" + dweller.equippedPet.extraData.bonusValue