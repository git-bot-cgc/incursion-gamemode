SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.PrintName = "Hammer"
SWEP.Author = "Lenny"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Category = "Claymore Gaming : Fortifications"
SWEP.SlotPos = 1

SWEP.ViewModelFOV = 95
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/models/danguyen/c_zweihander.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true
SWEP.CanThrow = false


SWEP.WepName="meleearts_bludgeon_fists"


--STAT RATING (1-6)
SWEP.Type=3 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=3 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=6 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=3 -- General rating based on how good/doodoo the weapon is

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=5
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 1
SWEP.DmgMin = 0
SWEP.DmgMax = 50
SWEP.Delay = 1.5
SWEP.TimeToHit = 0.05
SWEP.Range = 105
SWEP.Punch1 = Angle(-5, 10, 0)
SWEP.Punch2 = Angle(-5, 0, -3)
SWEP.HitFX = "cball_bounce"
SWEP.HitFX2 = ""
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.2
SWEP.DmgMin2 = 25
SWEP.DmgMax2 = 35
SWEP.ThrowModel = "models/mosi/fallout4/props/weapons/melee/baton.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.ThrowForce = 10000
SWEP.FixedThrowAng = Angle(90,0,0)
SWEP.SpinAng = Vector(0,0,0)

--HOLDTYPES
SWEP.AttackHoldType="melee"
SWEP.Attack2HoldType="melee"
SWEP.ChargeHoldType="melee"
SWEP.IdleHoldType="melee"
SWEP.BlockHoldType="slam"
SWEP.ShoveHoldType="fist"
SWEP.ThrowHoldType="grenade"

--SOUNDS
SWEP.SwingSound=""
SWEP.ThrowSound="spearthrow.mp3"
SWEP.Hit1Sound="physics/body/body_medium_impact_hard1.wav"
SWEP.Hit2Sound="physics/body/body_medium_impact_hard2.wav"
SWEP.Hit3Sound="physics/body/body_medium_impact_hard3.wav"


