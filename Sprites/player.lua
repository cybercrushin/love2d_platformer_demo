return {
	imageSrc = "Assets/player.png",
	defaultState = "neutral",
	states = {
		-- 1st line
		neutral = { -- the name of the state is arbitrary
			frameCount = 4,
			offsetX = 0, 
			offsetY = 0, 
			frameW = 50,
			frameH = 37,
			nextState = "neutral", -- we loop the running state
			switchDelay = 0.25
		},
		running = {
			frameCount = 6,
			offsetX = 50, 
			offsetY = 37, 
			frameW = 50,
			frameH = 37,
			nextState = "running", -- we loop the running state
			switchDelay = 0.15
		},
		jumping = {
			frameCount = 1,
			offsetX = 50, 
			offsetY = 111, 
			frameW = 50,
			frameH = 37,
			nextState = "running", -- we loop the running state
			switchDelay = 1
		}
    }
}