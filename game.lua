-----------------------------------------------------------------------------------------
The Squares of the grid are numbered as shown below:  In my Case;    
     :                   :         
     :         1|2|3     :     EMPTY is considered as 0  
     :         4|5|6     :      'X'  is considered as 1   
     :         7|8|9     :      'O'  is considered as 2
------------------------------------------------------------------------------------------

---SETTING THE DISPLAY HEIGHT & WIDTH
d = display
w20 = d.contentWidth * .2
h20 = d.contentHeight * .2
w40 = d.contentWidth * .4
h40 = d.contentHeight * .4
w60 = d.contentWidth * .6
h60 = d.contentHeight * .6
w80 = d.contentWidth * .8
h80 = d.contentHeight * .8

----------                              ----------
--              DECLARING VARIABLES             --
--------------------------------------------------
math.randomseed( os.time() )

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local json = require( "json" )
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

local level = require("level")
      level = composer.getVariable( "levelNow" )    --Get the levels selected from the level scene

--- Creating new groups
local backGroup = display.newGroup()    --Includes background image
local mainGroup = display.newGroup()    --Includes the lines of the grid
local uiGroup = display.newGroup()      --Includes all buttons
local xGroup = display.newGroup()       --Includes placement of 'X's
local oGroup = display.newGroup()       --Includes placement of 'O's
local imageGroup = display.newGroup()   --Includes win/lose/draw text for replaying
local replayGroup = display.newGroup()  --Includes the overlaid 'X's and 'O's

--- Board Lines
local lline
local rline
local bline
local tline

local background          --Background image
local select              --Select statement 
local replay              --Replay text
local menuButton          --Menu button
local restartButton       --Restart button
local buttonHuman         --Player button to select
local buttonBot           --Bot button to select
local undoButton          --Undo button
local replayButton        --Replay button

undoCondition = false     --Flag the undo button to false
humanPressed = false      --Flag the human button to false
botPressed = false        --Flag the bot button to false
playerWinFlag = false     --Flags when player wins    
botWinFlag = false        --Flags when bot wins
gameDraw = false          --Flags when game is draw
displayLevel = false      --Flag the "level text" that is displayed on the game (left top corner)
myArray={}                --Stores the placement of player's crosses(X) within the grid
botArray={}               --Stores the placement of bot's noughts(O) within the grid
matchCountPlayer = 0      --Counts the player's matching moves to win
matchCountBot = 0         --Counts the bot's matching moves to win
countX = 0                --Counts the X's
countO = 0                --Counts the O's
replayCount = 0           --Counts the overlaid X's and O's for replaying


--- EASY (win/lose/draw) Scores initialized to 0
winEasy = 0
lostEasy = 0
drawEasy = 0
--- MEDIUM (win/lose/draw)
winMed = 0
lostMed = 0
drawMed = 0
--- HARD (win/lose/draw)
winHard = 0
lostHard = 0
drawHard = 0

----------                              ----------
--             DRAW LINES FOR BOARD             --
-------------------------------------------------- 
--Left Line
lline = d.newLine(mainGroup, w40,h20,w40,h80 )
lline.strokeWidth = 3
lline:setStrokeColor(0.8,0,0.3) 
--Right Line
rline = d.newLine(mainGroup, w60,h20,w60,h80 )
rline.strokeWidth = 3
rline:setStrokeColor(0.8,0,0.3) 
--Bottom Line
bline = d.newLine(mainGroup, w20,h40,w80,h40 )
bline.strokeWidth = 3
bline:setStrokeColor(0.8,0,0.3) 
--Top Line
tline = d.newLine(mainGroup, w20,h60,w80,h60 )
tline.strokeWidth = 3
tline:setStrokeColor(0.8,0,0.3) 

----------                              ----------
-- PLACE BOARD COMPARTMENT DIMENSIONS IN TABLE  --
-------------------------------------------------- 
board ={                          -- 0 is put as an Empty Square       
{"tl",1, w20,h40,w40,h20,0},      --TOP LEFT        
{"tm",2, w40,h40,w60,h20,0},      --TOP MIDDLE  
{"tr",3, w60,h40,w80,h20,0},      --TOP RIGHT
{"ml",4, w20,h60,w40,h40,0},      --MIDDLE LEFT
{"mm",5, w40,h60,w60,h40,0},      --MIDDLE MIDDLE
{"mr",6, w60,h60,w80,h40,0},      --MIDDLE RIGHT
{"bl",7, w20,h80,w40,h60,0},      --BOTTOM LEFT
{"bm",8, w40,h80,w60,h60,0},      --BOTTOM MIDDLE
{"br",9, w60,h80,w80,h60,0}       --BOTTOM RIGHT
}

