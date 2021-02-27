
local ScenarioFramework = import('/lua/ScenarioFramework.lua');

-- playerTables = {
--     armies={
--         {
--         canContest=false,
--         canControl=false,
--         commanderOnHill=false,
--         identifier=1,
--         isAllyOfKing=false,
--         isDefeated=false,
--         isKing=false,
--         massOnHill=0,
--         strArmy="ARMY_1",
--         nickname="Jip",
--         scoreAcc=0,
--         scoreSeq=0
--         }
--     },
-- }

local function countContestants(playerTables)
    local contestants = 0
    for _, player in playerTables do
        if player.isContesting then
            contestants = contestants + 1
        end
    end
    return contestants
end

local function countKings(playerTables)
    local kings = 0
    for _, player in playerTables do
        if player.isKing then
            kings = kings + 1
        end
    end
    return kings
end
    
function Tick(playerTables)

    local amountOfContestants = countContestants(playerTables)
    local amountOfKings = countKings(playerTables)

    -- determine total income
    local total = 0 
    for k, player in playerTables do 
        local brain = GetArmyBrain(player.strArmy)
        total = total + brain:GetEconomyIncome("MASS")
    end

    -- if there are any kings
    if amountOfKings > 0 then
        for k, player in playerTables do 
            if player.isKing then 
                -- determine the amount
                local amount = (1.0 / amountOfKings) * 0.10 * total
    
                -- provide resources
                local brain = GetArmyBrain(player.strArmy)
                brain:GiveResource('MASS', amount)
            end
        end
    else 
        -- else, if there are any contestants
        if amountOfContestants > 0 then
            for k, player in playerTables do 
                if player.isContesting then 
                    -- determine the amount
                    local amount = (1.0 / amountOfContestants) * 0.10 * total
    
                    -- provide resources
                    local brain = GetArmyBrain(player.strArmy)
                    brain:GiveResource('MASS', amount)
                end
            end
        end
    end
end