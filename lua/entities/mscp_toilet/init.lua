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
	self.doJoke = true

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
	if phys:IsValid() then phys:Wake() end
end

function ENT:StartTouch(otherEnt)
	if otherEnt:IsValid() then
		if otherEnt:IsPlayer() or otherEnt:IsNPC() then
			self:joke(otherEnt)
		end
	end
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		self:joke(activator)
	end
end

function ENT:joke(ply)
	if not self.doJoke then return end
	if ply:IsPlayer() then
		local msg = MSCP.ToiletMessages[math.random(#MSCP.ToiletMessages)]
		ply:Say(msg)
	end

	local path = "toilet/laugh"..math.random(1, 2)..".wav"

	ply:EmitSound(path, math.random(60, 100), math.random(80, 120), math.Rand(0.6,1), CHAN_AUTO)

	self.doJoke = false
	timer.Simple(0.5, function()
		if self:IsValid() then
			self.doJoke = true
		end
	end)
end

function ENT:OnRemove()
	timer.Simple(0, function()
		if not IsValid(self) then
			for k,v in pairs(MSCP.activeSCPs) do
				if v == ent then
					table.remove(MSCP.activeSCPs, k)
				end
			end
		end
	end)
end