var key = [2815074099, 1725469378, 4039046167, 874293617, 3063605751, 3133984764, 4097598161, 3620741625];
var iv = sjcl.codec.hex.toBits("7475383967656A693334307438397532");
sjcl.beware["CBC mode is dangerous because it doesn't protect message integrity."]();

function handleFileSelect(e) {
  try {
    e.stopPropagation();
    e.preventDefault();
    var f = e.target.files[0];
    var fileName = f.name;
    if (f.size > 1e7) {
      throw "File exceeds maximum size of 10MB"
    }
    if (f) {
      var reader = new FileReader;
      if (e.target.id == "sav_file") {
        reader.onload = function (evt2) {
          try {
            var shelter = decrypt(reader.result);
            scope = angular.element($('body').get(0)).scope();
            scope.$apply(function() {
              scope.init(shelter);
            });
          } catch (e) {
            alert("Error: " + e)
          }
        };
        reader.readAsText(f)
      } else if (e.target.id == "json_file") {
        reader.onload = function (evt2) {
          try {
            encrypt(evt2, fileName, reader.result);
          } catch (e) {
            alert("Error: " + e)
          }
        };
        reader.readAsText(f)
      }
    }
  } catch (e) {
    alert("Error: " + e)
  } finally {
    e.target.value = null
  }
}

function decrypt(base64Str) {
  var cipherBits = sjcl.codec.base64.toBits(base64Str);
  var prp = new sjcl.cipher.aes(key);
  var plainBits = sjcl.mode.cbc.decrypt(prp, cipherBits, iv);
  var jsonStr = sjcl.codec.utf8String.fromBits(plainBits);
  return JSON.parse(jsonStr);
}

function encrypt(fileName, save) {
  var compactJsonStr = JSON.stringify(save);
  var plainBits = sjcl.codec.utf8String.toBits(compactJsonStr);
  var prp = new sjcl.cipher.aes(key);
  var cipherBits = sjcl.mode.cbc.encrypt(prp, plainBits, iv);
  var base64Str = sjcl.codec.base64.fromBits(cipherBits);
  var blob = new Blob([base64Str], {
    type: "text/plain"
  });

  saveAs(blob, fileName.replace(".txt", ".sav").replace(".json", ".sav"))
}
$(function(){
  $("#sav_file").on("change", handleFileSelect);
});