SWEP.ViewModelBoneMods = {
	["RW_Weapon"] = { scale = Vector(0.01, 0.01, 0.01), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}

SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(0, 0, 0)
SWEP.StunAng = Vector(-16.181, 0, 47.136)

SWEP.ShovePos = Vector(-6.633, -0.403, -1.005)
SWEP.ShoveAng = Vector(-3.518, 70, -70)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(0, 0, 0)

SWEP.WhipPos = Vector(0, -10.252, 0)
SWEP.WhipAng = Vector(70, 0, 0)

SWEP.ThrowPos = Vector(-4.624, -3.217, -2.613)
SWEP.ThrowAng = Vector(0, -90, -90)

SWEP.FanPos = Vector(5.23, -10.051, -3.62)
SWEP.FanAng = Vector(80, 16.884, 90)

SWEP.WallPos = Vector(0,0,0)
SWEP.WallAng = Vector(0,0,0)

local maxDistance = 400*400

local buildingEnts = {
    ["fortification_cannon"] = true,
    ["fortification_barbedwire"] = true,
    ["fortification_net"] = true,
    ["fortification_building"] = true,
}

function SWEP:Deploy()
	if !IsFirstTimePredicted() then return end

	local ply = self:GetOwner()

	if SERVER then
		jlib.Announce(ply, Color(255,0,0), "[NOTICE] ", Color(255,255,255), "Fortification Hammer Information")
		jlib.Announce(ply,  Color(255,0,0), "> ", Color(255,255,255), "Press 'R' to open the build menu, all builds will require 'Fortification Materials'")
		jlib.Announce(ply,  Color(255,0,0), "> ", Color(255,255,255), "During raids or wars 'Fortification Building' is allowed")
		jlib.Announce(ply,  Color(255,0,0), "> ", Color(255,255,255), "Do not maliciously abuse the 'Fortification Building' system (I.E. Spamming builds, everywhere around the map etc.)")
	end
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	local building = ply:getNetVar("building")
	local trace = ply:GetEyeTrace()


	if SERVER and ply:KeyDown(IN_USE) and trace.Entity and buildingEnts[trace.Entity:GetClass()] and IsFirstTimePredicted() then
		jlib.RequestBool("Demolish?", function(bool)
			if !bool then return end

			if ply:GetPos():DistToSqr(trace.Entity:GetPos()) > maxDistance and SERVER then
				ply:falloutNotify("Too far away!")
				return
			end

			local effectdata = EffectData()
			effectdata:SetOrigin( trace.Entity:GetPos() + trace.Entity:OBBCenter() )
			util.Effect( "flash_smoke", effectdata )
			
			trace.Entity:Remove()
		end, ply, "Yes", "No")

		return
	end 

	if building then
		local position = trace.HitPos
		local placement = position + (trace.HitNormal * 50)
		if ply:GetPos():DistToSqr(position) > maxDistance then
			if SERVER then
				ply:falloutNotify("Too far away!")
			end
			return 
		end

		if trace.Entity and buildingEnts[trace.Entity:GetClass()] then
			return
		end

		if SERVER then
			local build = ents.Create("fortification_building")
			build:SetPos(position + Vector(0, 0, 16))
			build:SetModel("models/props_junk/iBeam01a_cluster01.mdl")
			build:Spawn()
			build:SetAngles(Angle(0, ply:GetAngles().y, 0))
			build:EmitSound("ui/ui_items_gunsbig_down.mp3")
			build.fortification = FORTIFICATIONS.Deployables[ply:getNetVar("building")].class
			build.Owner = ply

			build:GetPhysicsObject():EnableMotion(false)

			if IsValid(build) then
				ply:setNetVar("building", nil)
			end
		end

		local effectdata = EffectData()
		effectdata:SetOrigin( placement )
		util.Effect( "flash_smoke", effectdata )
	end

	if !building then
		baseclass.Get("dangumeleebase").PrimaryAttack()
	end
end


function SWEP:AtkExtra(tr)
    local ply = self:GetOwner()
    local entity = ply:GetEyeTrace().Entity

    if !IsValid(entity) or !buildingEnts[entity:GetClass()] then return end

	if entity:GetClass() == "fortification_building" then
		entity:SetBuildStatus( entity:GetBuildStatus() + 1 )
	else
		if entity:Health() >= entity:GetMaxHealth() then
			if SERVER then
				ply:falloutNotify("The fortification is fully repaired!", "ui/notify.mp3")
			end
			return
		end

		ply:falloutNotify("The fortification repair status: [ " .. math.floor((entity:Health() / entity:GetMaxHealth()) * 100) .. "% ]", "ui/notify.mp3")
		entity:SetHealth( math.Clamp(entity:Health() + 100, 0, entity:GetMaxHealth()) )

		timer.Simple(0, function()
			local effectData = EffectData()
			effectData:SetScale(5)
			effectData:SetOrigin(entity:GetPos() + entity:GetUp() * 2)
			util.Effect("VortDispel", effectData)
		end)
	end
end

function SWEP:Reload()
	if !IsFirstTimePredicted() then return end

	if CLIENT then
		if self.nextuse and self.nextuse > CurTime() then return end

		vgui.Create("HAMMERMENU")
		self.nextuse = CurTime() + 1
	end
end


function SWEP:AttackAnimation()
	self.Weapon.AttackAnimRate = 1.1
	self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
end
function SWEP:AttackAnimation2()
	self.Weapon.AttackAnimRate = 1.6
	self.Punch1 = Angle(0, -15, 0)
	self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
	self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
end
one=true
two=false
three=false
function SWEP:AttackAnimationCOMBO()
	self.Weapon.AttackAnimRate = 1.6
	if one==true then
		self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
		self.Punch1 = Angle(0, -10, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK )
		one=false
		two=true
		three=false
	elseif two==true then
		self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
		self.Punch1 = Angle(5, 10, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_MISSLEFT )
		one=false
		two=false
		three=true
	elseif three==true then
		self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
		self.Punch1 = Angle(5, 10, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_HIGH )
		one=true
		two=false
		three=false
	end
end
function SWEP:AttackAnimation3()
	self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
end


SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/clutter/hammer.mdl", bone = "RW_Weapon", rel = "", pos = Vector(0, -0.5, 10.948), angle = Angle(180, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0 }
}
SWEP.WElements = {
	["shishkebab"] = { type = "Model", model = "models/clutter/hammer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.275, 1, -10.42), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}