local UI = {}

UI.windows = {}

UI.keys = {
    up = false,
    down = false,
    enter = false
}

UI.latch = {
    enter = false,
    up = false,
    down = false
}

function draw_rounded_rect(x, y, w, h, r, c)
    x = x + r
    y = y + r
    w = w - r
    h = h - r

    valex.draw_filled_rect(x, y, w, h, c)
    valex.draw_filled_circle(w, h, r, c)
    valex.draw_filled_circle(x, h, r, c)
    valex.draw_filled_circle(x, y, r, c)
    valex.draw_filled_circle(w, y, r, c)
    valex.draw_filled_rect(w, y, w + r, h, c)
    valex.draw_filled_rect(x, h, w, h + r, c)
    valex.draw_filled_rect(x - r, y, x, h, c)
    valex.draw_filled_rect(x, y - r, w, y, c)
end

function draw_semirounded_rect(x, y, w, h, r, c)
    x = x + r
    y = y + r
    w = w - r
    h = h - r

    if r > h then r = h end

    valex.draw_filled_rect(x, y, w, h, c)
    valex.draw_filled_circle(x, y, r, c)
    valex.draw_filled_circle(w, y, r, c)
    valex.draw_filled_rect(w, y, w + r, h, c)
    valex.draw_filled_rect(x - r, y, x, h, c)
    valex.draw_filled_rect(x, y - r, w, y, c)
end

function UI:CreateWindow(args)
    local win = {
        x = args.x,
        y = args.y,
        w = args.w,
        h = args.h,
        r = args.Radius or 8,
        c = args.AccentColor or color3.new(0, 0.8, 1),
        bc = args.BackColor or color3.new(0.12, 0.12, 0.12),
        t = args.Title or "Window",
        v = args.Visible ~= false,
        items = {},
        selected = 1
    }

    function win:CreateButton(args)
        local btn = {
            type = "button",
            text = args.Text or "Button",
            bg = args.BackColor or color3.new(0.25, 0.25, 0.25),
            hoverBg = color3.new(
                math.min(btn.bg.r * 1.3, 1),
                math.min(btn.bg.g * 1.3, 1),
                math.min(btn.bg.b * 1.3, 1)
            ),
            TextColor = args.TextColor or color3.white(),
            callback = args.Callback
        }
        table.insert(self.items, btn)
        return btn
    end

    function win:CreateLabel(args)
        local lbl = {
            type = "label",
            text = args.Text or "",
            TextColor = args.TextColor or color3.white()
        }
        table.insert(self.items, lbl)
        return lbl
    end

    function win:CreateToggle(args)
        local tgl = {
            type = "toggle",
            text = args.Text or "Toggle",
            value = args.Value or false,
            bg = args.BackColor or color3.new(0.25, 0.25, 0.25),
            TextColor = args.TextColor or color3.white(),
            callback = args.Callback
        }
        table.insert(self.items, tgl)
        return tgl
    end

    table.insert(UI.windows, win)
    return win
end

