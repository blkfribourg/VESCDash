using Toybox.Math;
using Toybox.System;
var rd = 0;
function dummyGen() {
  vescData.paired = true;
  vescData.voltage = 60;
  rd = rd + 1;
  if (rd > 100) {
    rd = -5;
  }
  System.println(rd);
  vescData.hPWM = rd;
}
