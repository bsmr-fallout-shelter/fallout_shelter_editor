window.app = angular.module 'shelter', ['datatables', 'ui.bootstrap', 'ui.bootstrap-slider', "angular-confirm"]

app.controller 'dwellersCtrl', ["$scope", "DTOptionsBuilder", "DTColumnDefBuilder", "$uibModal", "$confirm", ($scope, DTOptionsBuilder, DTColumnDefBuilder, $uibModal, $confirm)->
  $scope.dtOptions = DTOptionsBuilder.newOptions().withPaginationType('full_numbers')

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

  $scope.deleteDweller = (dweller)->
    $confirm(
      text: 'Are you sure you want to delete dweller?'
      title: "Delete #{dweller.name} #{dweller.lastName}"
      ok: 'Yes'
      cancel: 'No'
      ).then ()->
          $scope.dwellers.splice($scope.dwellers.indexOf(dweller), 1)

  $scope.saveShelter = ()->
    encrypt($scope.fileName, $scope.shelter)

  $scope.newDweller = ->
    if $scope.dwellers.length
      serializeId = Math.max.apply(Math, $scope.dwellers.map((d)-> d.serializeId)) + 1
    else
      serializeId = 1

    window.newDweller =
      IsEvictedWaitingForFollowers: false
      WillBeEvicted: false
      WillGoToWasteland: false
      assigned: false
      babyReady: false
      deathTime: -1
      equipedOutfit:
        hasBeenAssigned: false
        hasRandonWeaponBeenAssigned: false
        id: "jumpsuit"
        type: "Outfit"
      equipedWeapon:
        hasBeenAssigned: false
        hasRandonWeaponBeenAssigned: false
        id: "Fist"
        type: "Weapon"
      equipment:
        inventory:
          items: []
        storage:
          bonus:
            Energy: 0
            Food: 0
            Lunchbox: 0
            MrHandy: 0
            Nuka: 0
            PetCarrier: 0
            RadAway: 0
            StimPack: 0
            Water: 0
          resources:
            Energy: 0
            Food: 0
            Lunchbox: 0
            MrHandy: 0
            Nuka: 0
            PetCarrier: 0
            RadAway: 0
            StimPack: 0
            Water: 0
      experience:
        accum: 0
        currentLevel: 1
        experienceValue: 0
        needLvUp: false
        storage: 0
        wastelandExperience: 0
      gender: 1
      hair: "03"
      hairColor: 4294945618
      happiness:
        happinessValue: 50
      health:
        healthValue: 105
        lastLevelUpdated: 1
        maxHealth: 105
        permaDeath: false
        radiationValue: 0
      lastChildBorn: -1
      lastName: "Doe"
      name: "John"
      outfitColor: 4290196295
      pendingExperienceReward: 0
      pregnant: false
      rarity: "Normal"
      relations:
        ascendants: [-1, -1, -1, -1, -1, -1]
        lastPartner: -1
        partner: -1
        relations: []
      savedRoom: -1
      sawIncident: false
      serializeId: serializeId
      skinColor: 4287918423
      stats:
        stats: [
          { exp: 0, mod: 0, value: 1 }
          { exp: 0, mod: 0, value: 1 }
          { exp: 0, mod: 0, value: 1 }
          { exp: 0, mod: 0, value: 1 }
          { exp: 0, mod: 0, value: 1 }
          { exp: 0, mod: 0, value: 1 }
          { exp: 0, mod: 0, value: 1 }
          { exp: 0, mod: 0, value: 1 }
        ]
    modalInstance = $uibModal.open
      animation: $scope.animationsEnabled
      templateUrl: 'dweller-form'
      controller: 'dwellerCtrl'
      resolve:
        dweller: ->
          angular.copy(newDweller)

    modalInstance.result.then (newDweller)->
      $scope.dwellers.push(newDweller)
      localStorage.setItem("shelter", JSON.stringify($scope.shelter))
]