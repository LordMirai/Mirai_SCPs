SWEP.PrintName = "Terrtory"
SWEP.Author = "Lord Mirai (未来)" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
SWEP.Instructions = "Click to throw a head-seeking skull"

SWEP.Category = "Mirai's SCPs"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
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

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.ShootSound = Sound("Metal.SawbladeStick")

MSCP = MSCP or {}

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
    local target = ply:GetEyeTrace().Entity
    if not ply:IsValid() then return end
    if not target:IsValid() then return end
    if not target:IsPlayer() then return end
    if not target:Alive() or not ply:Alive() then return end

    self:SetNextPrimaryFire(CurTime() + 4)
    MSCP.territory(ply, target, true)
end

function SWEP:SecondaryAttack()
    local ply = self:GetOwner()
    local target = ply:GetEyeTrace().Entity
    if not ply:IsValid() then return end
    if not target:IsValid() then return end
    if not target:IsPlayer() then return end
    if not target:Alive() or not ply:Alive() then return end

    self:SetNextSecondaryFire(CurTime() + 4)
    MSCP.territory(ply, target, false)
end

function MSCP.territory(ply, target, preserveRotation)
    if CLIENT then return end

    preserveRotation = preserveRotation or false

    ply:Say("Territory!")

    MSCP.Message(ply, string.format("You used Territory on %s. Swapped places.", target:Nick()), Color(0, 20, 190))
    MSCP.Message(target, string.format("You were swapped with %s by use of Territory.", ply:Nick()), Color(230, 90, 0))

    local plypos = ply:GetPos()
    local targetpos = target:GetPos()

    local plyang = ply:EyeAngles()
    local targetang = target:EyeAngles()

    ply:SetPos(targetpos)
    target:SetPos(plypos)

    target:SetEyeAngles(plyang)
    if preserveRotation then
        ply:SetEyeAngles(targetang) -- swaps but doesn't point at target (normal swap)
    else
        ply:PointAtEntity(target) -- swaps and points at target (combat territory)
    end
end