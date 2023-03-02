AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("") -- book model
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:SetTrigger(true)

	self.isSCP = true
	self.canUse = true

	self.strikes = 5

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
	if not self.canUse then return end
	self.canUse = false

	self:EmitSound("pagesflip.wav", 80, math.random(80,120))
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 600)) do
		if v:IsPlayer() then
			self:readTogether(ply, v)
			return
		end
	end
	self:readAlone(ply) -- no one else is around
end

function ENT:OnTakeDamage(dmg)
	local attacker = dmg:GetAttacker()
	if attacker:IsPlayer() or attacker:IsNPC() then
		if attacker:GetPos():DistToSqr(self:GetPos()) < 2000000 then -- ~1400 units
			self:strikeResponse()
		end
	end
end


function ENT:scan(ply)
	if ply:IsPlayer() and ply:Alive() then
		if self.scannedPlayers[ply] == nil then
			self.scannedPlayers[ply] = true
			MSCP.Message(ply, "You feel a strange presence. You should read the book.", Color(100,30,30))
			-- thaumcraft warp whisper sound
		end
	end
end


function ENT:readAlone(ply)
	local randMessage = MSCP.CtulhuLines[math.random(#MSCP.CtulhuLines)]
	MSCP.Message(ply,"You read a passage from the book:\n"..randMessage)
	-- ominous whisper sound
end


function ENT:readTogether(origin, listener)
	local randMessage = MSCP.CtulhuLines[math.random(#MSCP.CtulhuLines)]
	MSCP.Message(origin,"You read a passage from the book:\n"..randMessage)
	MSCP.Message(listener,"You listen to a passage from the book:\n"..randMessage)
	origin:Say(randMessage)

	timer.Simple(math.random(2,15)/10, function() -- 0.2 - 1.5 seconds delay
		local dmg = math.random(10,30)
		if origin:Alive() then
			origin:TakeDamage(dmg, self, self)
			MSCP.Message(origin, "Wha- where did that come from?")
		end
		if listener:Alive() then
			listener:TakeDamage(dmg, self, self)
			MSCP.Message(origin, "Wha- where did that come from?")
		end
	end)
end

function ENT:strikeResponse()
	self:EmitSound("ambient/alarms/warningbell1.wav", 80, math.random(80,120))
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 1000)) do -- AOE damage to players & NPCs around the book
		if v:IsPlayer() or v:IsNPC() then
			v:TakeDamage(600, self, self)
		end
	end
	self.strikes = self.strikes - 1

	if self.strikes <= 0 then
		self:Remove()
		MSCP.Broadcast("Call of Cthulhu as been taken back above.")
	end
end