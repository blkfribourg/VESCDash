using Toybox.BluetoothLowEnergy as Ble;
using Toybox.System as Sys;

class eucPM {
  var EUC_SERVICE;
  var EUC_CHAR;
  var EUC_CHAR_W;

  private var eucProfileDef;

  function initInmotionV2orVESC() {
    eucProfileDef = {
      // Set the Profile
      :uuid => EUC_SERVICE,
      :characteristics => [
        {
          // Define the characteristics
          :uuid => EUC_CHAR_W, // UUID of the first characteristic
          :descriptors => [Ble.cccdUuid()],
        },
        {
          // Define the characteristics
          :uuid => EUC_CHAR, // UUID of the first characteristic
          :descriptors => [Ble.cccdUuid()],
        },
      ],
    };
  }
  function registerProfiles() {
    //System.println(eucProfileDef.toString());
    try {
      Ble.registerProfile(eucProfileDef);
    } catch (e) {
      //System.println("e=" + e.getErrorMessage());
    }
  }

  function setInmotionV2orVESC() {
    EUC_SERVICE = Ble.longToUuid(0x6e400001b5a3f393l, 0xe0a9e50e24dcca9el);
    EUC_CHAR = Ble.longToUuid(0x6e400003b5a3f393l, 0xe0a9e50e24dcca9el);
    EUC_CHAR_W = Ble.longToUuid(0x6e400002b5a3f393l, 0xe0a9e50e24dcca9el);

    self.initInmotionV2orVESC();
  }
  function setManager() {
    setInmotionV2orVESC();
  }
}
