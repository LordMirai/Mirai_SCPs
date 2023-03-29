SWEP.PrintName = "Freeman Crowbar"
SWEP.Author = "Lord Mirai (未来)" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
SWEP.Instructions = "Makes people say freeman around you"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Category = "Mirai's SCPs"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.SlotPos = 20
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/c_crowbar.mdl"

SWEP.ShootSound = Sound("Metal.SawbladeStick")

MSCP = MSCP or {}

function SWEP:tick()
    local ply = self:GetOwner()
    if not ply:IsValid() then return end

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
    "Doctor Freeman, I presume?",
    "Freeeeeeeeeeeeeeeeeeeeeeeeeemaaaaaaaaaaaaaaaaaaaan",
    "Doctor Freeman, is that you?",
    "It's Freeman!",
    "Oh my god, it's Freeman!",
    "The Freeman is here",
    "No gordon, stop",
    "Gordon Freeman",
    "Gordon Freeman, in the flesh",
}

if SERVER then
    hook.Add("PlayerInitialSpawn","InitFreeman",function(ply)
        ply.saidFreeman = false
    end)
end