| Type            | Activity      | Status | Latest Revision  |
|-----------------|---------------|--------|------------------|
| Research        | On-Going      | Active | R-1, 2023-11-19  |

# Arbitrage Opportunities in Decentralized Exchanges

**Title:** *Arbitrage Opportunities in Decentralized Exchanges with Three Assets*

### Abstract:
This research aims to explore and formulate the conditions for arbitrage opportunities in decentralized exchanges involving three different assets. The study focuses on assets denoted as asset1, asset2, and asset3, with asset1 and asset2 representing stable coins with prices near or equal to a base price of 1 unit. The goal is to identify instances where the price of asset3 creates an opportunity for profitable trading by buying at a lower price and selling at a higher price within the given time frame.

### Introduction:
Decentralized exchanges (DEX) have gained prominence in the cryptocurrency market, allowing users to trade assets without relying on traditional intermediaries. Arbitrage, the practice of exploiting price differences in different markets, can be a lucrative strategy for traders. This research investigates arbitrage opportunities in the context of a DEX with three assets.

### Mathematical Formulation:
Let $\( p \)$ represent time, and $\( \text{basePrice} \)$ denote the stable price of 1 unit. The prices of the three assets at time $\( p \)$ are $\( \text{price1}(p) \)$, $\( \text{price2}(p) \)$, and $\( \text{price3}(p) \)$ for asset1, asset2, and asset3, respectively.

The arbitrage condition can be mathematically expressed as:
$\[ \text{price3}(p) < \min(\text{price1}(p), \text{price2}(p)) \]$

This inequality signifies an opportunity for profitable trading when the price of asset3 is lower than the minimum of the prices of asset1 and asset2.

Now, Let's extend the "Mathematical Formulation" to provide a more detailed explanation of the mathematical conditions and introduce additional variables for a comprehensive analysis.

### Deep in Mathematical Formulation:
Let $\( p \)$ represent time, and $\( \text{basePrice} \)$ denote the stable price of 1 unit. The prices of the three assets at time $\( p \)$ are $\( \text{price1}(p) \)$, $\( \text{price2}(p) \)$, and $\( \text{price3}(p) \)$ for asset1, asset2, and asset3, respectively.

Let $\( \text{arbitrageCondition}(p) \)$ be a binary function representing the arbitrage condition at time $\( p \)$:

<!--
\[ \text{arbitrageCondition}(p) = \begin{cases} 1 & \text{if } \text{price3}(p) < \min(\text{price1}(p), \text{price2}(p)) \\ 0 & \text{otherwise} \end{cases} \]
-->