----------                              ----------
--          WINNING STRATEGY IN TABLE           --
-------------------------------------------------- 
winArray ={
    {1,2,3},    --1st ROW IN THE GRID
    {4,5,6},    --2nd ROW
    {7,8,9},    --3rd ROW
    {1,4,7},    --1st COLUMN   
    {2,5,8},    --2nd COLUMN
    {3,6,9},    --3rd COLUMN
    {1,5,9},    --TOP LEFT, MIDDLE MIDDLE, BOTTOM RIGHT
    {3,5,7}     --TOP RIGHT, MIDDLE MIDDLE, BOTTOM LEFT
}

----------                              ---------
--             TABLE FOR SCORES                --
-------------------------------------------------
--- 3D array table for the Scores
local tableScore={
	{0,0,0},	--Easy level (wins/loses/draws)
	{0,0,0},	--Medium level (wins/loses/draws)
	{0,0,0}		--Hard level (wins/loses/draws)
}

----------                              ----------
--          READ THE FILE FOR SCORES            --
-------------------------------------------------- 
local function loadScores()
    local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        tableScore = json.decode( contents )
	end	
--- Level Easy scores will be in the 1st row of the array	
	  winEasy = tableScore[1][1]      --Assign scores of wins to the 1st index
	  lostEasy = tableScore[1][2]	    --Assign scores of loses to the 2nd index
	  drawEasy = tableScore[1][3]     --Assign scores of draws to the 3rd index

--- Level Medium scores will be in the 2nd row of the array	
    winMed = tableScore[2][1]
	  lostMed = tableScore[2][2]
	  drawMed = tableScore[2][3]

--- Level Hard scores will be in the 3rd row of the array	
    winHard = tableScore[3][1]
	  lostHard = tableScore[3][2]
	  drawHard = tableScore[3][3]
end

--- Write the scores
local function saveScores(table)
    local file = io.open( filePath, "w" )
    if file then
        file:write( json.encode( table ) )
        io.close( file )
    end
end

--- Displays which level you are in while playing the game
local function displayLevelText()
    if displayLevel == true then    --To display text, checks if the display text is flagged to true
        if level == 1 then          --If the level selected is EASY
            local easyText = display.newText( uiGroup, "Level: EASY", 45, 20,  native.systemFontBold, 16 )  --Display Level:EASY
                  easyText:setFillColor(0.8,0,0.3)
        elseif level == 2 then      --If the level selected is MEDIUM
            local medText = display.newText( uiGroup, "Level: MEDIUM", 45, 20,  native.systemFontBold, 16 ) --Display Level:Medium
                  medText:setFillColor(0.8,0,0.3)
        elseif level == 3 then      --If the level selected is HARD
            local hardText = display.newText( uiGroup, "Level: HARD", 45, 20,  native.systemFontBold, 16 )  --Display Level:HARD
                  hardText:setFillColor(0.8,0,0.3)
        end
    end
end

--- Replays the WIN / LOST / DRAW Text 
local function replayImage()
    imageGroup.isVisible = true     --Makes the WIN/LOST/DRAW Text visible after replaying
    menuButton.isVisible = true     --Menu button will be visible after replaying
    restartButton.isVisible = true  --Restart button will be visible after replaying
    replay.isVisible = false        --"Replay Text" won't be visible after replaying
    replayButton.isVisible = true   --Replay button will be visible after replaying
end

--- Displays the X's and O's one by one
local function replayGame(number)
    replayGroup[number].isVisible = true  --Makes the X's and O's visible when replaying
end

