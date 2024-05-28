class VByteArray {
  var data;

  function initialize(data, PtypeIdx) {
    self.data = data.slice(PtypeIdx, null);
  }
  function getData() {
    return self.data;
  }
  function size() {
    return self.data.size();
  }

  function at(index) {
    return self.data[index];
  }

  function remove(start, count) {
    self.data = self.data.slice(start + count, null);
    // System.println(self.data.size());
  }

  function vbPopFrontInt64() {
    if (size() < 8) {
      return 0;
    }

    var res =
      (at(0) << 56) |
      (at(1) << 48) |
      (at(2) << 40) |
      (at(3) << 32) |
      (at(4) << 24) |
      (at(5) << 16) |
      (at(6) << 8) |
      at(7);

    remove(0, 8);
    return res;
  }

  function vbPopFrontUint64() {
    return vbPopFrontInt64(); // Same logic as vbPopFrontInt64
  }

  function vbPopFrontInt32() {
    if (size() < 4) {
      return 0;
    }

    var res = (at(0) << 24) | (at(1) << 16) | (at(2) << 8) | at(3);

    remove(0, 4);
    return res;
  }

  function vbPopFrontUint32() {
    return vbPopFrontInt32(); // Same logic as vbPopFrontInt32
  }

  function vbPopFrontInt16() {
    if (size() < 2) {
      return 0;
    }

    var res = ((((at(0) & 0xff) << 8) | (at(1) & 0xff)) << 16) >> 16;

    remove(0, 2);
    return res;
  }

  function vbPopFrontUint16() {
    return vbPopFrontInt16(); // Same logic as vbPopFrontInt16
  }

  function vbPopFrontInt8() {
    if (size() < 1) {
      return 0;
    }

    var res = at(0);

    remove(0, 1);
    return res;
  }

  function vbPopFrontUint8() {
    return vbPopFrontInt8(); // Same logic as vbPopFrontInt8
  }

  function vbPopFrontDouble64(scale) {
    return vbPopFrontInt64() / scale;
  }

  function vbPopFrontDouble32(scale) {
    return vbPopFrontInt32() / scale;
  }

  function vbPopFrontDouble16(scale) {
    return vbPopFrontInt16() / scale;
  }
}
