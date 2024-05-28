import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Timer;

using Toybox.System;
class VESCDashDFView extends WatchUi.View {
  hidden var field1 = "NC";
  hidden var field2 = "NC";
  hidden var field3 = "NC";
  hidden var field4 = "NC";
  hidden var field5 = "NC";
  hidden var field6 = "NC";
  hidden var field1_value = 0;
  hidden var field2_value = 0;
  hidden var field3_value = 0;
  hidden var field4_value = 0;
  hidden var field5_value = 0;
  hidden var field6_value = 0;

  // Set field names once to optimize ?
  /* TODO : COMM_GET_STATS							= 128
  request  case COMM_GET_STATS: {
        mTimeoutStats = 0;
        STAT_VALUES values;
        uint32_t mask = vb.vbPopFrontUint32();
        if (mask & ((uint32_t)1 << 0)) { values.speed_avg = vb.vbPopFrontDouble32Auto(); }
        if (mask & ((uint32_t)1 << 1)) { values.speed_max = vb.vbPopFrontDouble32Auto(); }
        if (mask & ((uint32_t)1 << 2)) { values.power_avg = vb.vbPopFrontDouble32Auto(); }
        if (mask & ((uint32_t)1 << 3)) { values.power_max = vb.vbPopFrontDouble32Auto(); }
        if (mask & ((uint32_t)1 << 4)) { values.current_avg = vb.vbPopFrontDouble32Auto(); }
        if (mask & ((uint32_t)1 << 5)) { values.current_max = vb.vbPopFrontDouble32Auto(); }
        if (mask & ((uint32_t)1 << 6)) { values.temp_mos_avg = vb.vbPopFrontDouble32Auto(); }
        if (mask & ((uint32_t)1 << 7)) { values.temp_mos_max = vb.vbPopFrontDouble32Auto(); }
        if (mask & ((uint32_t)1 << 8)) { values.temp_motor_avg = vb.vbPopFrontDouble32Auto(); }
        if (mask & ((uint32_t)1 << 9)) { values.temp_motor_max = vb.vbPopFrontDouble32Auto(); }
        if (mask & ((uint32_t)1 << 10)) { values.count_time = vb.vbPopFrontDouble32Auto(); }
        emit statsRx(values, mask);
    } break;
*/
  function getFieldValues() {}

  function initialize() {
    View.initialize();
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {}

  // Update the view
  function onUpdate(dc) {
    var gap;
    var scr_height = dc.getHeight();
    var scr_width = dc.getWidth();
    var fieldNameFont = Graphics.FONT_XTINY;
    var fieldValueFont = Graphics.FONT_XTINY;
    var fieldNameFontHeight = Graphics.getFontHeight(fieldNameFont);
    var fieldValueFontHeight = Graphics.getFontHeight(fieldValueFont);
    if (scr_width < 260) {
      gap = dc.getWidth() / 80;
      fieldNameFontHeight = fieldNameFontHeight - 4;
    } else {
      gap = dc.getWidth() / 40;
    }
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    dc.clear();

    if (vescData.drawLines) {
      dc.setColor(vescData.linesColor, Graphics.COLOR_BLACK);
      dc.drawLine(gap, scr_height / 2, scr_width - gap, scr_height / 2);
      dc.drawLine(
        scr_width / 2,
        2 * gap + (fieldNameFontHeight + fieldValueFontHeight),
        scr_width / 2,
        scr_height / 2 - 2 * gap
      );
      dc.drawLine(
        scr_width / 2,
        scr_height / 2 + 2 * gap,
        scr_width / 2,
        scr_height - 2 * gap - (fieldNameFontHeight + fieldValueFontHeight)
      );
    }
    if (vescData.paired == true) {
      dc.setColor(vescData.txtColor, Graphics.COLOR_TRANSPARENT);
    } else {
      dc.setColor(vescData.txtColor_unpr, Graphics.COLOR_TRANSPARENT);
    }

    dc.drawText(
      scr_width / 2,
      gap,
      fieldNameFont,
      field1,
      Graphics.TEXT_JUSTIFY_CENTER
    );
    dc.drawText(
      scr_width / 2,
      gap + fieldNameFontHeight,
      fieldValueFont,
      field1_value,
      Graphics.TEXT_JUSTIFY_CENTER
    );

    dc.drawText(
      scr_width / 4,
      scr_height / 4,
      fieldNameFont,
      field2,
      Graphics.TEXT_JUSTIFY_CENTER
    );
    dc.drawText(
      scr_width / 4,
      scr_height / 4 + fieldNameFontHeight,
      fieldValueFont,
      field2_value,
      Graphics.TEXT_JUSTIFY_CENTER
    );

    dc.drawText(
      scr_width - scr_width / 4,
      scr_height / 4,
      fieldNameFont,
      field3,
      Graphics.TEXT_JUSTIFY_CENTER
    );
    dc.drawText(
      scr_width - scr_width / 4,
      scr_height / 4 + fieldNameFontHeight,
      fieldValueFont,
      field3_value,
      Graphics.TEXT_JUSTIFY_CENTER
    );

    dc.drawText(
      scr_width / 4,
      scr_height / 2 + gap,
      fieldNameFont,
      field4,
      Graphics.TEXT_JUSTIFY_CENTER
    );
    dc.drawText(
      scr_width / 4,
      scr_height / 2 + gap + fieldNameFontHeight,
      fieldValueFont,
      field4_value,
      Graphics.TEXT_JUSTIFY_CENTER
    );

    dc.drawText(
      scr_width - scr_width / 4,
      scr_height / 2 + gap,
      fieldNameFont,
      field5,
      Graphics.TEXT_JUSTIFY_CENTER
    );
    dc.drawText(
      scr_width - scr_width / 4,
      scr_height / 2 + gap + fieldNameFontHeight,
      fieldValueFont,
      field5_value,
      Graphics.TEXT_JUSTIFY_CENTER
    );

    dc.drawText(
      scr_width / 2,
      scr_height - gap - fieldNameFontHeight - fieldValueFontHeight,
      fieldNameFont,
      field6,
      Graphics.TEXT_JUSTIFY_CENTER
    );

    dc.drawText(
      scr_width / 2,
      scr_height - gap - fieldValueFontHeight,
      fieldValueFont,
      field6_value,
      Graphics.TEXT_JUSTIFY_CENTER
    );
    if (!EUCAlarms.alarmType.equals("none")) {
      var textAlert = "!! Alarm: " + EUCAlarms.alarmType + " !!";
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
      dc.fillRectangle(
        0,
        scr_width / 2 - Graphics.getFontHeight(Graphics.FONT_SMALL) / 2,
        scr_width,
        Graphics.getFontHeight(Graphics.FONT_SMALL)
      );
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
      dc.drawLine(
        0,
        scr_width / 2 - Graphics.getFontHeight(Graphics.FONT_SMALL) / 2 - 1,
        scr_width,
        scr_width / 2 - Graphics.getFontHeight(Graphics.FONT_SMALL) / 2 - 1
      );
      dc.drawLine(
        0,
        scr_width / 2 + Graphics.getFontHeight(Graphics.FONT_SMALL) / 2 + 1,
        scr_width,
        scr_width / 2 + Graphics.getFontHeight(Graphics.FONT_SMALL) / 2 + 1
      );
      dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
      dc.drawText(
        scr_width / 2,
        scr_width / 2 - Graphics.getFontHeight(Graphics.FONT_SMALL) / 2,
        Graphics.FONT_SMALL,
        textAlert,
        Graphics.TEXT_JUSTIFY_CENTER
      );
    }
  }
}
