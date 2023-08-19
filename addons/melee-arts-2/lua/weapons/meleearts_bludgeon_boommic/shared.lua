SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.PrintName = "Boom Mic"
SWEP.Author = "danguyen"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Category = "Melee Arts 2"
SWEP.SlotPos = 1
 
SWEP.Purpose = "To make up for being very weak and soft, it's extremely loud and will disrupt your enemies!"

SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/models/danguyen/c_mastunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true

--STAT RATING (1-6)
SWEP.Type=3 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=1 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=2 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=2 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="meleearts_bludgeon_boommic"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=5
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 0.2
SWEP.DmgMin = 4
SWEP.DmgMax = 11
SWEP.Delay = 0.8
SWEP.TimeToHit = 0.02
SWEP.AttackAnimRate = 1
SWEP.Range = 75
SWEP.Punch1 = Angle(-2, 0, 0)
SWEP.Punch2 = Angle(5, 0, -2)
SWEP.HitFX = "bloodsplat"
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.2
SWEP.DmgMin2 = 3
SWEP.DmgMax2 = 8
SWEP.ThrowModel = "models/models/danguyen/boom_mic.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.ThrowForce = 1200
SWEP.FixedThrowAng = Angle(0,90,90)
SWEP.SpinAng = Vector(1500,0,0)

--HOLDTYPES
SWEP.AttackHoldType="melee"
SWEP.Attack2HoldType="knife"
SWEP.ChargeHoldType="melee"
SWEP.IdleHoldType="knife"
SWEP.BlockHoldType="magic"
SWEP.ShoveHoldType="fist"
SWEP.ThrowHoldType="grenade"

--SOUNDS
SWEP.SwingSound="weapons/stunstick/stunstick_swing1.wav"
SWEP.ThrowSound="knifethrow.mp3"
SWEP.Hit1Sound="weapons/stunstick/stunstick_fleshhit1.wav"
SWEP.Hit2Sound="weapons/stunstick/stunstick_fleshhit2.wav"
SWEP.Hit3Sound="weapons/stunstick/stunstick_fleshhit1.wav"

SWEP.Impact1Sound="weapons/stunstick/stunstick_impact1.wav"
SWEP.Impact2Sound="weapons/stunstick/stunstick_impact2.wav"

SWEP.ViewModelBoneMods = {
	["smdimport"] = { scale = Vector(0.112, 0.112, 0.112), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(0,0,0)
SWEP.StunAng = Vector(5.627, -11.961, 47.136)

SWEP.ThrowPos = Vector(2.612, -5.428, 10.251)
SWEP.ThrowAng = Vector(33.064, -56.986, 30.954)

SWEP.ShovePos = Vector(-11.061, -13.669, -7.841)
SWEP.ShoveAng = Vector(24.622, 70, -46.432)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(-33.065, 0, 0)

SWEP.WhipPos = Vector(-0.202, -20, -1.005)
SWEP.WhipAng = Vector(60.502, -9.146, 22.513)

SWEP.FanPos = Vector(8.039, -24, 8.239)
SWEP.FanAng = Vector(64.723, 24.622, 90)

SWEP.WallPos = Vector(-0.601, -11.056, -9.65)
SWEP.WallAng = Vector(42.915, 0, 0)

function SWEP:AttackAnimation()
self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
end
function SWEP:AttackAnimation2()
self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
end
function SWEP:AttackAnimation3()
self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
end

function SWEP:AtkExtra()
	util.ScreenShake( self.Owner:GetPos(), 500, 500, 8, 80 )
	for k,v in pairs(ents.FindInSphere(self:GetPos(),80)) do
		if v:IsValid() and v:IsPlayer() then
			v:SetDSP(39,false)
		end
			
	end
end

SWEP.VElements = {
	["axe"] = { type = "Model", model = "models/models/danguyen/boom_mic.mdl", bone = "smdimport", rel = "", pos = Vector(-0.12, 0, -1.359), angle = Angle(-1.17, 19.87, -94.676), size = Vector(0.82, 0.82, 0.82), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["axe"] = { type = "Model", model = "models/models/danguyen/boom_mic.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1, 1.557), angle = Angle(0, -99.351, 106.363), size = Vector(1.08, 1.08, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
print("Melee Art 2 Crowbar works, yippee")