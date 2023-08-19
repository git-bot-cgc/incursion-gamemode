AddCSLuaFile("cl_init.lua")

AddCSLuaFile("shared.lua")

include('shared.lua')



function ENT:SpawnFunction(ply, tr)



	if (!tr.Hit) or ply.Shield then return end

	local SpawnPos = tr.HitPos + tr.HitNormal

	local ent = ents.Create("ent_atr_shell")

		ent:SetPos(SpawnPos)

		ent:Spawn()

end



function ENT:Initialize()

	self:SetModel("models/weapons/w_missile_launch.mdl")

	if !self.Timer then

		self.Timer = CurTime() + 4

	end

	self:PhysicsInit(SOLID_VPHYSICS)

	self:SetMoveType(MOVETYPE_FLY)

	self:SetSolid(SOLID_VPHYSICS)

	

	self:SetVelocity(self:GetForward() * 3500) //

	local trail = util.SpriteTrail(self.Entity, 0, Color(200,200,200,255), true, 5, 0, 0.2, 1/(15+1)*0.5, "trails/smoke.vmt")

/*	self:SetGravity(.4)

	local phys = self:GetPhysicsObject()



	if (phys:IsValid()) then

		phys:Wake()

		phys:SetMass(7)

	end */

end



function ENT:Touch(ent)

	if self:GetOwner() != ent and (ent:IsPlayer() or ent:IsNPC() or ent:IsWorld() or ent:GetMoveType() == MOVETYPE_VPHYSICS) then

		self:Explosion()	// Not the person who fired it? Kaboom.

	end

end



function ENT:Explosion()

	if self:GetOwner() != nil then

		self.boom1 = self:GetOwner()

	else

		self.boom1 = self

	end

	self:EmitSound("ambient/explosions/explode_1.wav", 100, 100)

	local explo = ents.Create("env_explosion")

		explo:SetOwner(self.boom1)

		explo:SetPos(self.Entity:GetPos())

		explo:SetKeyValue("iMagnitude", "0")

		explo:Spawn()

		explo:Activate()

		explo:Fire("Explode", "", 0)

	local explo2 = ents.Create("env_physexplosion")

		explo2:SetOwner(self.boom1)

		explo2:SetPos(self.Entity:GetPos())

		explo2:SetKeyValue("magnitude", "25")

		explo2:SetKeyValue("radius", "200")

		explo2:SetKeyValue("spawnflags", "3")

		explo2:Spawn()

		explo2:Activate()

		explo2:Fire("Explode", "", 0)

	util.BlastDamage(self, self.boom1, self:GetPos(), 200, 125)

	self:Remove()

end