----------                              ----------
--              PLAYER'S TURN                   --
-------------------------------------------------- 
function humanPlay(event)  
    --If player nor bot hasn't won and nor the game is a draw then play
    if (playerWinFlag == false) and (botWinFlag == false) and (gameDraw == false) then                  
        for t=1,9 do 
            if event.x > board[t][3] and event.x < board [t][5] then 
                if event.y < board[t][4] and event.y > board[t][6] then
                    --Play sound when square is touched
                    media.playSound( "audio/notify.wav" )                            
                    --If a square is empty (0) then add X
                    if board[t][7] == 0 then                                  
                        X = d.newText(xGroup, "X", board[t][3]+32, board[t][6]+50)        
                        X:setFillColor(0.9,0,0.4 )
                        X.size = 80
                        --Adds an overlaid X for the Replay
                        X1 = d.newText(replayGroup, "X", board[t][3]+32, board[t][6]+50)        
                        X1:setFillColor(0.9,0,0.4 )
                        X1.size = 80
                        --Then flag that square with X as 1
                        board[t][7] = 1 
                        --Assign that square number into a variable, needed for undo
                        placementX = t   

                        --Count the flagged X's
                        if board[t][7] == 1 then                            
                            countX = countX + 1
                            replayCount = replayCount + 1  --Another Count needed for replay
                        end

                        --After the first move of the player, Make the undo button visible
                        undoButton.isVisible = true
                        --Get the time when player makes a move, needed for undo
                        timeBefore = system.getTimer()
                        --Inserts the square's number of the placement of player's crosses(X) into an array
                        table.insert( myArray, board[t][2] )  
                        --Undo condition is set to false (This will make the player to undo his move only once not twice within 5 secs)
                        undoCondition = false
                        --Tracks player's moves and compares with the winning strategy
                        playerWin()     
                        
                        --If the player hasn't won then bot continues to play
                        if playerWinFlag == false then
                            botPlay()      --Bot's turn  
                        end
                    end
                end
            end
        end
    end
end

----------                              ----------
--                BOT'S SIGN [O]                --
--------------------------------------------------
function signO(square) --Square paramater is passed as the square number of the grid
    O = d.newText(oGroup, "O",board[square][3]+32,board[square][6]+50)
    O:setFillColor(0.2,0.6,0.9)
    O.size = 80 
    --Adds an overlaid O for the Replay
    O1 = d.newText(replayGroup, "O",board[square][3]+32,board[square][6]+50)
    O1:setFillColor(0.2,0.6,0.9)
    O1.size = 80 
    
    --Flag that square with O as 2
    board[square][7] = 2
    --Assign that square number into a variable, needed for undo
    placementO = square

    --Count the flagged O's
    if board[square][7] == 2 then
        countO = countO + 1
        replayCount = replayCount + 1   --Another Count needed for replay
    end
      
    --Inserts the square's number of the placement of bot's noughts(O) into an array
    table.insert( botArray, board[square][2] )
    undoCondition = false   --Undo button is set to false
end

----------                              ----------
--             BOT PLAY RANDOMLY                --
--------------------------------------------------
function botPlayEasy()
    for r=1,9 do
        r=math.random( 1,9 )
        if board[r][7] == 0 then
            signO(r)    --Takes r as the square number
            break
        end
    end
end

----------                              ----------
--               BOT PLAY HARD                  --
--------------------------------------------------
function botPlayHard()
--- 1) Check if bot has two in a row         
    for c = 1,8 do   --Get the index numbers from [winArray] table
        index1 = board[winArray[c][1]] [7]  --Assign the number of the 1st index from winArray table 
        index2 = board[winArray[c][2]] [7]  --Assign the number of the 2nd index from winArray table 
        index3 = board[winArray[c][3]] [7]  --Assign the number of the 3rd index from winArray table 

        if index1 == 2 and index2 == 2 and index3 == 0 then     --Bot Plays on 3rd squares
            signO(winArray[c][3])
            return
        elseif index2 == 2 and index3 == 2 and index1 == 0 then  --Bot Plays on 1st squares
            signO(winArray[c][1])
            return
        --Bot has two lines of two in a row
        elseif index1 == 2 and index3 == 2 and index2 == 0 then  --Bot Plays on middle squares
            signO(winArray[c][2])
            return
        end 
    end

