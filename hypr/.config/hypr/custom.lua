-- Personal ML4W/Hyprland overrides.
-- Apple T2 MacBook keyboard backlight controls.

local keyboard_step = "10%"

hl.bind(
	"XF86KbdBrightnessUp",
	hl.dsp.exec_cmd("brightnessctl -q -d ':white:kbd_backlight' set " .. keyboard_step .. "+"),
	{
		locked = true,
		repeating = true,
		description = "Increase keyboard brightness",
	}
)

hl.bind(
	"XF86KbdBrightnessDown",
	hl.dsp.exec_cmd("brightnessctl -q -d ':white:kbd_backlight' set " .. keyboard_step .. "-"),
	{
		locked = true,
		repeating = true,
		description = "Decrease keyboard brightness",
	}
)
