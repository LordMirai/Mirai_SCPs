MSCP = MSCP or {}

-- TODO: STRUCTURE MISSING

function SWEP:tick()
    local ply = self:GetOwner()

    for _,v in pairs(ents.FindInSphere(ply:GetPos(), 100)) do
        if v:IsPlayer() and v:Alive() and v ~= ply then
            MSCP.freeman(v)
        end
    end

    timer.Simple(0.4, function()
        if self:IsValid() then
            self:tick()
        end
    end)
end

function MSCP.freeman(ply)
    if not ply.saidFreeman then
        ply.saidFreeman = true
        ply:Say(freemanMessages[math.random(#freemanMessages)])
        
        timer.Simple(math.Rand(2, 5), function()
            if ply:IsValid() then
                ply.saidFreeman = false
            end
        end)
    end
end

local freemanMessages = {
    "Doctor Freeman",
    "Freeman",
    "Free my man Freeman",
    "Doctor Freeman I presume?",
    "Freeeeeeeeeeeeeeeeeeeeeeeeeemaaaaaaaaaaaaaaaaaaaan"
}

if SERVER then
    hook.Add("PlayerInitialSpawn","InitFreeman",function(ply)
        ply.saidFreeman = false
    end)
end