[**arbitrageCondition(p)={10​if price3(p)<min(price1(p),price2(p))otherwise​0**]
```
arbitrageCondition(p)=
1: if price3(p)<min(price1(p),price2(p))
0: otherwise
```
This function evaluates to 1 when an arbitrage opportunity is present and 0 otherwise.

To quantify the potential profit from exploiting an arbitrage opportunity, introduce the concept of a trade. Let $\( \text{tradeAmount} \)$ represent the quantity of asset3 traded, $\( \text{buyPrice} \)$ denote the buying price, and $\( \text{sellPrice} \)$ represent the selling price. The profit $\( \text{profit}(p) \)$ from a single trade at time $\( p \)$ can be expressed as:

$\[ \text{profit}(p) = \text{tradeAmount} \cdot (\text{sellPrice} - \text{buyPrice}) \]$

To maximize profit, traders might consider executing multiple trades within a given time period $\( \Delta p \)$. The total profit $\( \text{totalProfit} \)$ during this interval can be expressed as the sum of profits from individual trades:

$\[ \text{totalProfit}(\Delta p) = \sum_{i=1}^{n} \text{profit}(p_i) \]$

where $\( n \)$ is the number of trades executed during $\( \Delta p \)$, and $\( p_i \)$ represents the time of the $\( i \)-th$ trade.

### Example code:
Arbitrage path finding from a dex
> code for example

- Javascript version
```js
function findArb(pairs, tokenIn, tokenOut, maxHops, currentPairs, path, bestTrades, count = 5) {
    for (let i = 0; i < pairs.length; i++) {
        let newPath = [...path];
        let pair = pairs[i];

        if (!(pair.token0.address === tokenIn.address) && !(pair.token1.address === tokenIn.address)) {
            continue;
        }

        if (pair.reserve0 / Math.pow(10, pair.token0.decimal) < 1 || pair.reserve1 / Math.pow(10, pair.token1.decimal) < 1) {
            continue;
        }

        let tempOut = (tokenIn.address === pair.token0.address) ? pair.token1 : pair.token0;
        newPath.push(tempOut);

        if (tempOut.address === tokenOut.address && path.length > 2) {
            let { Ea, Eb } = getEaEb(tokenOut, currentPairs.concat([pair]));
            let newTrade = { route: currentPairs.concat([pair]), path: newPath, Ea, Eb };

            if (Ea && Eb && Ea < Eb) {
                newTrade.optimalAmount = getOptimalAmount(Ea, Eb);

                if (newTrade.optimalAmount > 0) {
                    newTrade.outputAmount = getAmountOut(newTrade.optimalAmount, Ea, Eb);
                    newTrade.profit = newTrade.outputAmount - newTrade.optimalAmount;
                    newTrade.p = Math.floor(newTrade.profit) / Math.pow(10, tokenOut.decimal);
                } else {
                    continue;
                }

                bestTrades = sortTrades(bestTrades, newTrade);
                bestTrades.reverse();
                bestTrades = bestTrades.slice(0, count);
            }
        } else if (maxHops > 1 && pairs.length > 1) {
            let pairsExcludingThisPair = pairs.slice(0, i).concat(pairs.slice(i + 1));
            bestTrades = findArb(pairsExcludingThisPair, tempOut, tokenOut, maxHops - 1, currentPairs.concat([pair]), newPath, bestTrades, count);
        }
    }
    return bestTrades;
}
```

- Solidity example
```solidity
// Assuming required utility functions are available in the contract
// getEaEb, getOptimalAmount, getAmountOut, sortTrades

function findArb(
    Pair[] memory pairs,
    Token memory tokenIn,
    Token memory tokenOut,
    uint256 maxHops,
    Pair[] memory currentPairs,
    Token[] memory path,
    Trade[] memory bestTrades,
    uint256 count
) public pure returns (Trade[] memory) {
    for (uint256 i = 0; i < pairs.length; i++) {
        Token[] memory newPath = new Token[](path.length);
        for (uint256 j = 0; j < path.length; j++) {
            newPath[j] = path[j];
        }

        Pair memory pair = pairs[i];

        if (!(pair.token0.address == tokenIn.address) && !(pair.token1.address == tokenIn.address)) {
            continue;
        }

        if (pair.reserve0 / (10**pair.token0.decimal) < 1 || pair.reserve1 / (10**pair.token1.decimal) < 1) {
            continue;
        }

        Token memory tempOut = (tokenIn.address == pair.token0.address) ? pair.token1 : pair.token0;
        newPath[newPath.length++] = tempOut;

        if (tempOut.address == tokenOut.address && path.length > 2) {
            (uint256 Ea, uint256 Eb) = getEaEb(tokenOut, currentPairs.concat([pair]));
            Trade memory newTrade = Trade({
                route: currentPairs.concat([pair]),
                path: newPath,
                Ea: Ea,
                Eb: Eb,
                optimalAmount: 0,
                outputAmount: 0,
                profit: 0,
                p: 0
            });

            if (Ea > 0 && Eb > 0 && Ea < Eb) {
                newTrade.optimalAmount = getOptimalAmount(Ea, Eb);

                if (newTrade.optimalAmount > 0) {
                    newTrade.outputAmount = getAmountOut(newTrade.optimalAmount, Ea, Eb);
                    newTrade.profit = newTrade.outputAmount - newTrade.optimalAmount;
                    newTrade.p = newTrade.profit / (10**tokenOut.decimal);
                } else {
                    continue;
                }

                bestTrades = sortTrades(bestTrades, newTrade);
                bestTrades = bestTrades.slice(0, int256(count));
            }
        } else if (maxHops > 1 && pairs.length > 1) {
            Pair[] memory pairsExcludingThisPair = new Pair[](pairs.length - 1);
            uint256 index = 0;
            for (uint256 j = 0; j < pairs.length; j++) {
                if (j != i) {
                    pairsExcludingThisPair[index++] = pairs[j];
                }
            }

            bestTrades = findArb(pairsExcludingThisPair, tempOut, tokenOut, maxHops - 1, currentPairs.concat([pair]), newPath, bestTrades, count);
        }
    }
    return bestTrades;
}
/*
Solidity does not support dynamic arrays as function parameters, so I've used fixed-size arrays and modified the code accordingly. Adjustments might be necessary based on your specific Solidity contract and utility functions.
*/
```

### Methodology:
1. **Data Collection:** Collect historical price data for asset1, asset2, and asset3 over different time intervals.
2. **Analysis:** Apply the formulated mathematical condition to identify instances of potential arbitrage opportunities.
3. **Simulation:** Simulate trading strategies based on identified opportunities to assess their profitability.

### Expected Outcomes:
The research expects to provide a clear understanding of the mathematical conditions under which arbitrage opportunities arise in a DEX with three assets. The outcomes will contribute to the development of trading strategies for maximizing profit in decentralized financial ecosystems.

### Conclusion:
This research addresses the practical implications of arbitrage opportunities in decentralized exchanges, offering insights for traders and researchers in the cryptocurrency space. By formulating mathematical conditions, this study aims to contribute to the ongoing discourse on effective trading strategies in dynamic and evolving decentralized markets.

---

[LotusChain](https://lotuschain.org) | [Lotus Lab](https://github.com/blue-lotus-lab) | contact@lotuschain.org

> All researches made by LotusResearchLab