--- 2) Check if player has two in a row  
    for d = 1,8 do   
        index1 = board[winArray[d][1]] [7]
        index2 = board[winArray[d][2]] [7]
        index3 = board[winArray[d][3]] [7]
 
        if index1 == 1 and index2 == 1 and index3 == 0 then  --Bot Blocks every 1st sqaures
            signO(winArray[d][3])
            return
        elseif index2 == 1 and index3 == 1 and index1 == 0 then  --Bot Blocks every 3rd squares
            signO(winArray[d][1])
            return

        --Block when player has two lines of two in a row             
        elseif index1 == 1 and index3 == 1 and index2 == 0 then  --Bot Blocks every middle sqaures
            signO(winArray[d][2])
            return
        end
    end

--- 3) Check if center square is free   
    if board[5][7] == 0 then  
        signO(5)    --Bot plays on the center square
        return
    end

--- 4) Check if player has played in a corner, Play on the opposite corner 
    
    one={   -- Opposite corners
        {1,9}, {3,7}
    }
 
    for x=1,2  do
    --Check IF the 1st index (square number) in that table is played by the player then 
        if board[one[x][1]][7] == 1 and board[one[x][2]][7] == 0 then     
            signO(one[x][2])   --Bot plays on the 2nd index which is the OPPOSITE CORNER
            return
    --ELSE check IF the 2nd index is played by the player then 
        elseif board[one[x][2]][7] == 1 and board[one[x][1]][7] == 0 then
            signO(one[x][1])    --Bot plays on the 1st index
            return 
        end
    end

--- 5) Check if there's an empty corner then bot plays there  
        if board[1][7] == 0 then    -- 1st corner
            signO(1)
            return
        elseif board[3][7] == 0 then    -- 3rd corner
            signO(3)
            return
        elseif board[9][7] == 0 then    -- 9th corner
            signO(9)
            return
        elseif board[7][7] == 0 then    -- 7th corner
            signO(7)
            return
        end

--- 6) Otherwise bot plays on any empty square
    for r=1,9 do
        r=math.random( 1,9 )
        if board[r][7] == 0 then
            signO(r)    --Takes r as the square number
            return
        end
    end
end

----------                              ----------
--               BOT'S TURN                     --
--------------------------------------------------
function botPlay() 
    if (botWinFlag == false) and (playerWinFlag == false) and (gameDraw == false) then  -- Play if nobody has won nor game is a draw
        if level  == 1 then     --[[ EASY is selected ]]
             botPlayEasy()   -- Bot plays randomly

        elseif level == 2 then   --[[ MEDIUM is selected ]]
            -- Bot's Odd Turns
            if (countO % 2 == 0) then -- Check odd turns from bot's move count
                botPlayEasy()   -- Bot plays randomly
            else  -- Bot's Even Turns
                botPlayHard()   -- Bot plays hard
            end

        elseif level == 3 then   --[[ HARD is selected ]]
            botPlayHard()   -- Bot plays hard
        end
    end
end

----------                              ----------
--       IDENTIFYING WINNING FOR PLAYER         --
--------------------------------------------------
function playerWin()
    --For loop to go through winArray ( winning strategy )
    for k=1,8 do
        --Match count becomes 0 after every iteration
        matchCountPlayer = 0    

        --For loop to go through myArray ( player's placement of X's )
        for j=1, #myArray do
            if winArray[k][1] == myArray[j] then          --Compare winning strategy array with player's placement array
                matchCountPlayer = matchCountPlayer + 1   --Adds 1 to match count when there's a match

            elseif winArray[k][2] == myArray[j] then
                matchCountPlayer = matchCountPlayer + 1

            elseif winArray[k][3] == myArray[j] then
                matchCountPlayer = matchCountPlayer + 1

            end

            --If match count is greater or equal to 3 and bot hasn't won then player wins
            if matchCountPlayer >= 3 and botWinFlag == false and playerWinFlag == false then
                local youWon = display.newImageRect( imageGroup, "images/youWin.png", 190, 60 ) --Display "YOU WON" Text
                      youWon.x = display.contentCenterX
                      youWon.y = display.contentCenterY-170

                media.playSound( "audio/win.wav" )     --Play sound when player wins
                playerWinFlag = true                   --Flag player win to true
                undoButton.isVisible = false           --When player wins, Undo button disappears
                replayButton.isVisible = true          --When player wins, Replay button will be visible
                
                 -- Increase wins score according to each selected level
                if level == 1 then         --[[ EASY is selected ]]
                    winEasy = winEasy + 1   -- Increment the wins by 1 for easy
                elseif level == 2 then     --[[ MEDIUM is selected ]]
                    winMed = winMed + 1     -- Increment the wins by 1 for medium
                elseif level == 3 then     --[[ HARD is selected ]]
                    winHard = winHard + 1   -- Increment the wins by 1 for hard
                end
            end 
        end
    end
