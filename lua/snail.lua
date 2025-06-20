math.randomseed(os.time())

EPSILON = 0.001
return {
    default_opts = {
        max_move_speed = 0.01,
        new_aim_pos_chance = 0.005,
        slowdown_threshold = 0.005,
        snailleft = {"󱙷"},
        snailidle = {"꩜"},
        snailright = {"󱙷"},
        tanksize = 15,
    },
    new_snail = function()
        return {
            position = 0.5,
            direction = 1,
            aiming = nil,
        }
    end,
    walk = function(snail, opts)
        local rng = math.random()
        if rng < opts.new_aim_pos_chance then 
            snail.aiming = math.random()
            snail.direction = 1
                if snail.aiming < snail.position then
                    snail.direction = -1
                end
        end
        if snail.aiming then
            local speed = opts.max_move_speed
            if math.abs(snail.aiming - snail.position) < opts.slowdown_threshold then
                snail.direction = 0
            end
            snail.position = snail.position + speed * snail.direction
        end
        if snail.position < 0 then snail.position = 0 end
        if snail.position > 1 then snail.position = 1 end
        return snail
    end,
    show = function(snail, opts)
        local snailText = opts.snailidle
        if snail.direction > 0 then snailText = opts.snailright
        elseif snail.direction < 0 then snailText = opts.snailleft end
        local snailLength = #snailText

        -- Determine index in the tank (1-based for Lua)
        local index = math.floor(snail.position * (opts.tanksize - 1 - snailLength)) + 1

        local tank = {}
        for i = 1, opts.tanksize do
            tank[i] = " "
        end

        for i = 1, snailLength do
            local tankPos = index + i - 1
            if tankPos >= 1 and tankPos <= opts.tanksize then
                local char = snailText[i]
                tank[tankPos] = char
            end
        end

        return table.concat(tank)
    end
}