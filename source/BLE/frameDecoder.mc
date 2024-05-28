import Toybox.Lang;
using Toybox.BluetoothLowEnergy as Ble;
using Toybox.Time;

module frameDecoder {
  function init() {
    return new VESCDecoder();
  }

  class VESCDecoder {
    var packetID = 0x2f;
    var packetEnd = 0x03;
    var frame = [0]b;
    var status = "unknown";
    var startDistance = null;
    var PtypeIdx = 2;
    function frameBuilder(bleDelegate, value) {
      //System.println(value);
      if (frame.size() == 1 && frame[0] == 0) {
        status = "append";
        frame = value;
      } else {
        if (status.equals("append")) {
          frame.addAll(value);
        }
      }

      if (value[value.size() - 1] == 0x03 && value.size() < 20) {
        status = "complete";
        if (checkValid(frame)) {
          System.println("frameOK");
          var transmittedFrame = frame;
          frameBuffer(bleDelegate, transmittedFrame);
        }
        frame = [0]b;
        status = "unknown";
      }
    }
    function checkValid(frame) {
      //simply checking annonced size if OK
      var chksum = frame.slice(frame.size() - 3, frame.size() - 1);
      var compute_chcksum = CRC16.crc16(frame.slice(2, frame.size() - 3));
      if (chksum.equals(compute_chcksum)) {
        return true;
      } else {
        return false;
      }
    }
    function frameBuffer(bleDelegate, transmittedFrame) {
      var size = transmittedFrame.size();
      var vb = new VByteArray(transmittedFrame, 2); // skip the 2 firt bytes (type & size)
      var mTimeoutValuesSetup = 0;
      var comm_packet_id = vb.vbPopFrontUint8();
      //System.println(comm_packet_id);
      var mask = 0xffffffff;
      // mask = vb.vbPopFrontUint32();

      if ((mask & (1 << 0)) != 0) {
        vescData.temperature = vb.vbPopFrontDouble16(10.0);
      }

      if ((mask & (1 << 1)) != 0) {
        vescData.temperature_motor = vb.vbPopFrontDouble16(10.0);
      }

      if ((mask & (1 << 2)) != 0) {
        vescData.Phcurrent = vb.vbPopFrontDouble32(100.0);
      }
      if ((mask & (1 << 3)) != 0) {
        vescData.current = vb.vbPopFrontDouble32(100.0);
      }
      if ((mask & (1 << 4)) != 0) {
        var temp_PWM = vb.vbPopFrontDouble16(10.0).abs();
        if (temp_PWM >= 0.0 && temp_PWM <= 100.0) {
          // sanity check
          vescData.hPWM = temp_PWM;
        }
      }
      if ((mask & (1 << 5)) != 0) {
        vescData.rpm = vb.vbPopFrontDouble32(1);
      }
      if ((mask & (1 << 6)) != 0) {
        vescData.speed = vb.vbPopFrontDouble32(1000.0).abs() * 3.6;
      }
      if ((mask & (1 << 7)) != 0) {
        vescData.voltage = vb.vbPopFrontDouble16(10.0);
      }
      if ((mask & (1 << 8)) != 0) {
        vescData.battery = vb.vbPopFrontDouble16(10.0);
      }
      if ((mask & (1 << 9)) != 0) {
        vescData.amp_hours = vb.vbPopFrontDouble32(10000.0);
      }
      if ((mask & (1 << 10)) != 0) {
        vescData.amp_hours_charged = vb.vbPopFrontDouble32(10000.0);
      }
      if ((mask & (1 << 11)) != 0) {
        vescData.watt_hours = vb.vbPopFrontDouble32(10000.0);
      }
      if ((mask & (1 << 12)) != 0) {
        vescData.watt_hours_charged = vb.vbPopFrontDouble32(10000.0);
      }
      if ((mask & (1 << 13)) != 0) {
        vescData.tachometer = vb.vbPopFrontDouble32(1000.0);
      }
      if ((mask & (1 << 14)) != 0) {
        vescData.tachometer_abs = vb.vbPopFrontDouble32(1000.0);
      }
      if ((mask & (1 << 15)) != 0) {
        vescData.position = vb.vbPopFrontDouble32(1000000.0);
      }
      if ((mask & (1 << 16)) != 0) {
        vescData.fault_code = vb.vbPopFrontInt8();
        vescData.fault_str = faultToStr(vescData.fault_code);
      }
      if ((mask & (1 << 17)) != 0) {
        vescData.vesc_id = vb.vbPopFrontUint8();
      }
      if ((mask & (1 << 18)) != 0) {
        vescData.num_vescs = vb.vbPopFrontUint8();
      }
      if ((mask & (1 << 19)) != 0) {
        vescData.battery_wh = vb.vbPopFrontDouble32(1000.0);
      }
      if ((mask & (1 << 20)) != 0) {
        var totalDistance = vb.vbPopFrontUint32() / 1000.0;

        vescData.totalDistance = totalDistance;

        //vescData.totalDistance != 0: potential fix for avg speed issue on vesc
        if (startDistance == null && vescData.totalDistance != 0.0) {
          startDistance = vescData.totalDistance;
        }
        if (startDistance != null) {
          vescData.tripDistance = vescData.totalDistance - startDistance;
        }
      }
      if ((mask & (1 << 21)) != 0) {
        vescData.uptime_ms = vb.vbPopFrontUint32();
      }
      /*
      vescData.temperature =
        transmittedFrame.decodeNumber(Lang.NUMBER_FORMAT_SINT16, {
          :offset => 1 + PtypeIdx,
          :endianness => Lang.ENDIAN_BIG,
        }) / 10.0;

      vescData.current =
        transmittedFrame.decodeNumber(Lang.NUMBER_FORMAT_SINT32, {
          :offset => 9 + PtypeIdx,
          :endianness => Lang.ENDIAN_BIG,
        }) / 100.0;

      vescData.hPWM =
        transmittedFrame
          .decodeNumber(Lang.NUMBER_FORMAT_SINT16, {
            :offset => 13 + PtypeIdx,
            :endianness => Lang.ENDIAN_BIG,
          })
          .abs() / 10.0;

      var speed =
        transmittedFrame
          .decodeNumber(Lang.NUMBER_FORMAT_SINT32, {
            :offset => 19 + PtypeIdx,
            :endianness => Lang.ENDIAN_BIG,
          })
          .abs() / 1000.0;

      vescData.speed = speed * 3.6;

      vescData.voltage =
        transmittedFrame.decodeNumber(Lang.NUMBER_FORMAT_SINT16, {
          :offset => 23 + PtypeIdx,
          :endianness => Lang.ENDIAN_BIG,
        }) / 10.0;

      vescData.battery =
        transmittedFrame.decodeNumber(Lang.NUMBER_FORMAT_SINT16, {
          :offset => 25 + PtypeIdx,
          :endianness => Lang.ENDIAN_BIG,
        }) / 10.0;

      var totalDistance =
        transmittedFrame.decodeNumber(Lang.NUMBER_FORMAT_UINT32, {
          :offset => 62 + PtypeIdx,
          :endianness => Lang.ENDIAN_BIG,
        }) / 1000.0; // in km

      vescData.totalDistance = totalDistance;

      //vescData.totalDistance != 0: potential fix for avg speed issue on vesc
      if (startDistance == null && vescData.totalDistance != 0) {
        startDistance = vescData.totalDistance;
      }
      vescData.tripDistance = vescData.totalDistance - startDistance;
*/
    }

