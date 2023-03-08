AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/maxofs2d/button_05.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:SetTrigger(true)

	util.PrecacheSound("jazz/jazz1.wav")

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self.isSCP = true
	self.canUse = true

	self:stopJazz()

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
	if phys:IsValid() then phys:Wake() end
end


function ENT:Use(ply)
	if not self.canUse then return end

	if not self.jazzOn then
		self:startJazz()
	else
		self:stopJazz()
	end

	self.canUse = false
	timer.Simple(2, function()
		self.canUse = true
	end)
end

function ENT:OnTakeDamage(dmg)
	self:stopJazz()
end

function ENT:startJazz()
	self.jazzOn = true
	self:SetColor(Color(80,200,80,200)) -- green

	self.song = CreateSound(self, "jazz/jazz1.wav")
	self.song:Play()
end

function ENT:stopJazz()
	self.jazzOn = false
	self:SetColor(Color(200,200,200)) -- reset

	if self.song then
		self.song:Stop()
	end
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