AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props/cs_militia/toilet.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:SetTrigger(true)

	self.isSCP = true

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
	if phys:IsValid() then phys:Wake() end
end

function ENT:StartTouch(otherEnt)
	if otherEnt:IsValid() then
		if otherEnt:IsPlayer() or otherEnt:IsNPC() then
			if otherEnt:IsPlayer() then
				local msg = MSCP.ToiletMessages[math.random(#MSCP.ToiletMessages)]
				otherEnt:Say(msg)
			end

			local path = "toilet/laugh"..math.random(1, 2)..".wav"

			otherEnt:EmitSound(path, math.random(60, 100), math.random(80, 120), math.Rand(0.6,1), CHAN_AUTO)
		end
	end
end