-----------------------------------------------------------------------------------------------------------------------
--                                               Desktop widgets config                                              --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local beautiful = require("beautiful")
--local awful = require("awful")
local redflat = require("redflat")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local desktop = {}

local wa = mouse.screen.workarea

-- Desktop widgets
-----------------------------------------------------------------------------------------------------------------------
function desktop:init(args)
	if not beautiful.desktop then return end

	args = args or {}
	local env = args.env or {}
	local autohide = env.desktop_autohide or false

	-- Calendar
	--------------------------------------------------------------------------------
	local cwidth = 150 -- calendar widget width
	local cy = beautiful.panel_height      -- calendar widget upper margin
	local cheight = wa.height - 2*cy

	local calendar = {
		args     = { timeout = 60 },
		geometry = { x = wa.width - cwidth, y = cy, width = cwidth, height = cheight }
	}


	-- Initialize all desktop widgets
	--------------------------------------------------------------------------------

	calendar.body = redflat.desktop.calendar(calendar.args, calendar.style)

	-- Desktop setup
	--------------------------------------------------------------------------------
	local desktop_objects = {
		calendar
	}

	if not autohide then
		redflat.util.desktop.build.static(desktop_objects)
	else
		redflat.util.desktop.build.dynamic(desktop_objects, nil, beautiful.desktopbg, args.buttons)
	end

	calendar.body:activate_wibox(calendar.wibox)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return desktop
