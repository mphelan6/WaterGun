local WaterGun = RegisterMod("Water Gun", 1);
local WaterGun_Item = Isaac.GetItemIdByName("Water Gun");
local FramesToRun = 40;
local speed = 25;
local drift = 1;
local Running = 0;
local shoot = 2;
local shootOnFrame = 3;

function WaterGun:Use_WaterGun()
	Running = FramesToRun;
end

function WaterGun:Shooting()
	if (shoot == shootOnFrame) then
		local player = Isaac.GetPlayer(0);

		if Running > 0 then
			local vel = player.GetVelocityBeforeUpdate(player)
			local remove = false;
			--player.AddVelocity(player, Vector(vel.X * -0.4, vel.Y * -0.4)); --this slows the player

			local DriftAmt = math.random(-1*drift, drift);
			local HeadDir = player.GetHeadDirection(player);

			if (player:HasCollectible(CollectibleType.COLLECTIBLE_CUPIDS_ARROW) == false) then
				player:AddCollectible(CollectibleType.COLLECTIBLE_CUPIDS_ARROW, 0, false);
				remove = true;
			end

			if (HeadDir == Direction.RIGHT) then
				player:FireTear(player.Position, Vector(speed, DriftAmt), true, true, false);
			elseif (HeadDir == Direction.LEFT) then
				player:FireTear(player.Position, Vector(speed*-1, DriftAmt), true, true, false);
			elseif (HeadDir == Direction.UP) then
				player:FireTear(player.Position, Vector(DriftAmt, speed*-1), true, true, false);
			else --HeadDir is DOWN
				player:FireTear(player.Position, Vector(DriftAmt, speed), true, true, false);
			end

			if (remove == true) then
				player:RemoveCollectible(CollectibleType.COLLECTIBLE_CUPIDS_ARROW);
			end

			Running = Running - 1;
		end

		shoot = 0;
	else
		shoot = shoot + 1;
		Running = Running - 1;
	end
end
WaterGun:AddCallback(ModCallbacks.MC_USE_ITEM, WaterGun.Use_WaterGun, WaterGun_Item);
WaterGun:AddCallback(ModCallbacks.MC_POST_RENDER, WaterGun.Shooting, nil);
