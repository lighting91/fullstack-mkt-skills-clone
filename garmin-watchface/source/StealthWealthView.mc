import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.ActivityMonitor;
import Toybox.Time;
import Toybox.Time.Gregorian;

// =============================================================================
//  StealthWealth Watch Face — Garmin Forerunner 965 (454 × 454 AMOLED)
//
//  Theme : "Stealth Wealth – Luxury Minimal"
//  Palette
//    #000000  Background  – pure AMOLED black (pixels off = no power draw)
//    #C9A84C  Gold        – warm metallic, slightly desaturated
//    #8A7035  Gold Dim    – 65% brightness, secondary labels
//    #1E1508  Gold Trace  – near-invisible, used for divider line only
//
//  Layout (24-hour, 4 fields max)
//    ┌──────────────────────────────┐
//    │         MON  25              │  ← date,    y=84,  FONT_TINY,  Gold Dim
//    │         ─────                │  ← divider, y=100, 1px,        Gold Trace
//    │                              │
//    │         21:45                │  ← time,    y=210, FONT_NUMBER_MILD, Gold
//    │                              │
//    │   4,231          87%         │  ← steps/battery, y=374, FONT_SMALL, Gold Dim
//    └──────────────────────────────┘
// =============================================================================

class StealthWealthView extends WatchUi.WatchFace {

    // --- Palette ----------------------------------------------------------
    private const COLOR_BG        = 0x000000;   // Pure black
    private const COLOR_GOLD      = 0xC9A84C;   // Metallic warm gold
    private const COLOR_GOLD_DIM  = 0x8A7035;   // 65% gold — secondary text
    private const COLOR_DIVIDER   = 0x1E1508;   // Barely-visible gold trace

    // --- Day name lookup --------------------------------------------------
    private const DAY_NAMES = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];

    // --- State ------------------------------------------------------------
    private var _isAwake as Boolean = true;

    // -----------------------------------------------------------------------

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        // All drawing is programmatic — no XML layout used.
    }

    function onShow()  as Void {}
    function onHide()  as Void {}

    // Called when wrist is raised / button pressed
    function onExitSleep() as Void {
        _isAwake = true;
        WatchUi.requestUpdate();
    }

    // Called when display enters low-power sleep mode
    function onEnterSleep() as Void {
        _isAwake = false;
        WatchUi.requestUpdate();
    }

    // -----------------------------------------------------------------------
    //  Main render pass
    // -----------------------------------------------------------------------
    function onUpdate(dc as Dc) as Void {
        var w  = dc.getWidth();    // 454
        var h  = dc.getHeight();   // 454
        var cx = w / 2;            // 227

        // 1. Fill AMOLED black ──────────────────────────────────────────────
        dc.setColor(COLOR_BG, COLOR_BG);
        dc.clear();

        if (!_isAwake) {
            _drawSleepFace(dc, w, h, cx);
            return;
        }

        // 2. Date (top) ─────────────────────────────────────────────────────
        _drawDate(dc, cx, 84);

        // 3. Subtle divider below date ──────────────────────────────────────
        dc.setColor(COLOR_DIVIDER, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawLine(cx - 36, 100, cx + 36, 100);

        // 4. Time (center) ──────────────────────────────────────────────────
        _drawTime(dc, cx, 210);

        // 5. Steps (bottom-left) + Battery (bottom-right) ───────────────────
        _drawSteps(dc, w / 4, 374);
        _drawBattery(dc, 3 * w / 4, 374);
    }

    // -----------------------------------------------------------------------
    //  Sleep / always-on face — only time, deeply dimmed
    // -----------------------------------------------------------------------
    private function _drawSleepFace(dc as Dc, w as Number, h as Number, cx as Number) as Void {
        var clockTime = System.getClockTime();
        var timeStr   = _fmtTime(clockTime.hour, clockTime.min);

        // Render at ~30% gold brightness to respect AMOLED power budget
        dc.setColor(0x3C3015, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            cx, h / 2,
            Graphics.FONT_NUMBER_MILD,
            timeStr,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    // -----------------------------------------------------------------------
    //  Date — "MON  25" spaced for luxury feel
    // -----------------------------------------------------------------------
    private function _drawDate(dc as Dc, cx as Number, y as Number) as Void {
        var info    = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayName = DAY_NAMES[info.day_of_week - 1];
        // Two spaces between day name and date number — adds breathing room
        var dateStr = Lang.format("$1$  $2$", [dayName, info.day.format("%02d")]);

        dc.setColor(COLOR_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            cx, y,
            Graphics.FONT_TINY,
            dateStr,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    // -----------------------------------------------------------------------
    //  Time — 24-hour HH:MM, no seconds
    // -----------------------------------------------------------------------
    private function _drawTime(dc as Dc, cx as Number, y as Number) as Void {
        var clockTime = System.getClockTime();
        var timeStr   = _fmtTime(clockTime.hour, clockTime.min);

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            cx, y,
            // FONT_NUMBER_MILD — cleaner, less aggressive than FONT_NUMBER_HOT
            // Replace with Rez.Fonts.TimeFont for a custom thin typeface
            Graphics.FONT_NUMBER_MILD,
            timeStr,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    // -----------------------------------------------------------------------
    //  Steps — formatted with thousands separator
    // -----------------------------------------------------------------------
    private function _drawSteps(dc as Dc, x as Number, y as Number) as Void {
        var actInfo  = ActivityMonitor.getInfo();
        var steps    = (actInfo != null && actInfo.steps != null) ? actInfo.steps : 0;
        var stepsStr = _fmtThousands(steps);

        dc.setColor(COLOR_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, y,
            Graphics.FONT_SMALL,
            stepsStr,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    // -----------------------------------------------------------------------
    //  Battery — "87%" no icon, no label
    // -----------------------------------------------------------------------
    private function _drawBattery(dc as Dc, x as Number, y as Number) as Void {
        var stats   = System.getSystemStats();
        var pct     = stats.battery.toNumber();
        var battStr = Lang.format("$1$%", [pct.format("%d")]);

        dc.setColor(COLOR_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, y,
            Graphics.FONT_SMALL,
            battStr,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    // -----------------------------------------------------------------------
    //  Helpers
    // -----------------------------------------------------------------------

    // Zero-padded 24-hour time string
    private function _fmtTime(hour as Number, min as Number) as String {
        return Lang.format("$1$:$2$", [
            hour.format("%02d"),
            min.format("%02d")
        ]);
    }

    // 4231 → "4,231"   999 → "999"
    private function _fmtThousands(n as Number) as String {
        if (n < 1000) {
            return n.format("%d");
        }
        var thousands = (n / 1000).toNumber();
        var remainder = n - (thousands * 1000);
        return Lang.format("$1$,$2$", [
            thousands.format("%d"),
            remainder.format("%03d")
        ]);
    }
}
