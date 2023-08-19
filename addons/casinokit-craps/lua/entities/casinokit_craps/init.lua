AddCSLuaFile("cl_init.lua")include("shared.lua")DEFINE_BASECLASS("casinokit_table")function ENT:Initialize()BaseClass.Initialize(self)self:SetModel(self.Model)self:PhysicsInit(SOLID_VPHYSICS)self:GetPhysicsObject():SetMass(1000)self:SetUseType(SIMPLE_USE)self.Table=CasinoKit.classes.Table(self.SeatCount)local a=CasinoKit.classes[self.GameClass]assert(a,"game '"..tostring(self.GameClass).."' does not exist!")self.Game=self.Table:createGame(a,self)self:SetClGameClass(self.Game:getClClass())if self:GetMinBet()==0 then self:SetMinBet(5)self:SetRollInterval(15)end;self.bets={}self:SetRolling(false)self:SetCanBet(true)self:SetPointRound(false)end;function ENT:OnGameConfigReceived(b,c)if b=="minbet"then assert(type(c)=="number"and c>=5)self:SetMinBet(c)elseif b=="rollinterval"then assert(type(c)=="number"and c>=5)self:SetRollInterval(c)end end;util.AddNetworkString("ckit_craps_rolldata")util.AddNetworkString("ckit_craps_updatebets")function ENT:Roll()self:SetRolling(true)self:SetCanBet(false)self.RollData={}self.RollData.d1=math.floor(CasinoKit.rand.random()*6)+1;self.RollData.d2=math.floor(CasinoKit.rand.random()*6)+1;net.Start("ckit_craps_rolldata")net.WriteEntity(self)net.WriteUInt(self.RollData.d1,8)net.WriteUInt(self.RollData.d2,8)net.WriteUInt(math.random(1,200),8)net.Broadcast()timer.Simple(1.4,function()self:SetRolling(false)self:HandleBets()timer.Simple(1,function()net.Start("ckit_craps_updatebets")net.WriteEntity(self)net.WriteTable(self.bets)net.Broadcast()self:SetCanBet(true)end)end)end;function ENT:Think()if self:GetTimeToNextRoll()<0.2 and not self:GetRolling()and#self.bets>0 then self:Roll()end;BaseClass.Think(self)end;util.AddNetworkString("ckit_craps_bet")function ENT:AddBet(d,e,f)local g=true;for b,h in pairs(self.bets)do if h.id==e and h.ply==d then self.bets[b].amount=h.amount+f;g=false end end;if g then table.insert(self.bets,{id=e,ply=d,amount=f})end;d:CKit_AddChips(-f)net.Start("ckit_craps_bet")net.WriteEntity(self)net.WriteString(e)net.WriteUInt(f,16)net.Broadcast()end;function ENT:MoveBet(d,e,f)local g=true;for b,h in pairs(self.bets)do if h.id==e and h.ply==d then self.bets[b].amount=h.amount+f;g=false end end;if g then table.insert(self.bets,{id=e,ply=d,amount=f})end end;net.Receive("ckit_craps_bet",function(i,d)local j=net.ReadEntity()local k=net.ReadString()local f=net.ReadUInt(16)if not j:IsValid()then return end;if not j.GameClass=="craps"then return end;if not j:GetCanBet()then return end;if not(f>=j:GetMinBet())then return end;if not d:CKit_CanAffordChips(f)then return end;k=string.Trim(k,"_")if(k=="pass"or k=="dontpass")and j:GetPointRound()then d:CKit_PrintL("craps_passpoint")return end;if string.sub(k,1,5)=="place"then d:CKit_PrintL("craps_placebet")return end;j:AddBet(d,k,f)end)local l={{id="pass",callback=function(d,f,c,m,j)if table.HasValue({7,11},c)then d:CKit_AddChips(f*2)d:CKit_PrintL("craps_won_passline",{amount=f*2})elseif table.HasValue({2,3,12},c)then return else j.point=c;j:SetPointRound(true)j:MoveBet(d,"place"..c,f)d:CKit_PrintL("craps_move_pass",{amount=c})end end},{id="dontpass",callback=function(d,f,c,m,j)if table.HasValue({2,3},c)then d:CKit_AddChips(f*2)d:CKit_PrintL("craps_won_dontpass",{amount=f*2})elseif table.HasValue({7,11},c)then return elseif c==12 then d:CKit_AddChips(f)d:CKit_PrintL("craps_push",{amount=f})else j.point=c;j:SetPointRound(true)j:MoveBet(d,"place"..c,f)d:CKit_PrintL("craps_move_pass",{amount=c})end end},{id="come",callback=function(d,f,c,m,j)if table.HasValue({7,11},c)then d:CKit_AddChips(f*2)d:CKit_PrintL("craps_won_come",{amount=f*2})elseif table.HasValue({2,3,12},c)then return else j:MoveBet(d,"place"..c,f)d:CKit_PrintL("craps_move_come",{amount=c})end end},{id="dontcome",callback=function(d,f,c,m,j)if table.HasValue({2,3},c)then d:CKit_AddChips(f*2)d:CKit_PrintL("craps_won_dontcome",{amount=f*2})elseif table.HasValue({7,11},c)then return elseif c==12 then d:CKit_AddChips(f)d:CKit_PrintL("craps_push",{amount=f})else j:MoveBet(d,"place"..c,f)d:CKit_PrintL("craps_move_come",{amount=c})end end},{id="field",callback=function(d,f,c,m,j)if table.HasValue({3,4,9,10,11},c)then d:CKit_AddChips(f*2)d:CKit_PrintL("craps_won_field",{amount=f*2,dice=c})elseif c==2 then d:CKit_AddChips(f*3)d:CKit_PrintL("craps_won_field",{amount=f*3,dice=c})elseif c==12 then d:CKit_AddChips(f*4)d:CKit_PrintL("craps_won_field",{amount=f*4,dice=c})end end},{id="place4",payout=9/5,values={4},before={7}},{id="place5",payout=7/5,values={5},before={7}},{id="place6",payout=7/6,values={6},before={7}},{id="place8",payout=7/6,values={8},before={7}},{id="place9",payout=7/5,values={9},before={7}},{id="place10",payout=9/5,values={10},before={7}},{id="buy4",payout=2*0.95,values={4},before={7}},{id="buy5",payout=3/2*0.95,values={5},before={7}},{id="buy6",payout=6/5*0.95,values={6},before={7}},{id="buy8",payout=6/5*0.95,values={8},before={7}},{id="buy9",payout=3/2*0.95,values={9},before={7}},{id="buy10",payout=2*0.95,values={10},before={7}},{id="seven",payout=5,values={7},response="craps_won_7"},{id="craps",payout=8,values={2,3,12},response="craps_won_craps"},{id="h6",payout=10,dice={33},response="craps_won_hard6"},{id="h8",payout=10,dice={44},response="craps_won_hard8"},{id="h10",payout=8,dice={55},response="craps_won_hard10"},{id="h4",payout=8,dice={66},response="craps_won_hard4"},{id="3",payout=16,dice={21},response="craps_won_deuce"},{id="2",payout=31,dice={11},response="craps_won_hard2"},{id="12",payout=31,dice={66},response="craps_won_hard12"},{id="11",payout=16,dice={65},response="craps_won_11"},{id="ec",callback=function(d,f,c,m)if table.HasValue({2,3,12},c)then d:CKit_AddChips(f*7)d:CKit_PrintL("craps_won_ec_craps",{amount=f*7})elseif c==11 then d:CKit_AddChips(f*15)d:CKit_PrintL("craps_won_ec_11",{amount=f*15})end end}}function ENT:HandleBets()local n,o=self.RollData.d1,self.RollData.d2;if o>n then n,o=o,n end;local m=tonumber(n..o)local c=n+o;if self:GetPointRound()==true and(c==self.point or c==7)then self.point=nil;self:SetPointRound(false)end;local p={}local q=table.Copy(self.bets)self.bets={}for r,s in pairs(q)do for t,h in pairs(l)do if h.id==s.id then local u=false;if h.values then if table.HasValue(h.values,c)then u=true end end;if h.dice then if table.HasValue(h.dice,m)then u=true end end;if u then if h.payout then table.insert(p,{ply=s.ply,bet=h.id,profit=math.floor(s.amount*(1+h.payout))})end;if h.response then s.ply:CKit_PrintL(h.response,{amount=s.amount*(1+h.payout)})end;local v=string.sub(h.id,1,3)if v=="buy"then local w,x="craps_won_buy",math.floor(s.amount*(1+h.payout))s.ply:CKit_PrintL(w,{amount=x,dice=c})elseif v=="pla"then local w,x="craps_won_place",math.floor(s.amount*(1+h.payout))s.ply:CKit_PrintL(w,{amount=x,dice=c})end end;if h.before and not table.HasValue(h.before,c)and not u then self:MoveBet(s.ply,s.id,s.amount)end;if h.callback then h.callback(s.ply,s.amount,c,m,self)end end end end;for t,h in pairs(p)do h.ply:CKit_AddChips(h.profit)end end