end


----------                              ----------
--         IDENTIFYING WINNING FOR BOT          --
--------------------------------------------------
function botWin()
    --For loop to go through winArray ( winning strategy )
    for k=1,8 do
        --Match count becomes 0 after every iteration
        matchCountBot = 0

        --For loop to go through botArray ( bot's placement of O's)
        for j=1, #botArray do
            if winArray[k][1] == botArray[j] then       --Compare winning strategy array with bot's placement array
                matchCountBot = matchCountBot + 1       --Adds 1 to match count when there's a match

            elseif winArray[k][2] == botArray[j] then
                matchCountBot = matchCountBot + 1

            elseif winArray[k][3] == botArray[j] then
                matchCountBot = matchCountBot + 1
            end
            --If match count is greater or equal to 3 and player hasn't won then bot wins
            if matchCountBot >= 3 and playerWinFlag == false and botWinFlag == false then
                local botWon = display.newImageRect(imageGroup, "images/botWin.png", 190, 60 )  --Display "BOT WON" Text
                      botWon.x = display.contentCenterX
                      botWon.y = display.contentCenterY-170

                media.playSound( "audio/loose.wav" )    --Play sound when bot wins
                botWinFlag = true                       --Flag bot win to true
                undoButton.isVisible = false            --When bot wins, Undo button disappears
                replayButton.isVisible = true           --When bot wins, Replay button will be visible

                -- Increase looses score according to each selected level
                if level == 1 then
                    lostEasy = lostEasy + 1     --Increment the looses by 1 for easy
                elseif level == 2 then
                    lostMed = lostMed + 1       --Increment the looses by 1 for medium
                elseif level == 3 then
                    lostHard = lostHard + 1     --Increment the looses by 1 for hard
                end
            end 
        end
    end
end

----------                              ----------
--            IDENTIFYING A DRAW                --
--------------------------------------------------
function draw()

    --If Player hasn't won and bot hasn't won AND 
    --player's X count is equal to 5 OR bot's O count is equal to 5 THEN it's a draw
    if (playerWinFlag == false) and (botWinFlag == false) and (gameDraw == false) and ((countX == 5) or (countO == 5)) then
        local draw = display.newImageRect(imageGroup, "images/draw.png", 160, 70 )  --Displays "DRAW" Text
              draw.x = display.contentCenterX
              draw.y = display.contentCenterY-170

        media.playSound( "audio/draw.wav" )  --Play sound when it's a draw
        gameDraw = true      --Flag game draw to true
        undoButton.isVisible = false    --Undo button disappears
        replayButton.isVisible = true   --Restart button appears

        -- Increase draws score according to each selected level
        if level == 1 then
            drawEasy = drawEasy + 1     --Increment the draws by 1 for easy
        elseif level == 2 then
            drawMed = drawMed + 1       --Increment the draws by 1 for medium
        elseif level == 3 then
            drawHard = drawHard + 1     --Increment the draws by 1 for hard
        end
    end
end

----------                              ----------
--            BOT BUTTON HANDLER                --
--------------------------------------------------
local function handleBotButtonEvent( event )
    if ("ended" == event.phase) then          --When the bot button is pressed then
        media.playSound( "audio/bot.mp3" )    --Plays a sound 
        botPressed = true                     --Flags bot button to true
        select.isVisible = false              --Hides the Choose statement 
        buttonBot.isVisible = false           --Hides the bot button 
        buttonHuman.isVisible = false         --Hides the human button
        displayLevel = true                   --Display level variable sets to True when pressed
        displayLevelText()                    --Goes to the display level text function
        botPlay()                             --Bot starts playing
    end
end