    function faultToStr(fault) {
      switch (fault) {
        case 0:
          return "FAULT_CODE_NONE";
        case 1:
          return "FAULT_CODE_OVER_VOLTAGE";
        case 2:
          return "FAULT_CODE_UNDER_VOLTAGE";
        case 3:
          return "FAULT_CODE_DRV";
        case 4:
          return "FAULT_CODE_ABS_OVER_CURRENT";
        case 5:
          return "FAULT_CODE_OVER_TEMP_FET";
        case 6:
          return "FAULT_CODE_OVER_TEMP_MOTOR";
        case 7:
          return "FAULT_CODE_GATE_DRIVER_OVER_VOLTAGE";
        case 8:
          return "FAULT_CODE_GATE_DRIVER_UNDER_VOLTAGE";
        case 9:
          return "FAULT_CODE_MCU_UNDER_VOLTAGE";
        case 10:
          return "FAULT_CODE_BOOTING_FROM_WATCHDOG_RESET";
        case 11:
          return "FAULT_CODE_ENCODER_SPI";
        case 12:
          return "FAULT_CODE_ENCODER_SINCOS_BELOW_MIN_AMPLITUDE";
        case 13:
          return "FAULT_CODE_ENCODER_SINCOS_ABOVE_MAX_AMPLITUDE";
        case 14:
          return "FAULT_CODE_FLASH_CORRUPTION";
        case 15:
          return "FAULT_CODE_HIGH_OFFSET_CURRENT_SENSOR_1";
        case 16:
          return "FAULT_CODE_HIGH_OFFSET_CURRENT_SENSOR_2";
        case 17:
          return "FAULT_CODE_HIGH_OFFSET_CURRENT_SENSOR_3";
        case 18:
          return "FAULT_CODE_UNBALANCED_CURRENTS";
        case 19:
          return "FAULT_CODE_BRK";
        case 20:
          return "FAULT_CODE_RESOLVER_LOT";
        case 21:
          return "FAULT_CODE_RESOLVER_DOS";
        case 22:
          return "FAULT_CODE_RESOLVER_LOS";
        case 23:
          return "FAULT_CODE_FLASH_CORRUPTION_APP_CFG";
        case 24:
          return "FAULT_CODE_FLASH_CORRUPTION_MC_CFG";
        case 25:
          return "FAULT_CODE_ENCODER_NO_MAGNET";
        case 26:
          return "FAULT_CODE_ENCODER_MAGNET_TOO_STRONG";
        case 27:
          return "FAULT_CODE_PHASE_FILTER";
        case 28:
          return "FAULT_CODE_ENCODER_FAULT";
        default:
          return "Unknown fault";
      }
    }
  }
}
