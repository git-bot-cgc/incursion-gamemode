AddCSLuaFile( )
ENT.Type = "anim"
ENT.PrintName = "GMG Round"
ENT.Author = "Lenny"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.DamageDirect = 125 -- Damage on impact, adds on with the blast radius damage but as true damage without radius involved.
ENT.DamageRadius = 200 -- Radius of explosion
ENT.FlightTime = 10 -- How long it can fly for before automatically detonating.

if SERVER then
    function ENT:Initialize( )
        self:SetModel( "models/weapons/misc/grenaderifle_projectile.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS ) -- Make us work with physics,
        self:SetMoveType( MOVETYPE_VPHYSICS ) --after all, gmod is a physics
        self:SetSolid( SOLID_VPHYSICS )
        self:SetOwner( self.Owner ) -- TFA sets the self.Owner variable when a projectile is used.
        local phys = self:GetPhysicsObject( )

        if phys:IsValid( ) then
            phys:Wake( )
        end

        -- Push it a bit forward and down to prevent it from being inside the player and in the middle of their screen.
        self:SetPos( self:GetPos( ) + self.Entity:GetForward( ) * 15 + self.Entity:GetUp( ) * -10 - self.Entity:GetRight( ) * -6 )
        self:SetAngles( self:GetOwner( ):EyeAngles( ) + Angle( 0, -90, 0 ) )
        self:NextThink( CurTime( ) + self.FlightTime ) -- Set the next think.
    end

    function ENT:Think( )
        self:Explosion( )
        return true
    end

    function ENT:PhysicsCollide( data, col )
		if data.Speed > 60 then
			self:Explosion( data.HitEntity )
		end
    end

    function ENT:Explosion( ent )
        local dmg = DamageInfo()
        dmg:SetAttacker(self.Owner)
        dmg:SetDamage(self.damage)
        for k, v in ipairs(ents.FindInSphere(self:GetPos(), 150)) do
            if v == self.Owner then
                dmg:SetDamage(self.damage * 10)
            end

            v:TakeDamageInfo(dmg)
        end
        local effectdata = EffectData( )
        effectdata:SetOrigin( self:GetPos( ) ) -- Where is hits
        effectdata:SetNormal( Vector( 0, 0, 1 ) ) -- Direction of particles
        effectdata:SetEntity( self ) -- Who done it?
        effectdata:SetScale( 3 ) -- Size of explosion
        effectdata:SetRadius( 67 ) -- What texture it hits
        effectdata:SetMagnitude( 14 ) -- Length of explosion trails
        util.Effect( "Explosion", effectdata )
        util.ScreenShake( self:GetPos( ), 10, 5, 1, 3000 )
        self:Remove( )
    end
end

if CLIENT then
    function ENT:Draw( )
        self:DrawModel( )
    end

    function ENT:Initialize( )
        ParticleEffectAttach( "mr_smallsmoke_1_noise", 1, self, 1 )
    end
end
