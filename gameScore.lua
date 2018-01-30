--------------------------------------------------------
-- Here handles the implementation of scores of the player.
-- Displays the Wins, Losses, Draws of the player.
-- SCENE : GAME SCORES SCREEN    
--------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )
-- -----------------------------------------------------------------------------------
---SETTING THE DISPLAY HEIGHT & WIDTH
-- -----------------------------------------------------------------------------------
d = display
 w20 = d.contentWidth * .0
 h20 = d.contentHeight * .3
 w40 = d.contentWidth * .29
 h40 = d.contentHeight * .45
 h60 = d.contentHeight * .6
 w80 = d.contentWidth * .99
 h80 = d.contentHeight * .75

--- EASY (win/lose/draw) initialized to 0
local winE = 0
local lostE = 0
local drawE = 0

--- MEDIUM (win/lose/draw)
local winM = 0
local lostM = 0
local drawM = 0

--- HARD (win/lose/draw)
local winH = 0
local lostH = 0
local drawH = 0

--- Group for the wins/loses/draws
local scoreCountgroup = display.newGroup()	

--- 3D array table for the Scores
local tableScore={
	{0,0,0},	--Easy level (wins/loses/draws)
	{0,0,0},	--Medium level (wins/loses/draws)
	{0,0,0}		--Hard level (wins/loses/draws)
}

--- Create file called scores
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

--- Read the Scores file
local function loadScores()
    local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        tableScore = json.decode( contents )
	end

--- Level Easy scores will be in the 1st row of the array	
	winE = tableScore[1][1]		--Assign scores of wins to the 1st index
	lostE = tableScore[1][2]	--Assign scores of loses to the 2nd index
	drawE = tableScore[1][3]	--Assign scores of draws to the 3rd index

--- Level Medium scores will be in the 2nd row of the array	
	winM = tableScore[2][1]
	lostM = tableScore[2][2]
	drawM = tableScore[2][3]

--- Level Hard scores will be in the 3rd row of the array	
	winH = tableScore[3][1]
	lostH = tableScore[3][2]
	drawH = tableScore[3][3]
end

--- Write the scores 
local function saveScores(table)
    local file = io.open( filePath, "w" )

    if file then
        file:write( json.encode( table ) )
        io.close( file )
    end
end

--- Goes to the Menu Scene
local function gotoMenu()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

--- Goes to the Loading Scene to clear the scores
local function gotoLoadScore()
--- Assign the scores to 0
    local table = {
				{0,0,0},
				{0,0,0},
				{0,0,0}
			}
	--Takes table as parameter in order to write the updated scores 
	saveScores(table)
	--Goes to the Loading scene
	composer.gotoScene( "loadScore", { time=800, effect="fromTop" } )	  	
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
-- create()
function scene:create( event )

	local sceneGroup = self.view
	 -- Load the previous scores or the scores that have been cleared
   		loadScores()

