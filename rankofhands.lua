--[[
Rank of hands

1 = High Card
2 = Pair
3 = Two Pair
4 = Three of a Kind
5 = Straight
6 = Flush
7 = Full House
8 = Four of a Kind
9 = Straight Flush
10 = Royal Flush
]]

function checkHand(cards)
    hand = {0,0}
    --sortedCardList = sortCards(cards)
end

function sortCards(oldcards)
    cards = oldcards
    local tmp = nil
    local sorted = false
    for x = 1, #cards do
        sorted = false
        for y = 1, (#cards - x) do
            if cards[y][1] < cards[y + 1][1] then
                tmp = cards[y]
                cards[y] = cards[y+1]
                cards[y+1] = tmp
                sorted = true
            end
        end
        if (sorted == false) then
            break
        end
    end
    return cards
end