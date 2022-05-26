		 for _, v in next, game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks() do
				if (v.Animation.AnimationId:match("rbxassetid://5641749824")) then
					v:Stop();
				end;
		 end;
