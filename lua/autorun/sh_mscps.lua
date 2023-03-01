MSCP = MSCP or {}

function MSCP.chance(prob)
    local curProb = math.random() * 100
    return curProb <= prob
end

print("sh_mscps reloaded")