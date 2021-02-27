
local ScenarioFramework = import('/lua/ScenarioFramework.lua');
local bonusAsFractionOfAverageIncome = 0.5

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

local function countTotalMassIncome(playerTables)
    local total = 0
    for _, player in playerTables do
        total = total + GetArmyBrain(player.strArmy):GetEconomyIncome("MASS")
    end
    return total
end

local function countAlivePlayers(playerTables)
    local playerCount = 0
    for _, player in playerTables do
        if not player.isDefeated then
            playerCount = playerCount + 1
        end
    end
    return playerCount
end

local function countAverageMassIncome(playerTables)
    local alivePlayerCount = countAlivePlayers(playerTables)

    if alivePlayerCount == 0 then
        return 0
    end

    return countTotalMassIncome(playerTables) / alivePlayerCount
end

local function giveBonusToKings(playerTables, amountOfKings)
    local massBonus = countAverageMassIncome(playerTables) * bonusAsFractionOfAverageIncome / amountOfKings

    for _, player in playerTables do
        if player.isKing then
            GetArmyBrain(player.strArmy):GiveResource('MASS', massBonus)
        end
    end
end

local function giveBonusToContestants(playerTables)
    local amountOfContestants = countContestants(playerTables)

    if amountOfContestants > 0 then
        local massBonus = countAverageMassIncome(playerTables) * bonusAsFractionOfAverageIncome / amountOfContestants

        for _, player in playerTables do
            if player.isContesting then
                GetArmyBrain(player.strArmy):GiveResource('MASS', massBonus)
            end
        end
    end
end

function Tick(playerTables)
    local amountOfKings = countKings(playerTables)

    if amountOfKings > 0 then
        giveBonusToKings(playerTables, amountOfKings)
    else
        giveBonusToContestants(playerTables)
    end
end