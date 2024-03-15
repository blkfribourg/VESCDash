using Toybox.Math;
using Toybox.System;
var rd = 0;
function dummyGen() {
  eucData.paired = true;
  eucData.voltage = 60;
  rd = rd + 1;
  if (rd > 100) {
    rd = -5;
  }
  System.println(rd);
  eucData.hPWM = rd;
}
