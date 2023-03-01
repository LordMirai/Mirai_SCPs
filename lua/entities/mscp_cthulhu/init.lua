AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/metal_tubex2.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:SetTrigger(true)

	self.isSCP = true

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end

	self.scannedPlayers = {}
end

function ENT:Think()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 700)) do
		self:scan(v)
	end

	self:NextThink(CurTime() + 1)
	return true
end

function ENT:Use(ply)
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 600)) do
		if v:IsPlayer() then
			self:readTogether(ply, v)
			return
		end
	end
	self:readAlone(ply)
end

function ENT:OnTakeDamage(dmg)
	if dmg:GetAttacker():IsPlayer() or dmg:GetAttacker():IsNPC() then
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 1000)) do
			if v:IsPlayer() or v:IsNPC() then
				v:TakeDamage(600, self, self)
			end
		end
		timer.Simple(0.1,function()
			if self:IsValid() then
				self:Remove()
				MSCP.Broadcast("Call of Cthulhu as been taken back.")
			end
		end)
	end
end


function ENT:scan(ply)
	if ply:IsPlayer() and ply:Alive() then
		if self.scannedPlayers[ply] == nil then
			self.scannedPlayers[ply] = true
			MSCP.Message(ply, "You feel a strange presence. You should read the book.", Color(100,30,30))
		end
	end
end


function ENT:readAlone(ply)
	local randMessage = MSCP.CtulhuLines[math.random(#MSCP.CtulhuLines)]
	MSCP.Message(ply,"You read a passage from the book:\n"..randMessage)
end