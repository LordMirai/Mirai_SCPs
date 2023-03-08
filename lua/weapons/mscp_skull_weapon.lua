SWEP.PrintName = "Skull thrower"
SWEP.Author = "Lord Mirai (未来)" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
SWEP.Instructions = "Click to throw a head-seeking skull"

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

function SWEP:PrimaryAttack()
   self:fireSkull()
   
   self:GetOwner():StripWeapon(self:GetClass())
end

function SWEP:SecondaryAttack() end

function SWEP:fireSkull()
    local owner = self:GetOwner()
    if (not owner:IsValid()) then return end

    if (CLIENT) then return end
    
    self:EmitSound(self.ShootSound)

    local aimvec = owner:GetAimVector()
    local pos = aimvec * 15
    pos:Add(owner:EyePos())

    ent:SetPos(pos)

    ent:SetAngles(owner:EyeAngles())
    ent:Spawn()
end