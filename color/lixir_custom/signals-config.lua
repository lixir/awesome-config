-----------------------------------------------------------------------------------------------------------------------
--                                                Signals config                                                     --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")


-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local signals = {}

-- Support functions
-----------------------------------------------------------------------------------------------------------------------
local function do_sloppy_focus(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
		client.focus = c
	end
end

local function fixed_maximized_geometry(c, context)
	if c.maximized and context ~= "fullscreen" then
		c:geometry({
			x = c.screen.workarea.x,
			y = c.screen.workarea.y,
			height = c.screen.workarea.height - 2 * c.border_width,
			width = c.screen.workarea.width - 2 * c.border_width
		})
	end
end

-- Build  table
-----------------------------------------------------------------------------------------------------------------------
function signals:init(args)

	local args = args or {}
	local env = args.env

	-- actions on every application start
	client.connect_signal(
		"manage",
		function(c)
			-- put client at the end of list
			if env.set_slave then awful.client.setslave(c) end

			-- startup placement
			if awesome.startup
			   and not c.size_hints.user_position
			   and not c.size_hints.program_position
			then
				awful.placement.no_offscreen(c)
			end
		end
	)

	-- add missing borders to windows that get unmaximized
	client.connect_signal(
		"property::maximized",
		function(c)
			if not c.maximized then
				c.border_width = beautiful.border_width
			end
		end
	)

	-- don't allow maximized windows move/resize themselves
	client.connect_signal(
		"request::geometry", fixed_maximized_geometry
	)

	-- enable sloppy focus, so that focus follows mouse
	if env.sloppy_focus then
		client.connect_signal("mouse::enter", do_sloppy_focus)
	end

	-- hilight border of focused window
	-- can be disabled since focus indicated by titlebars in current config
	local black = "#000000"

	client.connect_signal("focus",   function(c)
			c.border_color = beautiful.border_focus or black
			--c.opacity = 1
		end
	)

	client.connect_signal("unfocus", function(c)
			c.border_color = beautiful.border_normal or black
			--c.opacity = 0.9
		end
	)

	-- wallpaper update on screen geometry change
	screen.connect_signal("property::geometry", env.wallpaper)

	-- Awesome v4.0 introduce screen handling without restart.
	-- Since I'm using single monitor setup and I'm too lazy to rework my panel widgets for this new feature,
	-- simple adding signal to restart wm on new monitor pluging.
	-- For reference, screen-dependent widgets are
	-- redflat.widget.layoutbox, redflat.widget.taglist, redflat.widget.tasklist
	screen.connect_signal("list", awesome.restart)

	-- wallpaper update on tag change
	awful.tag.attached_connect_signal(s ,"property::selected",
			function(t)

                local sel = awful.tag.object.get_index(t)
                if sel and beautiful.wallpaper[sel] then
                    gears.wallpaper.maximized(beautiful.wallpaper[sel], sel)
                end

		 	end
    )
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return signals
