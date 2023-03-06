AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/maxofs2d/hover_rings.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:SetTrigger(true)

	self.isSCP = true
	self.canUse = true

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
	if phys:IsValid() then phys:Wake() end
end


function ENT:Use(ply)
	if not self.canUse then return end

	if ply:IsPlayer() and ply:Alive() then
		MSCP.Message(ply, "UHK-class you-have-been-killed scenario has occurred.")
		MSCP.Message(ply, MSCP.TTKUJ[math.random(#MSCP.TTKUJ)])
		ply:Kill()
	end

	self.canUse = false
	timer.Simple(0.5, function()
		self.canUse = true
	end)
end

function ENT:OnTakeDamage(dmg)

end


hook.Add("ShouldCollide", "", function(scp, ent)
	
end)

function ENT:StartTouch(otherEnt)

end