----------                              ----------
--                BOT BUTTON                    --
--------------------------------------------------
buttonBot = widget.newButton(
{
    onEvent = handleBotButtonEvent,
    width = 70,
    height = 70,
    defaultFile = "images/bot2.png",
    overFile = "images/bot21.png"
}
)
buttonBot.x=display.contentCenterX+120
buttonBot.y=display.contentCenterY-200
uiGroup:insert(buttonBot)

----------                              ----------
--            HUMAN BUTTON HANDLER              --
--------------------------------------------------
local function handleHumanButtonEvent( event )
    if ("ended" == event.phase) then          --When human button is pressed then
        media.playSound( "audio/yay.wav" )    --Plays a sound
        humanPressed = true                   --Flag human button to true
        select.isVisible = false              --Hides the Choose statement
        buttonHuman.isVisible = false         --Hides the human button
        buttonBot.isVisible = false           --Hides the bot button
        displayLevel = true                   --Display level variable sets to True when pressed
        displayLevelText()                    --Goes to the display level text function
    end
end

----------                              ----------
--               HUMAN BUTTON                   --
--------------------------------------------------
buttonHuman = widget.newButton(
{
    onEvent = handleHumanButtonEvent,
    width = 78,
    height = 78,
    defaultFile = "images/human1.png",
    overFile = "images/human2.png"
}
)
buttonHuman.x=display.contentCenterX-120
buttonHuman.y=display.contentCenterY-200
uiGroup:insert(buttonHuman)


----------                              ----------
--             UNDO BUTTON HANDLER              --
--------------------------------------------------
local function undoButtonEvent( event )
    if ("ended" == event.phase) then            
        timeNow = system.getTimer()         --Get the time of Undo button event
        time = timeNow - timeBefore         --Get the difference between the event occured time and the time of placing 'X'
        
        --The new Time should be less than 5 seconds and undo condition should false
        if time < 5000 and undoCondition == false then
            xGroup[countX]:removeSelf()    --Remove the move ('X') that was made by the player
            countX = countX - 1            --Decrement the count by 1

            replayGroup[replayCount]:removeSelf()   --Remove the overlaid move ('X')
            replayCount = replayCount - 1           --Decrement the count by 1 of the replay count

            board[placementX][7] = 0    --Set that Square back to 0 (Empty)
            table.remove( myArray )     --Remove it from the player's array

            ---Do the same with Bot's placement of 'O'
            oGroup[countO]:removeSelf()
            countO = countO - 1

            replayGroup[replayCount]:removeSelf()
            replayCount = replayCount - 1

            board[placementO][7] = 0
            table.remove( botArray )

            undoCondition = true  --After that condition occurs, Undo condition it set to true           
        end  
    end
end

----------                              ----------
--                UNDO BUTTON                   --
--------------------------------------------------
    undoButton = widget.newButton(
        {
            label = "UNDO", fontSize=15, font="Arial Black",
            labelColor = {default={ 1, 1, 1 }, over={ 1, 1, 1 }}, 
            onEvent = undoButtonEvent,
            shape = "roundedRect",
            width = 85,
            height = 25,
            cornerRadius = 3,
            fillColor = {default={1,0.4,0.5}, over={0,0,0}}

        }
    )
    undoButton.x = display.contentCenterX
    undoButton.y = display.contentCenterY+210
    undoButton.isVisible = false
    uiGroup:insert(undoButton)

----------                              ----------
--           REPLAY BUTTON HANDLER              --
--------------------------------------------------
local function replayButtonEvent( event )

    if ("ended" == event.phase) then
        local delayTime = 450               --Delay time for each move in replaying
        menuButton.isVisible = false        --Menu button disappears when replay button is pressed
        restartButton.isVisible = false     --Restart button disappears
        replayButton.isVisible = false      --Replay button disappears
        
        --Displays "Replaying" text when its replaying
        replay = display.newImageRect(uiGroup, "images/replayPic.png", 150, 65)
        replay.x = display.contentCenterX+110
        replay.y = display.contentCenterY-215

        xGroup:removeSelf()  --Remove the X's 
        oGroup:removeSelf()  --Remove the O's
        imageGroup.isVisible = false    --Win/Lose/Draw text won't be visible

        for k = 1, replayCount do
            replayGroup[k].isVisible = false  --The 'X's and 'O's in the replayGroup won't be visible 
        end
        
        for k = 1, replayCount do 
            local replayIt = function() return replayGame(k) end  --Displays the X's and O's one by one
            timer.performWithDelay(delayTime, replayIt)   --Delay time for the  move 
            delayTime = delayTime + 550   --Delay time for the next move 
        end
        timer.performWithDelay(delayTime, replayImage)  --After X's & O' - Delay time for the win/loose/draw text 
    end
