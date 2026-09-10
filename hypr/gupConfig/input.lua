---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        -- 1: Cursor hovering changes focus
        -- 2: Cursor clicking changes focus
        -- 3: Cursor can't change kb focus, even by clicking
        follow_mouse = 2,

        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
    cursor = {
      hide_on_key_press = true,
    }
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "logitech-m510",
    sensitivity = -0.8,
})