-----------------------------------------------------
--      		TITLES         		   --
-----------------------------------------------------
--- Background Image      
    local background = display.newImageRect( sceneGroup, "background.png", 400, 800 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

--- Score Title
	local scoreHeader = display.newImageRect( sceneGroup, "images/hscore.png", 200, 60  )
    scoreHeader.x = display.contentCenterX
	scoreHeader.y = 60

--- Easy Title
	local easyHeader = display.newText( sceneGroup, "Easy", 40, 180, native.systemFontBold, 25 )
	easyHeader:setFillColor(0.8,0,0.3) 

--- Medium Title
	local medHeader = display.newText( sceneGroup, "Medium", 40, 250, native.systemFontBold, 25 )
	medHeader:setFillColor(0.8,0,0.3) 

--- Hard Title
	local hardHeader = display.newText( sceneGroup, "Hard", 40, 325, native.systemFontBold, 25 )
	hardHeader:setFillColor(0.8,0,0.3) 

--- Wins Tile
	local winsHeader = display.newText( sceneGroup, "Wins", 130, 130, native.systemFontBold, 25 )
	winsHeader:setFillColor(0.8,0,0.3) 
--- Losses Tile
	local lostHeader = display.newText( sceneGroup, "Loses", 205, 130, native.systemFontBold, 25 )
	lostHeader:setFillColor(0.8,0,0.3) 
--- Draws Title
	local drawsHeader = display.newText( sceneGroup, "Draws", 285, 130, native.systemFontBold, 25 )
	drawsHeader:setFillColor(0.8,0,0.3) 

-----------------------------------------------------
--      	DISPLAYING SCORES    		   --
-----------------------------------------------------
--- Scores for EASY LEVEL
 	local easy1 = display.newText( scoreCountgroup, winE, 130, 180, native.systemFontBold, 25 )	--Wins for Easy
	easy1:setFillColor(0.1,0.1,0.4) 

	local easy2 = display.newText( scoreCountgroup, lostE, 205, 180, native.systemFontBold, 25 ) --Losses for Easy
	easy2:setFillColor(0.1,0.1,0.4) 

	local easy3 = display.newText( scoreCountgroup, drawE, 285, 180, native.systemFontBold, 25 ) --Draws for Easy
	easy3:setFillColor(0.1,0.1,0.4)

--- Scores for MEDIUM LEVEL
	local med1 = display.newText( scoreCountgroup, winM, 130, 250, native.systemFontBold, 25 )	 --Wins for Medium
	med1:setFillColor(0.1,0.1,0.4) 

	local med2 = display.newText( scoreCountgroup, lostM, 205, 250, native.systemFontBold, 25 )	 --Losses for Medium
	med2:setFillColor(0.1,0.1,0.4)

	local med3 = display.newText( scoreCountgroup, drawM, 285, 250, native.systemFontBold, 25 )	 --Draws for Medium
	med3:setFillColor(0.1,0.1,0.4) 

--- Scores for HARD LEVEL
	local hard1 = display.newText( scoreCountgroup, winH, 130, 325, native.systemFontBold, 25 )	 --Wins for Hard
	hard1:setFillColor(0.1,0.1,0.4) 

	local hard2 = display.newText( scoreCountgroup, lostH, 205, 325, native.systemFontBold, 25 ) --Losses for Hard
	hard2:setFillColor(0.1,0.1,0.4)

	local hard3 = display.newText( scoreCountgroup, drawH, 285, 325, native.systemFontBold, 25 )  --Draws for Hard 
	hard3:setFillColor(0.1,0.1,0.4) 


--- Left Line
	lline = d.newLine(sceneGroup, w40,h20,w40,h80 )
	lline.strokeWidth = 3
	lline:setStrokeColor(0.8,0,0.3) 
--- Bottom Line
	bline = d.newLine(sceneGroup, w20,h40,w80,h40 )
	bline.strokeWidth = 3
	bline:setStrokeColor(0.8,0,0.3) 
--- Top Line
	tline = d.newLine(sceneGroup, w20,h60,w80,h60 )
	tline.strokeWidth = 3
	tline:setStrokeColor(0.8,0,0.3)


--- Back button 
    backButton = display.newImageRect( sceneGroup, "images/back.png", 100, 50  )
    backButton.x = display.contentCenterX+115
	backButton.y = 430

--- Clear Button
    clearButton = display.newImageRect( sceneGroup, "images/clear.png", 100, 50  )
    clearButton.x = display.contentCenterX-115
	clearButton.y = 430

--- Inserts the scores into a Group 
	sceneGroup:insert(scoreCountgroup)

--- Event Listeners	
	backButton:addEventListener( "tap", gotoMenu )	--Add event listener to back button to go back to the Menu scene
	clearButton:addEventListener( "tap", gotoLoadScore )  --Add event listener to clear button to go to load scene to clear scores  
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
			composer.removeScene( "gameScore" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