end

----------                              ----------
--               REPLAY BUTTON                  --
--------------------------------------------------
    replayButton = widget.newButton(
        {
            label = "RE-PLAY", fontSize=15, font="Arial Black",
            labelColor = {default={ 1, 1, 1 }, over={ 1, 1, 1 }}, 
            onEvent = replayButtonEvent,
            shape = "roundedRect",
            width = 85,
            height = 25,
            cornerRadius = 2,
            fillColor = {default={1,0.4,0.5}, over={0,0,0}}
        }
    )
    replayButton.x = display.contentCenterX
    replayButton.y = display.contentCenterY+175
    replayButton.isVisible = false
    uiGroup:insert(replayButton)


----------                              ----------
--            EVENT LISTERNER FILL              --
--------------------------------------------------
local function fill (event)
  if event.phase == "began" then
        if (humanPressed == true) then      --Initially if human button is pressed, player goes first

            humanPlay(event)    --Calls human play function for player to play ( Inside humanPlay function calls the boyPlay function )
            playerWin()         --Calls player win function if player wins
            botWin()            --Calls bot win function if bot wins
            draw()              --Calls draw function if there's a draw

        elseif (botPressed == true) then    --Initially if bot button is pressed, bot goes first

            humanPlay(event)
            playerWin()
            botWin()
            draw()
        end
    end
end

--- GO BACK TO MENU FUNCTION
local function gotoMenu()
	composer.gotoScene("menu", { time=800, effect="fromTop" })  --- GOES TO THE MENU SCENE
end

--- RE-PLAY THE GAME AGAIN
local function gotoRestart()
	    composer.gotoScene("load", { time=800, effect="crossFade" })  --- GOES TO THE LOAD SCENE 
end

----------                              ----------
--           SCENE EVENT FUNCTIONS              --
--------------------------------------------------

-------------Create Scene---------------
function scene:create( event )

	local sceneGroup = self.view

    loadScores()

    -- Set up display groups
    sceneGroup:insert( backGroup )
    sceneGroup:insert( mainGroup )
    sceneGroup:insert( uiGroup ) 
    sceneGroup:insert( xGroup )
    sceneGroup:insert( oGroup )
    sceneGroup:insert( imageGroup )
    sceneGroup:insert( replayGroup )

    --- Background Image      
      background = display.newImageRect( backGroup, "background.png", 400, 800 )
      background.x = display.contentCenterX
      background.y = display.contentCenterY

    --- Select Statement 
      select = display.newImageRect(uiGroup, "images/select.png", 150, 65)
      select.x = display.contentCenterX
      select.y = display.contentCenterY-190

    --- Menu
      menuButton = display.newImageRect(uiGroup, "images/menu.png", 95, 45  )
      menuButton.x = display.contentCenterX+115
	  menuButton.y = 450

    -- Restart
      restartButton = display.newImageRect(uiGroup, "images/restart.png", 110, 38  )
      restartButton.x = display.contentCenterX-115
	  restartButton.y = 450

    --- Returns you to the Menu when tapped
	  menuButton:addEventListener( "tap", gotoMenu ) 
    --- Returns you back to the game to play from the start when tapped
      restartButton:addEventListener( "tap", gotoRestart )    
end

-------------Show Scene---------------
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		Runtime:addEventListener("touch",  fill) 
	end
end

-------------Hide Scene---------------
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

    elseif ( phase == "did" ) then

        local finalScore = {
            {winEasy, lostEasy, drawEasy},
            {winMed, lostMed, drawMed},
            {winHard, lostHard, drawHard}
        }
        --Takes final Score as parameter in order to write the updated scores
         saveScores(finalScore)
         --Remove event listener and the game scene
         Runtime:removeEventListener( "touch", fill )
		 composer.removeScene( "game" )
	end
end

-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
end

----------                              ----------
--       SCENE EVENT FUNCTION LISTENERS         --
--------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