function UI:Draw()
    for _, win in ipairs(UI.windows) do
        if not win.v then goto continue end

        -- Window shadow
        draw_rounded_rect(win.x - 2, win.y - 2, win.w + 4, win.h + 4, win.r + 2, color3.new(0, 0, 0, 0.3))
        
        -- Window border
        draw_rounded_rect(win.x - 1, win.y - 1, win.w + 1, win.h + 1, win.r, color3.new(0.3, 0.3, 0.3))
        
        -- Window background
        draw_rounded_rect(win.x, win.y, win.w, win.h, win.r, win.bc)

        -- Title bar with gradient effect
        draw_semirounded_rect(win.x, win.y, win.w, win.y + 40, win.r, win.c)
        
        -- Title shadow
        valex.draw_text(
            win.t,
            win.x / 2 + win.w / 2 + 1,
            win.y + 16,
            color3.new(0, 0, 0, 0.5)
        )
        
        -- Title text
        valex.draw_text(
            win.t,
            win.x / 2 + win.w / 2,
            win.y + 15,
            color3.white()
        )

        local iy = win.y + 55
        local itemSpacing = 10

        for index, item in ipairs(win.items) do
            local ix = win.x + 25
            local iw = win.w - 50
            local ih = 35

            if item.type == "label" then
                valex.draw_text(
                    item.text,
                    win.x + win.w / 2,
                    iy + 12,
                    item.TextColor
                )
                iy = iy + 25

            elseif item.type == "button" then
                local isSelected = index == win.selected
                local currentBg = isSelected and color3.new(
                    math.min(item.bg.r * 1.2, 1),
                    math.min(item.bg.g * 1.2, 1),
                    math.min(item.bg.b * 1.2, 1)
                ) or item.bg
                
                -- Button shadow
                draw_rounded_rect(ix + 1, iy + 1, iw, ih, 8, color3.new(0, 0, 0, 0.3))
                
                -- Button background
                draw_rounded_rect(ix, iy, iw, ih, 8, currentBg)
                
                -- Button border
                if isSelected then
                    draw_rounded_rect(ix - 1, iy - 1, iw + 2, ih + 2, 9, win.c)
                end
                
                -- Button text
                valex.draw_text(
                    item.text,
                    win.x + win.w / 2,
                    iy + 10,
                    item.TextColor
                )
                
                iy = iy + ih + itemSpacing

            elseif item.type == "toggle" then
                local isSelected = index == win.selected
                local currentBg = isSelected and color3.new(
                    math.min(item.bg.r * 1.2, 1),
                    math.min(item.bg.g * 1.2, 1),
                    math.min(item.bg.b * 1.2, 1)
                ) or item.bg
                
                -- Toggle container shadow
                draw_rounded_rect(ix + 1, iy + 1, iw, ih, 8, color3.new(0, 0, 0, 0.3))
                
                -- Toggle container background
                draw_rounded_rect(ix, iy, iw, ih, 8, currentBg)
                
                -- Toggle container border
                if isSelected then
                    draw_rounded_rect(ix - 1, iy - 1, iw + 2, ih + 2, 9, win.c)
                end
                
                -- Toggle text (left aligned)
                valex.draw_text(
                    item.text,
                    ix + 15,
                    iy + 10,
                    item.TextColor
                )
                
                -- Toggle switch background
                local switchX = iw - 40
                local switchY = iy + 10
                local switchW = 60
                local switchH = 15
                
                draw_rounded_rect(switchX, switchY, switchX + switchW, switchY + switchH, 7, 
                    color3.new(0.15, 0.15, 0.15))
                
                -- Toggle switch
                if item.value then
                    -- ON state (green)
                    draw_rounded_rect(switchX + switchW - 25, switchY + 2, 
                        switchX + switchW - 5, switchY + switchH - 2, 5, 
                        color3.new(0, 1, 0.4))
                    valex.draw_text("ON", switchX + 10, switchY + 8, color3.white())
                else
                    -- OFF state (red)
                    draw_rounded_rect(switchX + 5, switchY + 2, 
                        switchX + 25, switchY + switchH - 2, 5, 
                        color3.new(1, 0.3, 0.3))
                    valex.draw_text("OFF", switchX + 35, switchY + 8, color3.white())
                end
                
                iy = iy + ih + itemSpacing
            end
        end

        ::continue::
    end
end

function UI:UpdateNavigation()
    local down = valex.is_key_pressed(0x28)
    local up = valex.is_key_pressed(0x26)
    local enter = valex.is_key_pressed(0x0D)

    for _, win in ipairs(UI.windows) do
        if not win.v then goto continue end

        local items = win.items
        local count = #items
        if count == 0 then goto continue end

        win.selected = win.selected or 1

        local function skip(dir)
            local safety = 0
            while items[win.selected]
              and items[win.selected].type == "label" do
                win.selected = win.selected + dir
                if win.selected < 1 then win.selected = count end
                if win.selected > count then win.selected = 1 end
                safety = safety + 1
                if safety > count then break end
            end
        end

        if down and not UI.keys.down then
            win.selected = win.selected + 1
            if win.selected > count then win.selected = 1 end
            skip(1)
        end

        if up and not UI.keys.up then
            win.selected = win.selected - 1
            if win.selected < 1 then win.selected = count end
            skip(-1)
        end

        if enter and not UI.latch.enter then
            UI.latch.enter = true
            local item = items[win.selected]
            if item then
                if item.type == "button" and item.callback then
                    item.callback()
                elseif item.type == "toggle" then
                    item.value = not item.value
                    if item.callback then
                        item.callback(item.value)
                    end
                end
            end
        end

        if not enter then
            UI.latch.enter = false
        end

        ::continue::
    end

    UI.keys.down = down
    UI.keys.up = up
    UI.keys.enter = enter
end

return UI
